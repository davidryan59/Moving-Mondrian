// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MondrianShapes {

	// -------------------------
	// Public Getters for shapes

	function getShape(uint256 index) external view returns (string memory) {
		return shapes[index];
	}

	function getShapeName(uint256 index) external view returns (string memory) {
		return shapeNames[index];
	}

	function getShapeRarityMillibit(uint256 index) external view returns (uint256) {
		return shapeRarityMillibit[index];
	}

	// ----------------------
	// Shape Data - determines the inner shape on an NFT

	string[32] private shapeNames = [
		"None",
		"None",
		"None",
		"None",

		"None",
		"Circle",
		"Four Circles",
		"Small Circle",

		"Large Circle",
		"Ethereum",
		"Heart",
		"Star",

		"Clover",
		"Rose",
		"Cross",
		"Spiral",

		"Star of David",
		"Triangle",
		"Crescent Moon",
		"Daisy",

		"Flower",
		"Resizing Circle",
		"Shifting Square",
		"Watcher",

		"Sun",
		"Shuriken",
		"Cartwheel",
		"Rocket",

		"Clock",
		"AH shape",
		"Cat",
		"Rare Vitalik"
	];

	uint256[32] private shapeRarityMillibit = [
		0, 0, 0, 0,
		0, 2477, 2532, 2590,
		2650, 2713, 2778, 2847,
		2919, 2995, 3075, 3160,
		3250, 3347, 3450, 3561,
		3681, 3812, 3957, 4117,
		4298, 4504, 4745, 5035,
		5397, 5883, 6620, 8205
	];

	string[32] private shapes = [
		// No Shape (None)
		'',
		'',
		'',
		'',

		'',

		// Circle (Still)
		'<circle cx="256" cy="256" r="96"/>',

		// Four Circles (Still)
		'<circle cx="180" cy="180" r="48"/><circle cx="332" cy="180" r="48"/><circle cx="180" cy="332" r="48"/><circle cx="332" cy="332" r="48"/>',

		// Small Circle (Still)
		'<circle cx="256" cy="256" r="64"/>',


		// Large Circle (Still)
		'<circle cx="256" cy="256" r="128"/>',

		// Ethereum (Animated)
		'<g><polygon points="144,240 256,288 368,240 256,64"/><animateTransform type="translate" dur="4.3s" values="0 0;0 0;0 14;0 0" attributeName="transform" attributeType="XML" repeatCount="indefinite" additive="sum"/></g><g><polygon points="144,272 256,448 368,272 256,320"/><animateTransform type="translate" dur="6.7s" values="0 0;0 0;0 -14;0 0" attributeName="transform" attributeType="XML" repeatCount="indefinite" additive="sum"/></g>',

		// Heart (Slow Animation)
		'<g transform="translate(256 256)"><path d="M 256 428 C 0 256 128 0 256 180 C 384 0 512 256 256 428 Z" transform="translate(-256 -256)"/><animateTransform type="scale" dur="1.4s" values="1 1;1 1;1 1;1 1;1 1;1 1;1 1;1 1;1 1;1.01 0.992;1.005 0.99;1.002 0.995;1 1" attributeName="transform" attributeType="XML" repeatCount="indefinite" additive="sum"/><animateTransform type="scale" dur="17s" values="1 1;1 1;1.1 1;1 1" attributeName="transform" attributeType="XML" repeatCount="indefinite" additive="sum"/><animateTransform type="scale" dur="23s" values="1 1;1 1;1 1.1;1 1" attributeName="transform" attributeType="XML" repeatCount="indefinite" additive="sum"/></g>',

		// Star (Animated) 
		'<g transform="translate(256, 256)"><polygon points="0,-166.7 36.7,-50.7 158.5,-51.5 59.5,19.2 98,134.8 0.1,62.5 -98,134.8 -59.4,19.4 -158.5,-51.5 -36.9,-50.5"/><animateTransform type="rotate" dur="71s" values="0;0;1;-1;0;0;0;0;0;0;0;0;0;-2;0;0.5;2;2;10;30;30;35;36;36;36;38;8;0;0;0;0;0;0;0;0;0;0;-31;-36;-36;-45;-45;-60;-60;-66;-66;-70;-72;-72;-72;-70;-71;-71;-72" attributeName="transform" attributeType="XML" repeatCount="indefinite" additive="sum"/></g>',


		// Clover (Slow Animation)
		'<g><path d="M 216 216 C 96 96 416 96 296 216 C 416 96 416 416 296 296 C 416 416 96 416 216 296 C 96 416 96 96 216 216 Z"/><animateTransform type="translate" dur="7s" values="0 0;0 0;0 0;0 2;0 2;2 0;2 0;2 0;2 -2;0 -2;0 -2;0 -2;0 -2;-2 -2;-2 0;-2 0;-2 0;-2 0;0 0" attributeName="transform" attributeType="XML" repeatCount="indefinite" additive="sum"/></g>',

		// Rose (Animated)
		'<g transform="translate(256 256)"><path d="M -21.8 -30 C -170 -150 170 -150 21.8 -30 C 90.1 -208 195.2 115.3 35.3 11.5 C 225.7 21.4 -49.4 221.3 0 37.1 C 49.4 221.3 -225.7 21.4 -35.3 11.5 C -195.2 115.3 -90.1 -208 -21.8 -30 Z"/><circle r="37"/><animateTransform type="scale" dur="9s" values="1 1;0.95 0.95;1.05 1.05;1 1" attributeName="transform" attributeType="XML" repeatCount="indefinite" additive="sum"/><animateTransform type="rotate" dur="13s" values="0;0;0;0;7;14;21;28;35;35;36;36;36;36;30;30;40;50;60;60;60;70;70;72" attributeName="transform" attributeType="XML" repeatCount="indefinite" additive="sum"/></g>',

		// Cross (Animated)
		'<g><polygon points="208,112 304,112 304,208 400,208 400,304 304,304 304,400 208,400 208,304 112,304 112,208 208,208"/><animateTransform type="rotate" dur="47s" values="0 256 256;0 256 256;0 256 256;0 256 256;2 256 256;0 256 256;0 256 256;0 256 256;0 256 256;-2 256 256;0 256 256;0 256 256;0 256 256;0 256 256;0 256 256;0 256 256;0 256 256;0 256 256;0 256 256;0 256 256;0 256 256;-45 256 256;-45 256 256;-45 256 256;-45 256 256;-45 256 256;45 256 256;45 256 256;45 256 256;45 256 256;45 256 256;45 256 256;45 256 256;90 256 256" attributeName="transform" attributeType="XML" repeatCount="indefinite" additive="sum"/></g>',

		// Spiral (Animated)
		'<g transform="translate(256, 256)"><path d="M 0 150 A 142.5 142.5 0 0 0 135 0 A 128.3 128.3 0 0 0 0 -121.5 A 115.4 115.4 0 0 0 -109.4 0 A 103.9 103.9 0 0 0 0 98.4 A 93.5 93.5 0 0 0 88.6 0 A 84.1 84.1 0 0 0 0 -79.7 A 75.7 75.7 0 0 0 -71.7 0 A 68.2 68.2 0 0 0 0 64.6 A 61.3 61.3 0 0 0 58.1 0 A 55.2 55.2 0 0 0 0 -52.3 A 49.7 49.7 0 0 0 -47.1 0 A 44.7 44.7 0 0 0 0 42.4 A 40.2 40.2 0 0 0 38.1 0 A 36.2 36.2 0 0 0 0 -34.3 A 32.6 32.6 0 0 0 -30.9 0 A 29.3 29.3 0 0 0 0 27.8 A 26.4 26.4 0 0 0 25 0 A 23.8 23.8 0 0 0 0 -22.5 A 21.4 21.4 0 0 0 -20.3 0 A 19.2 19.2 0 0 0 0 18.2 A 17.3 17.3 0 0 0 16.4 0 A 15.6 15.6 0 0 0 0 -14.8 A 14 14 0 0 0 -13.3 0 A 12.6 12.6 0 0 0 0 12 A 1.15 1.15 0 0 0 0 9.7 A 10.2 10.2 0 0 1 -10.8 0 A 11.4 11.4 0 0 1 0 -12 A 12.6 12.6 0 0 1 13.3 0 A 14 14 0 0 1 0 14.8 A 15.6 15.6 0 0 1 -16.4 0 A 17.3 17.3 0 0 1 0 -18.2 A 19.2 19.2 0 0 1 20.3 0 A 21.4 21.4 0 0 1 0 22.5 A 23.8 23.8 0 0 1 -25 0 A 26.4 26.4 0 0 1 0 -27.8 A 29.3 29.3 0 0 1 30.9 0 A 32.6 32.6 0 0 1 0 34.3 A 36.2 36.2 0 0 1 -38.1 0 A 40.2 40.2 0 0 1 0 -42.4 A 44.7 44.7 0 0 1 47.1 0 A 49.7 49.7 0 0 1 0 52.3 A 55.2 55.2 0 0 1 -58.1 0 A 61.3 61.3 0 0 1 0 -64.6 A 68.2 68.2 0 0 1 71.7 0 A 75.7 75.7 0 0 1 0 79.7 A 84.1 84.1 0 0 1 -88.6 0 A 93.5 93.5 0 0 1 0 -98.4 A 103.9 103.9 0 0 1 109.4 0 A 115.4 115.4 0 0 1 0 121.5 A 14.25 14.25 0 0 0 0 150 Z"/><animateTransform type="rotate" dur="239s" values="0;0;5;15;30;55;90;90;90;150;270;270;-180;360;-450;-450;540;-630;630;630;720;720;775;360" attributeName="transform" attributeType="XML" repeatCount="indefinite" additive="sum"/></g>',


		// Star of David (Small Animation)
		'<g transform="translate(256, 256)"><polygon points="0,144 -41.6,72 -124.7,72 -83.1,0 -124.7,-72 -41.6,-72 0,-144 41.6,-72 124.7,-72 83.1,0 124.7,72 41.6,72"/><animateTransform type="scale" dur="17s" values="1 1;1 1;1.05 1.05;1.05 1.05;1.01 1.01;1 1;1 1;1 1;0.97 0.97;0.97 0.97;1 1;" attributeName="transform" attributeType="XML" repeatCount="indefinite" additive="sum"/><animateTransform type="rotate" dur="67s" values="0;0;0;0;0;-1;1;1;0;0;0;-2;3;1;0;0;0;-1;-1;1;-1;0.333;0;0;0" attributeName="transform" attributeType="XML" repeatCount="indefinite" additive="sum"/></g>',

		// Triangle (Animated)
		'<g><polygon points="256,128 367,320 145,320"/><animateTransform type="rotate" dur="45s" values="0 256 256;0 256 256;0 256 256;0 256 256;5 256 256;15 256 256;30 256 256;50 256 256;75 256 256;105 256 256;140 256 256;180 256 256;215 256 256;232 256 256;240 256 256;240 256 256;120 256 256" attributeName="transform" attributeType="XML" repeatCount="indefinite" additive="sum"/></g>',

		// Crescent Moon (Small Animation)
		'<g><path d="M 165.5 165.5 A 128 128 0 0 0 346.5 346.5 A 160 160 0 0 1 165.5 165.5 Z"/><animateTransform type="rotate" dur="599s" values="0 256 256;360 256 256" attributeName="transform" attributeType="XML" repeatCount="indefinite" additive="sum"/></g>',

		// Daisy (Slow Animation)
		'<g transform="translate(256,256)"><path d="M -6.9 -50 C -17 -150 17 -150 6.9 -50 C 24.1 -149 56.8 -139.9 20.1 -46.3 C 63.4 -137 92.5 -119.3 31.9 -39.2 C 98 -114.8 121.2 -90 41.2 -29.1 C 125.4 -84.1 141 -53.9 47.6 -16.9 C 143.4 -47.2 150.3 -13.9 50.4 -3.4 C 150.8 -6.7 148.5 27.2 49.4 10.3 C 147 34.2 135.6 66.3 44.8 23.2 C 132.3 72.6 112.7 100.4 36.9 34.4 C 107.9 105.6 81.5 127.1 26.2 43.1 C 75.4 130.8 44.2 144.4 13.6 48.6 C 37.3 146.3 3.6 150.9 0 50.5 C -3.6 150.9 -37.3 146.3 -13.6 48.6 C -44.2 144.4 -75.4 130.8 -26.2 43.1 C -81.5 127.1 -107.9 105.6 -36.9 34.4 C -112.7 100.4 -132.3 72.6 -44.8 23.2 C -135.6 66.3 -147 34.2 -49.4 10.3 C -148.5 27.2 -150.8 -6.7 -50.4 -3.4 C -150.3 -13.9 -143.4 -47.2 -47.6 -16.9 C -141 -53.9 -125.4 -84.1 -41.2 -29.1 C -121.2 -90 -98 -114.8 -31.9 -39.2 C -92.5 -119.3 -63.4 -137 -20.1 -46.3 C -56.8 -139.9 -24.1 -149 -6.9 -50 Z"/><animateTransform type="rotate" dur="37s" values="0;0;0;0;0;1;-1;0;0;0;0;0;0;1;1;2;2;3;4;5;6;8;10;12;15;18;21;24;28;32;36;40;45;50;55;60;66;72;77;81;84;86;88;89;89;90;90;90;90;88;88;88;85;83;83;80;80;80;78.26" attributeName="transform" attributeType="XML" repeatCount="indefinite" additive="sum"/></g>',


		// Flower (Animated)
		'<g transform="translate(256,256)"><rect x="-22" y="-19" rx="15" ry="10" width="44" height="42"/><path d="M -14.5 -20 C -58.1 -150 58.1 -150 14.5 -20 C 124.7 -101.6 160.6 8.9 23.5 7.6 C 135.2 87.2 41.1 155.5 0 24.7 C -41.1 155.5 -135.2 87.2 -23.5 7.6 C -160.6 8.9 -124.7 -101.6 -14.5 -20 Z"/><animateTransform type="rotate" dur="23s" values="0;0;0;0;0;0;0;0;1;-1;0;0;0;0;0;0;0;0;0;0;0;0;0;1;-1;0;0;0;0;0;0;1;-1;1;-1;1;-2;3;-10;-45;-70;-72;-72;-72;-72;-72;-72;-72;-72;-72;-73;-71;-73;-36;-36;-18;-18;-6;-6;0;0;0;0;0;0;-2;0;0;2;0;0;5;5;5;15;15;69;69;72;72;72;72;72;80;100;120;138;144;144;144;144;144" attributeName="transform" attributeType="XML" repeatCount="indefinite" additive="sum"/></g>',

		// Resizing Circle (Highly Animated)
		'<g transform="translate(256 256)"><circle cx="0" cy="0" r="128"/><animateTransform type="scale" dur="30s" values="1 1;1 1;1 1;1 1;1 1;1 1;1 1;1 1;1 1;1.2 1.2;1.2 1.2;1.2 1.2;1.2 1.2;1.2 1.2;1.2 1.2;1.55 1.55;1.55 1.55;1.55 1.55;1.55 1.55;1.55 1.55;1.55 1.55;1.55 1.55;0.4 0.4;0.4 0.4;0.4 0.4;0.4 0.4;0.4 0.4;0.4 0.4;0.4 0.4;0.8 0.8;0.8 0.8;0.85 0.8;0.8 0.85;0.8 0.8;0.8 0.8;1.1 1.1;1 1;1 1;1 1;1 1;1 1;1 1;0.75 1.5;0.75 1.5;0.75 1.5;0.75 1.5;0.75 1.5;1.5 0.75;1.5 0.75;1.5 0.75;1.5 0.75;1.5 0.75;1.7 0.3;0.9 1.2;1 1;" attributeName="transform" attributeType="XML" repeatCount="indefinite" additive="sum"/></g>',

		// Shifting Square (Highly Animated)
		'<g transform="translate(256 256)"><rect x="-90" y="-90" width="180" height="180"/><animateTransform type="scale" dur="23s" values="1 1;1 1;1 1;1.75 1;1.75 1;0.5 1;0.5 1;1 1" attributeName="transform" attributeType="XML" repeatCount="indefinite" additive="sum"/><animateTransform type="scale" dur="37s" values="1 1;1 1;1 1;1 1.75;1 1.75;1 0.5;1 0.5;1 1" attributeName="transform" attributeType="XML" repeatCount="indefinite" additive="sum"/><animateTransform type="rotate" dur="97s" values="0;0;45;45;60;60;30;30;90;90;135;135;180;180;135;150;90" attributeName="transform" attributeType="XML" repeatCount="indefinite" additive="sum"/></g>',

		// Watcher (Animated)
		'<g transform="translate(256 256)"><path d="M 256 128 A 128 128 1 1 0 346.5 165.5 A 96 96 0 0 1 256 128" transform="translate(-256 -256)"/><animateTransform type="rotate" dur="53s" values="0;0;0;0;0;0;0;0;0;0;0;90;90;90;90;90;180;180;180;180;180;180;360" attributeName="transform" attributeType="XML" repeatCount="indefinite" additive="sum"/><animateTransform type="rotate" dur="41s" values="0;0;60;60;60;60;60;120;120;120;120;240;240;240;240;240;180;180;180;180;300;300;300;360" attributeName="transform" attributeType="XML" repeatCount="indefinite" additive="sum"/><animateTransform type="rotate" dur="31s" values="0;0;0;0;0;0;0;0;-72;-72;-72;-72;-144;-144;-144;-144;-216;-216;-216;-288;-288;-360" attributeName="transform" attributeType="XML" repeatCount="indefinite" additive="sum"/></g>',


		// Sun (Slow Animation)
		'<g transform="translate(256 256)"><circle cx="0" cy="0" r="64"/><animateTransform type="scale" dur="11s" values="1 1;1 1;1.05 1.05;1.05 1.05;1 1" attributeName="transform" attributeType="XML" repeatCount="indefinite" additive="sum"/><g><path id="sunbeams" d="  M -5 140 L 5 140 L 5 80 L -5 80 Z M -134.7 38.5 L -131.6 48 L -74.5 29.5 L -77.6 20 Z M -78.2 -116.2 L -86.3 -110.3 L -51.1 -61.8 L -43 -67.7 Z M 86.3 -110.3 L 78.2 -116.2 L 43 -67.7 L 51.1 -61.8 Z M 131.6 48 L 134.7 38.5 L 77.6 20 L 74.5 29.5 Z"/><animateTransform type="rotate" dur="3.7s" values="0;1;0" attributeName="transform" attributeType="XML" repeatCount="indefinite" additive="sum"/></g><g><use href="#sunbeams" transform="rotate(36)"/><animateTransform type="rotate" dur="3.1s" values="0;-1;0" attributeName="transform" attributeType="XML" repeatCount="indefinite" additive="sum"/></g></g>',

		// Shuriken (Highly Animated)
		'<g transform="translate(256, 256)"><path d="M 0 -50 C -5 -100 40 -110 75 -90 C 60 -90 30 -80 23 -45 C 0 -35 30 -8 39.1 -31.2 C 75.1 -66.3 110.9 -37.3 117.1 2.5 C 107.8 -9.2 81.3 -26.4 49.5 -10.1 C 27.4 -21.8 25 18.5 48.7 11.1 C 98.6 17.4 98.3 63.5 71.1 93.1 C 74.4 78.5 71.3 47 38.8 32.4 C 34.1 7.8 1.1 31 21.7 45 C 47.9 87.9 11.7 116.5 -28.5 113.6 C -15 107.1 7.7 85.1 -1.2 50.5 C 15.2 31.5 -23.6 20.2 -21.7 45 C -38.9 92.3 -83.8 81.8 -106.6 48.5 C -93.1 55.1 -61.7 59.1 -40.2 30.6 C -15.2 31.5 -30.5 -5.8 -48.7 11.1 C -96.4 27.1 -116.1 -14.5 -104.4 -53.1 C -101.1 -38.5 -84.7 -11.4 -49 -12.4 C -34.1 7.8 -14.5 -27.5 -39.1 -31.2 C -81.3 -58.4 -61.1 -99.9 -23.6 -114.8 C -33 -103 -43.8 -73.3 -20.8 -46 C -27.4 -21.8 12.5 -28.4 0 -50 Z"/><animateTransform type="rotate" dur="29s" values="0;0;5;15;30;45;65;90;90;89;94;180;178;90;360;360;1080;1080;900;890;900;900;180;200;540;480;475;360;367;364;360;360" attributeName="transform" attributeType="XML" repeatCount="indefinite" additive="sum"/></g>',

		// Cartwheel (Highly Animated)
		'<g><polygon points="248,210 249,80 254,80 254,83 258,83 258,80 263,80 264,210 274.1,213 345.3,104.2 357,111.7 287.6,221.6 294.5,229.6 413.2,176.5 419,189.3 301.2,244.2 302.7,254.6 431.2,274.1 429.2,288 300.4,270.5 296,280.1 393.6,366 384.4,376.5 285.5,292.2 276.6,297.9 312.3,422.9 298.9,426.8 261.3,302.4 250.7,302.4 213.1,426.8 199.7,422.9 235.4,297.9 226.5,292.2 127.6,376.5 118.4,366 216,280.1 211.6,270.5 82.8,288 80.8,274.1 209.3,254.6 210.8,244.2 93,189.3 98.8,176.5 217.5,229.6 224.4,221.6 155,111.7 166.7,104.2 237.9,213"/><animateTransform type="rotate" dur="34s" values="0 256 256;0 256 256;589.09 256 256;589.09 256 256;589.09 256 256;589.09 256 256;589.09 256 256;589.09 256 256;" attributeName="transform" attributeType="XML" repeatCount="indefinite" additive="sum"/><animateTransform type="rotate" dur="38s" values="0 256 256;0 256 256;0 256 256;0 256 256;687.27 256 256;687.27 256 256;687.27 256 256;687.27 256 256;" attributeName="transform" attributeType="XML" repeatCount="indefinite" additive="sum"/><animateTransform type="rotate" dur="46s" values="0 256 256;0 256 256;0 256 256;0 256 256;0 256 256;0 256 256;0 256 256;-981 256 256;" attributeName="transform" attributeType="XML" repeatCount="indefinite" additive="sum"/></g>',

		// Rocket (Highly Animated)
		'<g transform="translate(256, 256)"><path d="M 0 -150 C 10 -140 60 -100 48 50 C 56 45 88 82 92 178 C 84 162 60 146 40 146 C 40.3 158 -40.3 158 -40 146 C -60 146 -84 162 -92 178 C -88 82 -56 45 -48 50 C -60 -100 -10 -140 0 -150 Z"/><animateTransform type="translate" dur="13s" values="0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 2;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 3;0 0;0 1;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 1;0 0;0 1;0 0;0 1;0 0;0 1;0 0;0 2;0 0;0 2;0 0;0 2;0 0;0 2;0 0;0 3;0 0;0 3;0 0;0 0;0 3;0 0;0 4;0 0;0 4;0 0;0 5;0 0;0 6;0 0;0 0;0 7;0 0;0 8;0 0;0 9;0 0;0 10;0 0;0 0;0 11;0 0;0 12;0 0;0 0;0 13;0 0;0 14;0 0;0 15;0 0;0 16;0 0;0 0;0 17;0 0;0 18;0 0;0 19;0 0;0 0;0 20;0 0;0 21;0 0;0 0;0 0;0 22;0 18;0 8;0 -10;0 -60;0 -180;0 -400;500 -500;500 0;480 0;460 0;440 0;420 0;400 0;380 0;360 0;340 0;320 0;300 0;280 0;260 0;240 0;220 0;200 0;180 0;160 0;145 0;130 0;115 0;100 0;85 0;70 0;60 0;50 0;40 0;30 0;20 0;12 0;6 0;0 0" attributeName="transform" attributeType="XML" repeatCount="indefinite" additive="sum"/></g>',


		// Clock (Animated)
		'<use href="#clockCirclesLarge"/><use href="#clockCirclesSmall" transform="rotate(30, 256, 256)"/><use href="#clockCirclesSmall" transform="rotate(60, 256, 256)"/><g><path d="M 256 100 A 1000 1000 0 0 1 262 180 A 16 16 0 0 1 261 210 A 109 109 0 0 0 270 256 A 14 14 0 0 1 242 256 A 109 109 0 0 0 251 210 A 16 16 0 0 1 250 180 A 1000 1000 0 0 1 256 100 Z"/><animateTransform type="rotate" dur="43200s" values="0 256 256; 360 256 256" attributeName="transform" attributeType="XML" repeatCount="indefinite" additive="sum"/></g><g><path d="M 256 68 A 800 800 0 0 1 262 150 A 12 12 0 0 1 261 170 A 315 315 0 0 0 266 256 A 10 10 0 0 1 246 256 A 315 315 0 0 0 251 170 A 12 12 0 0 1 250 150 A 800 800 0 0 1 256 68 Z"/><animateTransform type="rotate" dur="3600s" values="0 256 256; 360 256 256" attributeName="transform" attributeType="XML" repeatCount="indefinite" additive="sum"/></g><g><path d="M 256 48 A 2400 2400 0 0 0 262 256 A 6 6 0 0 1 250 256 A 2400 2400 0 0 0 256 48 Z"/><animateTransform type="rotate" dur="60s" values="0 256 256; 360 256 256" attributeName="transform" attributeType="XML" repeatCount="indefinite" additive="sum"/></g>',

		// AH shape (Slow Animation - my daughter just designed and gave me this shape one day, so I thought I'd put it in!)
		'<g transform="translate(256, 256)"><polygon points="32,-96 96,-96 160,-32 96,32 96,96 32,160 -32,96 -96,96 -160,32 -96,-32 -96,-96 -32,-160 32,-96"/><animateTransform type="rotate" dur="167s" values="0;0;90;-90;180;-180" attributeName="transform" attributeType="XML" repeatCount="indefinite" additive="sum"/></g>',

		// Cat (Slight animation)
		'<g><path transform="translate(1205 -795)" d="M-827.3,979.5c0,0-2.2-13.1-5.2-17.1c-3.8-5.1-16.4-12.1-16.4-12.1c-2.6,3.7,3.6-9.8,7.3-22.7c0,0-24.2,3.2-46.8,27.6 c-6.4,7-17.8,38.6-17.8,38.6l-44.7,20.5c-31.1,12.9-82.7,26.2-82.7,97.7v30.5c-2.5-1.7-15.7-12.7-15.5-29.9 c0.1-13.6,1.9-27.5,3.6-39.9c3.1-22.7,5.5-47.1-3.7-57.6c-4.2-4.8-10.2-7.3-17.7-7.3c-4.9,0-8.9,4-8.9,8.9c0,4.9,4,8.9,8.9,8.9 c2.2,0,3.6,0.4,4.3,1.2c3.8,4.4,1.5,28.1-0.6,43.4c-1.7,12.9-3.7,27.5-3.7,42.2c0,16.2,5.6,31.4,15.7,42.8 c11.5,12.9,27.7,19.7,46.8,19.7c0,0,0,0,0,0h62.5h8.9h17.9c4.9,0,8.9-4,8.9-8.9s-4-8.9-8.9-8.9l-19.6,0l9.5-31.3 c0-4.5-1-8.8-2.7-12.6c-7.1-12.1-19.9-19.6-34-19.6c-6.2,0-12,1.4-17.5,4.1l-2.9-5.8c6.4-3.2,13.2-4.8,20.4-4.8 c16.8,0,32.3,9.2,40.3,24l0,0l0,0c0,0,33.1,50.7,36.4,57.9c0,0.1,0.1,0.1,0.1,0.2c0.9,2.7,3.1,4.7,5.9,5.3c0.1,0,0.2,0,0.3,0.1 c0.5,0.1,0.9,0.3,1.4,0.3h9.8c4.4,0,8.1-3.6,8.1-8.1c0-4.4-3.6-8.1-8.1-8.1h0.2c0,0-26.6-47.4-21.4-64.2 c23.7-37.2,36.5-72.5,36.5-72.5c5.1-11.6,18.2-20.5,20-21.7c4-2.7,9.5-6.1,10-11.3C-822.2,986.7-826,981.7-827.3,979.5z"/><animateTransform type="translate" dur="12s" values="0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;-1 0;-2 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;-1 0;0 0;0 0;-1 0;4 -3;5 0;2 0;0 0;0 0;0 0;-2 0;0 0;0 0;-1 0;-3 0;30 -30;40 0;30 0;21 0;13 0;7 0;4 0;2 0;1 0;0 0;" attributeName="transform" attributeType="XML" repeatCount="indefinite" additive="sum"/></g>',  // Attribution: Vectors and icons by <a href="https://www.svgrepo.com" target="_blank">SVG Repo</a>

		// Rare Vitalik with Eyebrow (animated eyebrow, shape has no interior)
		'<g transform="translate(256 256)"><g><g transform="translate(-150,177.5) scale(0.100000,-0.100000)" fill="#000000" stroke="none"> <path d="M1335 3365 c-33 -7 -85 -23 -115 -35 -61 -24 -180 -108 -203 -143 -8 -13 -37 -32 -64 -42 -112 -42 -251 -157 -372 -309 -76 -96 -126 -186 -159 -284 -24 -71 -26 -91 -26 -252 0 -147 3 -189 22 -263 12 -48 29 -101 37 -117 20 -40 20 -40 -24 -40 -77 0 -138 -67 -148 -164 -20 -193 156 -573 299 -647 45 -23 111 -25 128 -4 21 25 30 17 30 -29 0 -65 36 -230 61 -284 12 -26 57 -81 98 -122 66 -66 94 -85 210 -143 73 -37 140 -67 147 -67 7 0 28 -13 46 -28 113 -98 333 -167 533 -167 105 0 125 3 161 22 85 45 153 138 170 233 4 19 22 53 40 75 82 101 151 266 174 415 l13 85 67 67 c116 116 176 276 168 451 -5 119 -24 158 -86 171 -41 10 -42 11 -42 49 0 22 11 64 25 93 69 146 100 353 91 614 -8 262 -38 349 -168 485 -152 161 -317 245 -628 318 -169 40 -377 46 -468 12 -35 -13 -29 -14 83 -12 202 3 394 -28 595 -98 173 -61 265 -118 380 -236 86 -88 134 -172 154 -272 20 -94 21 -384 2 -518 -15 -109 -52 -239 -67 -239 -12 0 -11 18 1 60 22 72 12 296 -18 413 -10 39 -40 92 -48 84 -2 -2 5 -48 16 -103 27 -127 29 -327 5 -410 -10 -33 -13 -68 -9 -87 5 -27 4 -29 -12 -22 -92 38 -227 60 -310 49 -60 -7 -70 -17 -76 -74 -2 -26 1 -34 11 -32 68 15 121 22 163 22 54 0 197 -27 213 -40 15 -13 -1 -398 -21 -500 -9 -47 -29 -112 -45 -145 -15 -34 -35 -104 -45 -160 -29 -170 -84 -306 -168 -415 -26 -34 -45 -71 -49 -95 -9 -53 -54 -123 -104 -161 -63 -48 -143 -60 -263 -39 -178 30 -331 86 -395 144 -16 16 -46 34 -65 41 -56 22 -190 90 -250 127 -182 115 -244 260 -266 623 -6 88 -9 108 -16 85 -6 -23 -15 -104 -18 -175 0 -11 -59 -40 -82 -40 -150 0 -385 504 -314 674 20 48 61 76 110 76 46 0 71 -14 133 -73 48 -46 67 -45 28 1 -29 34 -31 42 -11 42 47 0 125 -121 147 -228 7 -34 18 -61 24 -59 15 5 44 212 54 399 9 153 8 173 -10 235 -22 79 -26 232 -6 304 7 29 28 65 56 95 24 27 62 76 84 108 47 70 137 257 137 286 0 11 6 20 13 20 16 -1 82 -149 97 -221 12 -55 9 -191 -6 -251 -9 -39 9 -35 29 7 49 104 81 338 57 425 -11 38 -14 42 -21 25 -4 -11 -8 -53 -8 -92 -1 -40 -4 -73 -9 -73 -4 0 -18 28 -32 61 -33 85 -74 139 -104 139 -29 0 -41 -17 -94 -137 -22 -51 -52 -107 -65 -125 -13 -18 -27 -40 -30 -48 -3 -8 -32 -47 -64 -85 -33 -39 -66 -88 -74 -110 -21 -59 -18 -251 5 -351 16 -73 17 -97 7 -235 -11 -158 -17 -199 -31 -199 -5 0 -11 8 -15 18 -3 11 -25 41 -49 67 -39 42 -50 48 -93 52 -78 8 -90 22 -123 155 -99 401 -35 649 240 930 95 96 175 156 247 183 29 11 74 42 113 79 57 54 119 93 185 117 11 4 40 16 65 28 25 11 80 23 123 27 42 4 77 11 77 15 0 13 -116 9 -185 -6z m1205 -1675 c12 -6 23 -30 30 -64 21 -102 -18 -281 -86 -391 -16 -26 -35 -59 -43 -74 -24 -44 -25 -4 0 47 28 60 48 165 48 264 1 59 5 81 19 94 16 17 17 16 22 -12 5 -24 7 -26 13 -11 9 25 9 49 -2 66 -8 12 -12 12 -24 2 -20 -16 -25 -5 -19 47 4 44 11 49 42 32z"/> <path d="M1279 2976 c6 -7 25 -40 41 -73 52 -105 196 -259 332 -355 57 -41 235 -138 253 -138 15 0 -2 20 -52 58 -30 25 -74 75 -107 126 -31 47 -59 86 -61 86 -2 0 3 -21 11 -47 29 -90 28 -87 13 -78 -97 58 -239 194 -313 300 -54 78 -105 135 -119 135 -5 0 -4 -6 2 -14z"/> <path d="M1720 2692 c0 -16 68 -102 114 -145 93 -85 227 -157 361 -193 78 -21 78 -21 70 39 -10 80 -32 150 -56 175 -11 13 -23 22 -25 20 -2 -3 5 -36 16 -74 22 -75 25 -110 11 -118 -12 -8 -117 28 -171 58 -25 14 -54 30 -65 35 -32 15 -85 57 -150 119 -83 79 -105 97 -105 84z"/> <path d="M2273 2543 c84 -85 94 -99 107 -145 16 -57 30 -46 30 22 0 49 -3 62 -17 67 -10 3 -31 21 -48 38 -43 46 -99 85 -121 85 -13 0 0 -18 49 -67z"/> <g><path d="M1314 1970 c-66 -14 -135 -51 -186 -100 -66 -64 -65 -90 2 -45 68 46 147 67 264 73 103 5 241 -16 298 -44 37 -19 38 -18 38 16 0 41 -24 76 -63 90 -40 15 -298 22 -353 10z"/><animateTransform type="translate" dur="13s" values="0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 22.5;0 50;0 30;0 15;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 60;0 0;0 60;0 0" attributeName="transform" attributeType="XML" repeatCount="indefinite" additive="sum"/></g> <path d="M1372 1849 c-56 -9 -136 -46 -189 -86 -37 -27 -46 -53 -10 -31 29 19 70 16 93 -7 32 -31 86 -47 194 -56 58 -5 120 -11 138 -15 27 -5 32 -3 32 12 -1 39 -65 128 -105 149 -52 25 -23 33 42 11 58 -20 87 -21 53 -1 -14 8 -50 17 -80 20 -30 3 -68 7 -85 9 -16 2 -54 0 -83 -5z m26 -60 l-23 -30 23 -39 22 -39 -47 16 c-54 19 -113 51 -113 63 0 6 89 49 130 63 27 8 30 -4 8 -34z m42 -34 c10 -27 29 -32 47 -14 13 13 33 4 33 -16 0 -18 -41 -29 -73 -21 -26 6 -53 48 -43 65 12 18 26 13 36 -14z m120 -10 c0 -14 8 -29 20 -35 25 -14 28 -45 3 -35 -10 4 -28 10 -41 13 -17 3 -21 9 -16 21 3 9 9 26 11 39 7 30 23 28 23 -3z"/> <path d="M384 1775 c-38 -58 -13 -250 49 -370 22 -43 77 -110 77 -93 0 3 -18 44 -40 90 -69 146 -92 343 -43 362 21 8 110 -86 157 -167 38 -66 63 -88 51 -44 -24 88 -84 179 -143 220 -49 35 -86 35 -108 2z"/> <path d="M2095 1778 c-41 -11 -89 -38 -68 -38 7 0 27 6 45 14 18 8 49 19 68 24 47 13 6 13 -45 0z"/> <path d="M2238 1771 c29 -10 64 -29 78 -42 24 -22 26 -23 23 -4 -5 25 -82 65 -124 65 -26 -1 -22 -3 23 -19z"/> <path d="M2109 1747 c-52 -24 -117 -96 -105 -115 5 -9 226 -15 226 -6 0 3 -11 15 -24 27 -28 25 -37 58 -19 64 7 3 17 -7 23 -22 7 -18 15 -25 25 -21 8 3 22 9 30 12 20 8 19 -15 -2 -38 -9 -10 -12 -18 -6 -18 16 0 41 32 48 62 6 21 2 30 -19 43 -15 10 -46 20 -70 22 l-45 5 -7 -37 c-4 -21 -2 -47 5 -61 l11 -24 -75 0 c-41 0 -75 4 -75 9 0 13 92 91 108 91 6 0 12 5 12 10 0 12 -8 12 -41 -3z"/> <path d="M1730 1744 c0 -3 7 -19 17 -34 16 -28 16 -29 -21 -80 -58 -80 -32 -76 29 4 24 32 34 76 16 76 -5 0 -11 9 -14 20 -5 18 -27 29 -27 14z"/> <path d="M1954 1694 c-26 -33 -27 -38 -15 -72 23 -64 62 -142 72 -142 14 0 11 13 -21 83 -37 81 -37 97 -4 136 19 23 22 31 10 31 -8 0 -27 -16 -42 -36z"/> <path d="M538 1483 c-42 -69 -18 -181 44 -202 39 -14 135 -14 143 -1 4 6 -8 35 -25 64 -18 33 -33 77 -38 113 -8 56 -8 57 -22 33 -7 -14 -14 -46 -14 -72 0 -38 6 -54 27 -76 15 -15 27 -32 27 -36 0 -18 -85 3 -102 24 -22 27 -24 114 -3 150 18 32 18 40 1 40 -8 0 -25 -17 -38 -37z"/> <path d="M2080 1264 c0 -3 10 -22 22 -43 14 -25 19 -45 15 -63 -6 -22 -12 -26 -42 -25 -24 1 -49 -9 -80 -31 -25 -18 -58 -32 -72 -32 -26 0 -26 -1 -10 -17 17 -17 19 -17 45 -1 53 34 110 58 125 52 22 -8 57 35 57 69 0 32 -27 84 -47 91 -7 3 -13 3 -13 0z"/> <path d="M1617 1253 c-4 -3 -7 -30 -7 -59 0 -46 4 -57 34 -88 18 -20 41 -36 50 -36 25 0 19 18 -12 34 -40 21 -56 56 -49 111 6 41 0 55 -16 38z"/> <path d="M1710 1150 c-26 -16 -1 -25 88 -31 48 -3 95 -9 105 -13 34 -16 18 21 -17 38 -37 18 -151 22 -176 6z"/> <path d="M1675 910 c-46 -13 -178 -34 -195 -31 -34 8 -45 5 -45 -9 0 -9 15 -17 44 -22 33 -6 56 -19 95 -56 88 -84 143 -102 306 -102 127 0 162 12 196 67 10 15 29 40 42 55 l25 28 -27 25 c-50 46 -84 58 -145 50 -75 -9 -113 -9 -196 -2 -38 3 -83 2 -100 -3z m210 -21 c17 -1 49 2 72 6 47 8 93 -5 130 -38 30 -27 19 -40 -26 -32 -20 3 -140 10 -268 14 -127 5 -240 14 -250 20 -15 8 -10 11 27 12 25 1 74 7 110 14 36 7 90 11 120 9 30 -3 69 -5 85 -5z m-41 -79 c120 -5 223 -13 228 -16 17 -11 -33 -53 -82 -69 -39 -13 -65 -14 -166 -5 -125 11 -162 24 -230 78 -43 34 -43 43 -1 32 17 -5 130 -14 251 -20z"/></g><animateTransform type="scale" dur="11s" values="1 1;1 1;1 1;1 1;1 1;1.06 1.06;1.03 1.03;1.01 1.01;1 1;1 1;1 1;1 1;1 1;1 1;1 1;1 1" attributeName="transform" attributeType="XML" repeatCount="indefinite" additive="sum"/><animateTransform type="rotate" dur="23s" values="0;0;0;0;0;0;5;-5;-1.5;0;0;0;0;0;0;-360" attributeName="transform" attributeType="XML" repeatCount="indefinite" additive="sum"/></g></g>'
	];
}
