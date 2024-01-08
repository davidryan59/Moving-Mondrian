import { useRef, useState } from "react";
import Image from "next/image";
import type { NextPage } from "next";
import { MetaHeader } from "~~/components/MetaHeader";
import { useScaffoldContractRead, useScaffoldContractWrite } from "~~/hooks/scaffold-eth";
import { useGlobalState } from "~~/services/store/store";

const BUILD_NUMBER = "1.0.0"; // Increment this for each new build and public release

const Home: NextPage = () => {
  const nativeCurrencyPrice = useGlobalState(state => state.nativeCurrencyPrice);

  const { data: mintsCompletedRaw } = useScaffoldContractRead({
    contractName: "MovingMondrian",
    functionName: "mintsCompleted",
  });
  const { data: mintsRemainingRaw } = useScaffoldContractRead({
    contractName: "MovingMondrian",
    functionName: "mintsRemaining",
  });
  const { data: mintMaxBatchSizeRaw } = useScaffoldContractRead({
    contractName: "MovingMondrian",
    functionName: "mintMaxBatchSize",
  });
  const { data: mintLimitRaw } = useScaffoldContractRead({
    contractName: "MovingMondrian",
    functionName: "mintLimit",
  });
  const { data: mintCostWeiRaw } = useScaffoldContractRead({
    contractName: "MovingMondrian",
    functionName: "mintCost",
  });

  // Function to handle missing data, and convert from BigInt to number
  const handleOnchainNumber = (num: any) => Number(num || BigInt(0));

  const mintsCompleted = handleOnchainNumber(mintsCompletedRaw);
  const mintsRemaining = handleOnchainNumber(mintsRemainingRaw);
  const mintMaxBatchSize = handleOnchainNumber(mintMaxBatchSizeRaw);
  const mintLimit = handleOnchainNumber(mintLimitRaw);
  const mintCostWei = handleOnchainNumber(mintCostWeiRaw);
  const mintCostETH = mintCostWei * 10 ** -18;
  const mintCostUSD = `${0.0001 * Math.round(10000 * nativeCurrencyPrice * mintCostETH)}`.slice(0, 6); // Make price have exactly 4 decimal places
  const loadedStats = mintCostWeiRaw && mintMaxBatchSizeRaw && mintLimitRaw;
  const mintedOut = mintLimit > 0 && mintsCompleted >= mintLimit;

  console.log(mintsCompleted, mintsRemaining, mintMaxBatchSize, mintLimit, mintCostUSD);

  // Display the last token minted, and perhaps a few before that
  const idToRead = Number(mintsCompleted);

  let actualId, tokenURI;
  const tokenURIs = [];
  const tokenIds = [];
  let offset: number;

  // // Sadly this nice code doesn't work, because hook can't be in a loop, so need to do the horrible hack below
  // for (let index = 0; index < numberOfImages; index++) {
  //   // This is kind of OK because loop size is fixed...
  //   const { data: tokenURI2 } = useScaffoldContractRead({
  //     contractName: "MovingMondrian",
  //     functionName: "tokenURI",
  //     args: [BigInt(idToRead - index)],
  //   });
  //   tokenURI = tokenURI2;
  //   tokenURIs.push(tokenURI);
  //   console.log(`Token URI is ${typeof tokenURI === "string" ? tokenURI.slice(0, 100) + "..." : "not found yet"}`);
  // }

  // -------------------
  // Horrible Hack start

  // Just to make sure they get reassigned at least once! This is for linting... LOL
  offset = 0;
  actualId = "";
  tokenURI = "";

  offset = 0;
  actualId = Math.max(1, idToRead - offset);
  const { data: tokenURI0 } = useScaffoldContractRead({
    contractName: "MovingMondrian",
    functionName: "tokenURI",
    args: [BigInt(actualId)],
  });
  tokenURI = tokenURI0;
  tokenURIs.push(tokenURI);
  tokenIds.push(actualId);
  // console.log(`Token id ${actualId}, getting token_uri: ${typeof tokenURI === "string" ? tokenURI.slice(0, 100) + "..." : "not found yet"}`);

  // offset = 1;
  // actualId = Math.max(1, idToRead - offset);
  // const { data: tokenURI1 } = useScaffoldContractRead({
  //   contractName: "MovingMondrian",
  //   functionName: "tokenURI",
  //   args: [BigInt(actualId)],
  // });
  // tokenURI = tokenURI1;
  // tokenURIs.push(tokenURI);
  // tokenIds.push(actualId);
  // // console.log(`Token id ${actualId}, getting token_uri: ${typeof tokenURI === "string" ? tokenURI.slice(0, 100) + "..." : "not found yet"}`);

  // offset = 2;
  // actualId = Math.max(1, idToRead - offset);
  // const { data: tokenURI2 } = useScaffoldContractRead({
  //   contractName: "MovingMondrian",
  //   functionName: "tokenURI",
  //   args: [BigInt(actualId)],
  // });
  // tokenURI = tokenURI2;
  // tokenURIs.push(tokenURI);
  // tokenIds.push(actualId);
  // // console.log(`Token id ${actualId}, getting token_uri: ${typeof tokenURI === "string" ? tokenURI.slice(0, 100) + "..." : "not found yet"}`);

  // offset = 3;
  // actualId = Math.max(1, idToRead - offset);
  // const { data: tokenURI3 } = useScaffoldContractRead({
  //   contractName: "MovingMondrian",
  //   functionName: "tokenURI",
  //   args: [BigInt(actualId)],
  // });
  // tokenURI = tokenURI3;
  // tokenURIs.push(tokenURI);
  // tokenIds.push(actualId);
  // // console.log(`Token id ${actualId}, getting token_uri: ${typeof tokenURI === "string" ? tokenURI.slice(0, 100) + "..." : "not found yet"}`);

  // Horrible Hack end:)
  // -------------------

  const imageData = [];
  if (tokenURI !== undefined) {
    for (let index = 0; index < tokenURIs.length; index++) {
      const innerTokenURI = tokenURIs[index];
      const innerTokenId = tokenIds[index];
      if (innerTokenURI !== undefined) {
        const jsonManifestString = atob(innerTokenURI.substring(29));
        const tokenManifest = JSON.parse(jsonManifestString);
        const latestAttributes = JSON.stringify(tokenManifest.attributes);
        const latestImage = tokenManifest.image;
        const latestAltText = tokenManifest.description;
        let owner = tokenManifest.owner || "0x0000";
        owner = `${owner.slice(0, 6)}...${owner.slice(owner.length - 4)}`;
        imageData.push([latestImage, latestAltText, index + 1, latestAttributes, innerTokenId, owner]);
      }
    }
  }

  const processAttributes = (attribJson: string) => {
    const attribs = JSON.parse(attribJson);
    const attribs2: any = [];
    attribs.map((item: any) => {
      attribs2.push(`${item.trait_type}: ${item.value}`);
    });
    return attribs2;
  };

  type MintButtonProps = {
    mintBatchSize: number;
  };

  // this didn't work, and isn't in use
  const [numToMint, setNumToMint] = useState(1);
  const numToMintRef = useRef<number>();
  numToMintRef.current = numToMint;

  // // This didn't work - numToMintRef.current was not always updating... another hideous hack below
  // const { writeAsync: mintBatchAsync } = useScaffoldContractWrite({
  //   contractName: "MovingMondrian",
  //   functionName: "mintBatch",
  //   args: [BigInt(numToMintRef.current)],
  //   value: BigInt(numToMintRef.current * mintCostWei),
  //   onBlockConfirmation: txnReceipt => {
  //     console.log("📦 Transaction blockHash", txnReceipt.blockHash);
  //   },
  // });

  // -----------------------
  // Commence hideous hack 2

  const onBlockConfirm = (txnReceipt: any) => {
    console.log("📦 Transaction blockHash", txnReceipt.blockHash);
  };

  const { writeAsync: mintBatchAsync1 } = useScaffoldContractWrite({
    contractName: "MovingMondrian",
    functionName: "mintBatch",
    args: [BigInt(1)],
    value: BigInt(1 * mintCostWei),
    onBlockConfirmation: onBlockConfirm,
  });

  const { writeAsync: mintBatchAsync2 } = useScaffoldContractWrite({
    contractName: "MovingMondrian",
    functionName: "mintBatch",
    args: [BigInt(2)],
    value: BigInt(2 * mintCostWei),
    onBlockConfirmation: onBlockConfirm,
  });

  const { writeAsync: mintBatchAsync5 } = useScaffoldContractWrite({
    contractName: "MovingMondrian",
    functionName: "mintBatch",
    args: [BigInt(5)],
    value: BigInt(5 * mintCostWei),
    onBlockConfirmation: onBlockConfirm,
  });

  const { writeAsync: mintBatchAsync10 } = useScaffoldContractWrite({
    contractName: "MovingMondrian",
    functionName: "mintBatch",
    args: [BigInt(10)],
    value: BigInt(10 * mintCostWei),
    onBlockConfirmation: onBlockConfirm,
  });

  const mapNumToMintFn = [
    mintBatchAsync1,
    mintBatchAsync2,
    null,
    null,
    mintBatchAsync5,
    null,
    null,
    null,
    null,
    mintBatchAsync10,
  ];

  // Exeunt hideous hack 2
  // ---------------------

  const MintButton = ({ mintBatchSize }: MintButtonProps) => (
    <button
      className="MintButton"
      onClick={async () => {
        console.log(`Attempting to mint ${mintBatchSize} NFT${mintBatchSize === 1 ? "" : "s"}...`);
        setNumToMint(mintBatchSize);
        setTimeout(() => {
          // Without the 0.5 second timeout, the numToMintRef.current was not the updated value from setNumToMint...
          const checkMintBatchSize = numToMintRef.current;
          console.log(`Requested ${mintBatchSize}, actual ${checkMintBatchSize}`);
          // mintBatchAsync();

          // Hideous hack 2 encore...
          const mintFn: any = mapNumToMintFn[mintBatchSize - 1];
          mintFn();

          console.log(`Minted ${checkMintBatchSize} NFT${mintBatchSize === 1 ? "" : "s"}`);
        }, 500);
      }}
    >
      <b>
        {/* Mint {mintBatchSize} NFT{mintBatchSize === 1 ? "" : "s"} for {mintBatchSize * mintCostETH} ETH - Mint {mintBatchSize} */}
        Mint {mintBatchSize} for {`${mintBatchSize * mintCostETH}`.slice(0, 7)} ETH
      </b>
    </button>
  );

  const batchSizesToUse = [1, 2, 5, 10];
  const MintButtonRow = () => (
    <span style={{ fontSize: "110%" }}>
      {batchSizesToUse.map(x =>
        mintsRemaining >= x ? (
          <span key={x}>
            <MintButton mintBatchSize={x} />
          </span>
        ) : (
          <span key={x} />
        ),
      )}
    </span>
  );

  return (
    <>
      <MetaHeader />
      <div className="flex items-center flex-col flex-grow pt-10">
        <div className="px-5">
          <h1 className="text-center">
            <span className="block text-4xl font-bold MovingMondrians">Moving Mondrians</span>
            <br />
            <span className="block text-1xl">
              Animated SVG NFTs, fully generated onchain, developed for Optimism&apos;s &quot;We Love The Art&quot;
            </span>
            <br />
            {loadedStats ? (
              mintedOut ? (
                <span className="block" style={{ fontSize: "150%" }}>
                  <b>All {mintLimit} NFTs have been minted!</b>
                </span>
              ) : (
                <span>
                  <span className="block" style={{ fontSize: "150%" }}>
                    Minted: {mintsCompleted} / {mintLimit}&nbsp;&nbsp;&nbsp;👀
                  </span>
                  <br />
                  <MintButtonRow />
                </span>
              )
            ) : (
              <span>Loading onchain data...</span>
            )}
          </h1>
        </div>
        <div className="flex-grow bg-base-300 w-full mt-16 px-8 py-12">
          <div className="flex justify-center items-center gap-12 flex-col sm:flex-row">
            {imageData.map(item => (
              <span key={item[2]} style={{ background: "rgb(100,110,200)", padding: "10px" }}>
                <Image alt={item[1]} src={item[0]} width="512" height="512" style={{ padding: "10px" }} />
                <b>
                  MONDO #{item[4]} owned by {item[5]}
                </b>
                <br />
                {processAttributes(item[3]).map((item2: any) => (
                  <span key={item2}>
                    {item2}
                    <br />
                  </span>
                ))}
              </span>
            ))}
          </div>
        </div>
        <div style={{ margin: "10px" }}>Build number {BUILD_NUMBER}</div>
      </div>
    </>
  );
};

export default Home;
