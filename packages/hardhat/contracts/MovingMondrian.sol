// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";
import 'base64-sol/base64.sol';
import './MondrianFrames.sol';
import './MondrianShapes.sol';

//    __  ___         _             __  ___             __    _             
//   /  |/  /__ _  __(_)__  ___ _  /  |/  /__  ___  ___/ /___(_)__ ____  ___
//  / /|_/ / _ \ |/ / / _ \/ _ `/ / /|_/ / _ \/ _ \/ _  / __/ / _ `/ _ \(_-<
// /_/  /_/\___/___/_/_//_/\_, / /_/  /_/\___/_//_/\_,_/_/ /_/\_,_/_//_/___/
//                        /___/  
//
// Fully onchain animated SVG NFT by David Ryan (drcoder.eth, Twitter @davidryan59)
// See: https://en.wikipedia.org/wiki/Piet_Mondrian
// "Mondrian began producing grid-based paintings in late 1919, and in 1920, the style for which he came to be renowned began to appear"
// I've taken the grid style, and added a 2020s crypto twist to it by using SVG anination and generative art.


interface IERC20 {
    function transfer(address _to, uint256 _amount) external returns (bool);
}

contract MovingMondrian is ERC721, Ownable {

	using Strings for uint256;

	// -------------------------------------
	// Owner can change these settings, but this is intended only for fine-tuning straight after OP mainnet deployment.
	// Once ownership is revoked, these settings cannot be updated again.

	// Chain Config
	string public network = "Optimism";

	// Mint Config
    uint256 public mintCost = 100000 * 1000000000; // 100000 gwei, 0.00010 ETH minting cost
	uint256 public mintLimit = 100000;
	uint256 public mintMaxBatchSize = 50;
	uint256 public royaltyBasisPoints = 500; // 5% royalties - part of this goes to Protocol Guild to fund Ethereum core development
	string public externalUrl = "https://WEB_APP_PENDING/token/"; // this will be updated after OP mainnet deployment

	// -------------------------------------

	address payable public beneficiary;
    uint256 private nextTokenId = 1;
	mapping (uint256 => uint256) private generator1; // One generator had insufficient entropy for all the randomness required by global variables and 12 rectangles
	mapping (uint256 => uint256) private generator2; // so I put a 2nd generator in. Now it is really random! :)

	MondrianFrames mf;
	MondrianShapes ms;
    constructor(address initialOwner, address initialBeneficiary, address mfAddress, address msAddress) ERC721("Moving Mondrian", "MONDO") Ownable() {
		// Data for drawing NFTs
		mf = MondrianFrames(mfAddress);
		ms = MondrianShapes(msAddress);

		// Setup owner and beneficiary
		_transferOwnership(initialOwner);
		beneficiary = payable(initialBeneficiary);

		// Dev gets some pre-mint, this has side benefit of making NFTs visible on OpenSea immediately
		_mintTo(initialOwner, mintMaxBatchSize);
		_mintTo(initialOwner, mintMaxBatchSize);
		_mintTo(initialOwner, mintMaxBatchSize);
		_mintTo(initialOwner, mintMaxBatchSize);
	}

    /// @notice Called with the sale price to determine how much royalty
    //          is owed and to whom, this function makes OpenSea royalties work
    /// @param _tokenId - the NFT asset queried for royalty information
    /// @param _salePrice - the sale price of the NFT asset specified by _tokenId
    /// @return receiver - address of who should be sent the royalty payment
    /// @return royaltyAmount - the royalty payment amount for _salePrice
    function royaltyInfo(uint256 _tokenId, uint256 _salePrice) external view returns (address receiver, uint256 royaltyAmount) {
		receiver = beneficiary;
		royaltyAmount = (_salePrice * royaltyBasisPoints) / 10000;
	}

    function _mintTo(address recipient, uint256 numberToMint) private {
		require(0 < numberToMint && numberToMint <= mintMaxBatchSize, "numberToMint must be between 1 and mintMaxBatchSize");
		require(nextTokenId + numberToMint - 1 <= mintLimit, "Cannot mint numberToMint because mintLimit would be hit");
		for (uint256 index = 0; index < numberToMint; index++) {
			uint256 id = nextTokenId++;
			generator1[id] = uint256(keccak256(abi.encodePacked(blockhash(block.number-1), msg.sender, address(this), id, "1")));
			generator2[id] = uint256(keccak256(abi.encodePacked(blockhash(block.number-1), msg.sender, address(this), id, "2")));
			_safeMint(recipient, id);
		}
    }

	function mintBatch(uint256 batchSize) public payable {
		require(msg.value == batchSize * mintCost, "Failed to send mintCost ETH per NFT");
		_mintTo(msg.sender, batchSize);
	}

	function mintsCompleted() public view returns (uint256) {
		return nextTokenId - 1;
	}

	function mintsRemaining() public view returns (uint256) {
		return mintLimit + 1 - nextTokenId;
	}

	// -------------------
	// Withdrawals section

	function withdraw() external {
		(bool success, ) = payable(beneficiary).call{ value: address(this).balance }("");
		require(success, "Failed to send Ether to Beneficiary");
	}

	// Function to allow ERC20 tokens to be withdrawn from this contract by owner.
	// There shouldn't be any tokens, but this is just in case.
    function withdrawERC20(address _tokenContract, address sendTo, uint256 _amount) external onlyOwner {
        IERC20 tokenContract = IERC20(_tokenContract);
        tokenContract.transfer(sendTo, _amount);
    }

	// ----------------------------------------------------------
	// Ownership section. Allow Owner to update contract settings
	// Revoke ownership after sure the settings work on mainnet

	function updateNetwork(string memory newVal) external onlyOwner {
		// Optimism
		network = newVal;
	}

	function updateMintCost(uint256 newVal) external onlyOwner {
		// 100000 * 10 ** 9
		mintCost = newVal;
	}

	function updateMintLimit(uint256 newVal) external onlyOwner {
		// Between 10k and 1M
		mintLimit = newVal;
	}

	function updateMintMaxBatchSize(uint256 newVal) external onlyOwner {
		// 10 is good value
		mintMaxBatchSize = newVal;
	}

	function updateRoyaltyBasisPoints(uint256 newVal) external onlyOwner {
		require(newVal <= 500, "Max royalty is 5%, or 500 basis points");
		royaltyBasisPoints = newVal;
	}

	function updateExternalUrl(string memory newVal) external onlyOwner {
		// Format is "https://WEB_APP_PENDING/token/"
		externalUrl = newVal;
	}

	function updateBeneficiary(address newBeneficiary) external onlyOwner {
		beneficiary = payable(newBeneficiary);
	}

	// ----------------------------------------------------------

	function getNumericAttribute(string memory attribType, uint256 attribValue, string memory suffix) private pure returns (string memory) {
		return string(abi.encodePacked(
			'{"display_type": "number", "trait_type": "',
			attribType,
			'", "value": ',
			uint2str(attribValue),
			'}',
			suffix
		));
	}

	function getStringAttribute(string memory attribType, string memory attribValue, string memory suffix) private pure returns (string memory) {
		return string(abi.encodePacked(
			'{"trait_type": "',
			attribType,
			'", "value": "',
			attribValue,
			'"}',
			suffix
		));
	}

	function getAllAttributes(uint256 id) private view returns (string memory) {
		return string(abi.encodePacked(
			"[",
			getNumericAttribute("Rarity", getOverallRarityMillibit(id), ","),
			getStringAttribute("Shape", getShapeName(id), ","),
			getStringAttribute("Frame", getFrameName(id), ","),
			getStringAttribute("Lines", getStrokeWidthMultiplierName(id), ","),
			getNumericAttribute("Base Angle", getBaseAngle(id), ","),
			getNumericAttribute("Duration", getDurationMultiplier(id), ","),
			getStringAttribute("Colours", getColourPaletteName(id), ","),
			getStringAttribute("Opacities", getOpacityPaletteName(id), "]")
		));
	}

	// Rarity is measured in millibits, where 1000 millibits = 1 bit which means half as likely. Higher values are more rare. Base values for millibits are the most likely option which is reset to zero millibits (e.g. square frame)
	function getOverallRarityMillibit(uint256 id) private view returns (uint256) {
		return getShapeRarityMillibit(id) + getFrameRarityMillibit(id) + getBaseAngleRarityMillibit(id) + getColourPaletteRarityMillibit(id) + getStrokeWidthMultiplierRarityMillibit(id) + getDurationMultiplierRarityMillibit(id);
	}

	function tokenURI(uint256 id) public view override returns (string memory) {
		require(_exists(id), "Requested id doesn't exist");
		string memory name = string(abi.encodePacked(network, " Moving Mondrian #", id.toString()));
		string memory description = string(abi.encodePacked(
			"This Moving Mondrian NFT has id ",
			id.toString(),
			" and is on ",
			network,
			" network"
		));
		string memory image = Base64.encode(bytes(generateSVGofTokenById(id)));

		// To avoid stack too deep...
		string memory firstPart = string(abi.encodePacked(
				'{"name":"',
				name,
				'", "description":"',
				description,
				'", "external_url":"',
				externalUrl,
				id.toString()
		));

		return string(abi.encodePacked(
			"data:application/json;base64,",
			Base64.encode(bytes(abi.encodePacked(
				// '{"name":"',
				// name,
				// '", "description":"',
				// description,
				// '", "external_url":"',
				// externalUrl,
				// id.toString(),
				firstPart,
				'", "attributes": ',
				getAllAttributes(id),
				', "owner":"',
				toHexString(uint160(ownerOf(id)), 20),
				'", "image": "data:image/svg+xml;base64,',
				image,
				'"}'
			)))
		));
	}

	// Defines an SVG image in viewport [0, 512] x [0, 512]
	function generateSVGofTokenById(uint256 id) public view returns (string memory) {
		return string(abi.encodePacked(
			'<svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" xml:space="preserve" viewBox="0 0 512 512">',
			renderTokenById(id),
			'</svg>'
		));
	}

	function renderTokenById(uint256 id) private view returns (string memory) {
		return string(abi.encodePacked(
			'<defs><mask id="frameOuter"><g fill="white"><g id="frameInner" stroke-linejoin="round">',
			getFrame(id),
			'</g></g></mask><mask id="shapeOuter"><rect x="0" y="0" width="512" height="512" fill="white"/><g fill="black"><g id="shapeInner" stroke-linejoin="round">',
			getShape(id),
			'</g></g></mask><g id="clockCirclesLarge"><circle cx="256" cy="48" r="20"/><circle cx="48" cy="256" r="20"/><circle cx="256" cy="464" r="20"/><circle cx="464" cy="256" r="20"/></g><g id="clockCirclesSmall"><circle cx="256" cy="48" r="12"/><circle cx="48" cy="256" r="12"/><circle cx="256" cy="464" r="12"/><circle cx="464" cy="256" r="12"/></g></defs>',
			getDrawnItems(id)
		));
	}

	function getDrawnItems(uint256 id) private view returns (string memory) {
		return string(abi.encodePacked(
			'<g stroke-width="0" stroke="black" stroke-opacity="1" mask="url(#frameOuter)" ><rect x="0" y="0" width="512" height="512" fill="white"/>',
			getTsfmedRectBlock(id, 0),  // Several rectangles at the back
			'<g mask="url(#shapeOuter)">',
			getTsfmedRectBlock(id, 6),  // Several more rectangles at the front, with shape punched through them
			'</g>',
			getSuperimposedItems(id),
			'</g>'
		));
	}

	function getSuperimposedItems(uint256 id) private view returns (string memory) {
		uint8 strokeWidthMultiplier = strokeWidthMultipliers[getStrokeWidthMultiplierIndex(id)];
		return string(abi.encodePacked(
			'<g stroke-width="',
			uint2str(strokeWidthMultiplier),
			'" fill="transparent"><use href="#shapeInner" stroke="white" transform="scale(1.005)" transform-origin="256 256"/><use href="#shapeInner" stroke="black"/></g><g stroke-width="',
			uint2str(strokeWidthMultiplier * 2),
			'" fill="transparent" stroke-opacity="1"><use href="#frameInner" stroke="white" transform="scale(0.999)" transform-origin="256 256"/><use href="#frameInner" stroke="black"/></g>'
		));
	}

	// ----------------------
	// Frame - choice of 32 frames (with some duplication), determines the outer perimeter of the NFT

	function getFrameIndex(uint256 id) private view returns (uint256) {
		return getLowRand(generator2[id], 5, 196); // getLowRand uses 5 * 2 = 10 bits of randomness, it is min of 2 separate random variables
	}

	function getFrame(uint256 id) private view returns (string memory) {
		return mf.getFrame(getFrameIndex(id));
	}

	function getFrameName(uint256 id) private view returns (string memory) {
		return mf.getFrameName(getFrameIndex(id));
	}

	function getFrameRarityMillibit(uint256 id) private view returns (uint256) {
		return mf.getFrameRarityMillibit(getFrameIndex(id));
	}

	// ----------------------
	// Shape - choice of 32 shapes (with some duplication), determines the inner shape on an NFT

	function getShapeIndex(uint256 id) private view returns (uint256) {
		return getLowRand(generator2[id], 5, 206);
	}

	function getShape(uint256 id) private view returns (string memory) {
		return ms.getShape(getShapeIndex(id));
	}

	function getShapeName(uint256 id) private view returns (string memory) {
		return ms.getShapeName(getShapeIndex(id));
	}

	function getShapeRarityMillibit(uint256 id) private view returns (uint256) {
		return ms.getShapeRarityMillibit(getShapeIndex(id));
	}

	// ----------------------
	// Base Angles - determines the geometry used for the image

	uint16[8] private baseAngles = [
		90,90,60,45,
		72,30,36,180
	];
	uint256[8] private baseAngleRarityMillibit = [
		0, 0, 1348, 1637,
		2000, 2485, 3222, 4807
	];

	function getBaseAngleIndex(uint256 id) private view returns (uint256) {
		return getLowRand(generator2[id], 3, 216);
	}

	function getBaseAngle(uint256 id) private view returns (uint16) {
		return baseAngles[getBaseAngleIndex(id)];
	}

	function getBaseAngleRarityMillibit(uint256 id) private view returns (uint256) {
		return baseAngleRarityMillibit[getBaseAngleIndex(id)];
	}

	// ----------------------
	// Colour Palette selection - earlier palettes are more likely, each colour within palette is equally likely

	string[8] private colourPaletteNames = [
		"RYB", "CYM", "GYB", "ROY",
		"CBM", "Rainbow", "Monochrome", "Monochrome"
	];
	uint256[8] private colourPaletteRarityMillibit = [
		0, 207, 448, 737,
		1100, 1585, 1907, 1907
	];
	string[16][8] private colourPalettes = [
		// RYB
		["red", "red", "red", "red", "red", "yellow", "yellow", "yellow", "yellow", "yellow", "blue", "blue", "blue", "blue", "blue", "white"],

		// CYM
		["yellow", "yellow", "yellow", "yellow", "yellow", "cyan", "cyan", "cyan", "cyan", "cyan", "magenta", "magenta", "magenta", "magenta", "magenta", "white"],

		// GYB
		["green", "green", "green", "green", "green", "yellow", "yellow", "yellow", "yellow", "yellow", "blue", "blue", "blue", "blue", "blue", "white"],

		// ROY
		["red", "red", "red", "red", "red", "orange", "orange", "orange", "orange", "orange", "yellow", "yellow", "yellow", "yellow", "yellow", "white"],


		// CBM
		["cyan", "cyan", "cyan", "cyan", "cyan", "blue", "blue", "blue", "blue", "blue", "magenta", "magenta", "magenta", "magenta", "magenta", "white"],

		// Rainbow
		["red", "red", "orange", "orange", "yellow", "yellow", "green", "green", "cyan", "cyan", "blue", "blue", "magenta", "magenta", "white", "white"],

		// Monochrome
		["rgb(32,32,32)", "rgb(32,32,32)", "rgb(32,32,32)", "rgb(32,32,32)", "rgb(32,32,32)", "grey", "grey", "grey", "grey", "grey", "rgb(224,224,224)", "rgb(224,224,224)", "rgb(224,224,224)", "rgb(224,224,224)", "rgb(224,224,224)", "white"],
		["rgb(32,32,32)", "rgb(32,32,32)", "rgb(32,32,32)", "rgb(32,32,32)", "rgb(32,32,32)", "grey", "grey", "grey", "grey", "grey", "rgb(224,224,224)", "rgb(224,224,224)", "rgb(224,224,224)", "rgb(224,224,224)", "rgb(224,224,224)", "white"]
	];

	function getColourPaletteName(uint256 id) private view returns (string memory) {
		return colourPaletteNames[getColourPaletteIndex(id)];
	}

	function getColourPaletteIndex(uint256 id) private view returns (uint256) {
		return getLowRand(generator2[id], 3, 222);
	}
	function getColourPaletteRarityMillibit(uint256 id) private view returns (uint256) {
		return colourPaletteRarityMillibit[getColourPaletteIndex(id)];
	}

	function getColourIndex(uint256 id, uint256 rectIndex) private view returns (uint256) {
		return getRectIndexRand(generator1[id], rectIndex, 4, 0);
	}

	// ----------------------
	// Opacity Palette selection - all 16 palettes are equally likely, and each opacity within each palette is equally likely

	string[16] private opacityPaletteNames = [
		"Opaque", "All 15/16", "All 7/8", "All 3/4",
		"All 2/3", "All 1/2", "All 1/3", "All 1/4",
		"All 1/5", "All 3/20", "Opaque or 1/2", "Opaque, 2/3, 1/3",
		"Opaque, 3/4, 1/2, 1/4", "2/3 or 1/3", "4/5, 3/5, 2/5, 1/5", "10% or 90%"
	];
	string[4][16] private opacityPalettes = [
		["1","1","1","1"],
		["0.9375","0.9375","0.9375","0.9375"],
		["0.875","0.875","0.875","0.875"],
		["0.75","0.75","0.75","0.75"],

		["0.667","0.667","0.667","0.667"],
		["0.5","0.5","0.5","0.5"],
		["0.333","0.333","0.333","0.333"],
		["0.25","0.25","0.25","0.25"],

		["0.2","0.2","0.2","0.2"],
		["0.15","0.15","0.15","0.15"],
		["1","1","0.5","0.5"],
		["1","1","0.667","0.333"],

		["1","0.75","0.5","0.25"],
		["0.667","0.667","0.333","0.333"],
		["0.8","0.6","0.4","0.2"],
		["0.9","0.9","0.1","0.1"]
	];

	function getOpacityPaletteIndex(uint256 id) private view returns (uint256) {
		return getRand(generator2[id], 4, 192);
	}

	function getOpacityPaletteName(uint256 id) private view returns (string memory) {
		return opacityPaletteNames[getOpacityPaletteIndex(id)];
	}

	function getOpacityIndex(uint256 id, uint256 rectIndex) private view returns (uint256) {
		return getRectIndexRand(generator1[id], rectIndex, 2, 4);
	}

	// ----------------------
	// Stroke Width Multipliers - four width multipliers of different rarities

	string[4] private strokeWidthMultiplierNames = ["Normal", "Thin", "Thick", "Thickest"];
	uint8[4] private strokeWidthMultipliers = [2, 1, 3, 4];
	uint256[4] private strokeWidthMultiplierRarityMillibit = [0, 485, 1222, 2807];

	function getStrokeWidthMultiplierIndex(uint256 id) private view returns (uint256) {
		return getLowRand(generator2[id], 2, 228);
	}

	function getStrokeWidthMultiplierName(uint256 id) private view returns (string memory) {
		return strokeWidthMultiplierNames[getStrokeWidthMultiplierIndex(id)];
	}

	function getStrokeWidthMultiplierRarityMillibit(uint256 id) private view returns (uint256) {
		return strokeWidthMultiplierRarityMillibit[getStrokeWidthMultiplierIndex(id)];
	}

	// ----------------------
	// Rectangle Animation - Duration Multipliers - eight duration multipliers of different rarities

	uint16[8] private durationMultipliers = [
		5, 7, 11, 3,
		23, 2, 37, 1
	];
	uint256[8] private durationMultiplierRarityMillibit = [
		0, 207, 448, 737,
		1100, 1585, 2322, 3907
	];

	function getDurationMultiplierIndex(uint256 id) private view returns (uint256) {
		return getLowRand(generator2[id], 3, 232);
	}

	function getDurationMultiplier(uint256 id) private view returns (uint16) {
		return durationMultipliers[getDurationMultiplierIndex(id)];
	}

	function getDurationMultiplierRarityMillibit(uint256 id) private view returns (uint256) {
		return durationMultiplierRarityMillibit[getDurationMultiplierIndex(id)];
	}

	// ----------------------
	// Rectangle Animation - other control values

	uint8[4] private strokeWidths = [1,2,4,8];  // equally likely
	uint16[4] private rectHeights = [128, 192, 256, 384];  // equally likely

	// For each rectangle, its duration and movement are independently chosen, both equally likely from 8 possibilities
	uint16[8] private durationSecondsList = [
		13, 23, 29, 31,
		41, 47, 59, 71
	];  // monstrous!
	string[8] private yMovementValues = [
		"0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 32;0 256;0 256;0 256;0 256;0 256;0 256;0 256;0 192;0 0",
		"0 0;0 0;0 -128;0 -128;0 -128;0 -128;0 128;0 128;0 128;0 128;0 128;0 128;0 128;0 0;0 0;0 0;0 0",
		"0 128;0 128;0 128;0 128;0 128;0 128;0 96;0 0;0 0;0 0;0 0;0 0;0 0;0 64;0 128;0 128",
		"0 64;0 256;0 192;0 192;0 192;0 192;0 128;0 0;0 0;0 0;0;0 0;0 0;0 64;0 64;0 64;0 64;0 64;0 64;0 64",

		"0 256;0 256;0 192;0 64;0 0;0 0;0 0;0 0;0 0;0 0;0 128;0 128;0 192;0 256;0 256;0 256;0 256;0 256",
		"0 256;0 256;0 128;0 128;0 128;0 128;0 384;0 384;0 384;0 384;0 384;0 0;0 0;0 0;0 0;0 0;0 0;0 192;0 256;0 256;0 256",
		"0 192;0 192;0 192;0 256;0 256;0 256;0 256;0 128;0 128;0 128;0 128;0 192;0 384;0 384;0 256;0 0;0 0;0 0;0 0;0 0;0 192",
		"0 128;0 128;0 128;0 128;0 128;0 32;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 64;0 192;0 384;0 384;0 128"
	];

	// ----------------------
	// Main drawing functions here

	// Single rectangle before animation
	function getRect(uint256 id, uint256 rectIndex) private view returns (string memory) {
		uint256 gen1 = generator1[id];
		uint8 strokeWidthMultiplier = strokeWidthMultipliers[getStrokeWidthMultiplierIndex(id)];
		uint256 opacityPaletteIndex = getOpacityPaletteIndex(id);
		uint256 opacityIndex = getOpacityIndex(id, rectIndex);
		string memory fillOpacity = opacityPalettes[opacityPaletteIndex][opacityIndex];
		string memory rectHeight = uint2str(rectHeights[getRectIndexRand(gen1, rectIndex, 2, 6)]);
		string memory strokeWidth = uint2str(strokeWidthMultiplier * strokeWidths[getRectIndexRand(gen1, rectIndex, 2, 8)]);
		string memory fillColour = colourPalettes[getColourPaletteIndex(id)][getColourIndex(id, rectIndex)];
		return string(abi.encodePacked(
			'<rect x="-128" width="768" y="-64" height="',
			rectHeight,
			'" stroke="black" stroke-width="',
			strokeWidth,
			'" fill="',
			fillColour,
			'" fill-opacity="',
			fillOpacity,
			'"/>'
		));		
	}

	// Animation for single rectangle
	function getRectAnimation(uint256 id, uint256 rectIndex) private view returns (string memory) {
		uint256 gen1 = generator1[id];
		uint16 durationMultiplier = getDurationMultiplier(id);
		uint16 durationSeconds = durationSecondsList[getRectIndexRand(gen1, rectIndex, 3, 10)];
		string memory durationSecondsText = uint2str(durationMultiplier * durationSeconds);
		string memory yMovementValue = yMovementValues[getRectIndexRand(gen1, rectIndex, 3, 13)];
		return string(abi.encodePacked(
			'<animateTransform dur="',
			durationSecondsText,
			's" values="',
			yMovementValue,
			'" type="translate" attributeName="transform" attributeType="XML" repeatCount="indefinite" additive="sum"/>'
		));		
	}

	// Single animated rectangle
	function getTsfmedRect(uint256 id, uint256 rectIndex) private view returns (string memory) {
		uint256 gen2 = generator2[id];
		uint16 baseAngle = getBaseAngle(id);
		uint16 rotationNumber = uint16(getRectIndexRand(gen2, rectIndex, 6, 0));
		string memory finalAngle = uint2str(baseAngle * rotationNumber);
		string memory xReflection = getRectIndexRand(gen2, rectIndex, 1, 6) == 0 ? "1" : "-1";
		return string(abi.encodePacked(
			'<g transform-origin="256 256" transform="scale(',
			xReflection,
			',1) rotate(',
			finalAngle,
			')">',
			getRect(id, rectIndex),
			getRectAnimation(id, rectIndex),
			'</g>'
		));		
	}

	// Block of several animated rectangles
	function getTsfmedRectBlock(uint256 id, uint256 index) private view returns (string memory) {
		return string(abi.encodePacked(
			getTsfmedRect(id, index),
			getTsfmedRect(id, index + 1),
			getTsfmedRect(id, index + 2),
			getTsfmedRect(id, index + 3),
			getTsfmedRect(id, index + 4),
			getTsfmedRect(id, index + 5)
		));		
	}

	// ----------------------
	// Helper functions

	// Get random value between 0 and 2 ** bits - 1, with linear skew to low values
	// Randomness consumed: bits * 2
	function getLowRand(uint256 gen, uint8 bits, uint8 startBit) private pure returns (uint8) {
		return uint8(Math.min(getRand(gen, bits, startBit), getRand(gen, bits, startBit + bits)));
	}

	// Get random value between 0 and 2 ** bits - 1, with uniform distribution
	// Randomness consumed: bits
	function getRand(uint256 gen, uint8 bits, uint8 startBit) private pure returns (uint8) {
		uint8 gen8bits = uint8(gen >> startBit);
		if (bits >= 8) return gen8bits;
		return uint8(gen8bits % 2 ** bits);
	}

	// Get random value between 0 and 2 ** bits - 1, with uniform distribution
	// There are 12 rectangles, so index = 0 ... 11
	// Each rectangle consumes 23 bits of entropy, which is split into
	// 16 bits on generator1, and 7 bits on generator2
	function getRectIndexRand(uint256 gen, uint256 rectIndex, uint8 bits, uint8 startBit) private pure returns (uint8) {
		return getRand(gen, bits, uint8(16 * rectIndex + startBit));
	}

	// Helper to turn numbers into text
	function uint2str(uint _i) private pure returns (string memory _uintAsString) {
		if (_i == 0) {
			return "0";
		}
		uint j = _i;
		uint len;
		while (j != 0) {
			len++;
			j /= 10;
		}
		bytes memory bstr = new bytes(len);
		uint k = len;
		while (_i != 0) {
			k = k-1;
			uint8 temp = (48 + uint8(_i - _i / 10 * 10));
			bytes1 b1 = bytes1(temp);
			bstr[k] = b1;
			_i /= 10;
		}
		return string(bstr);
	}

	// Helper function to turn address (uint256) into string representation
	bytes16 private constant ALPHABET = '0123456789abcdef';
	function toHexString(uint256 value, uint256 length) private pure returns (string memory) {
		bytes memory buffer = new bytes(2 * length + 2);
		buffer[0] = '0';
		buffer[1] = 'x';
		for (uint256 i = 2 * length + 1; i > 1; --i) {
			buffer[i] = ALPHABET[value & 0xf];
			value >>= 4;
		}
		return string(buffer);
	}
}
