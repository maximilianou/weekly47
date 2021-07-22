# weekly47
## learning 

## baby steps: learning smart contract, blockchains, solidity, nextjs, tailwind, ehters, hardhat..
### Building a digital marketplace with Next.js, Tailwind, Solidity, Hardhat, Ethers.js, IPFS, and Polygon

Reference:
- https://dev.to/dabit3/building-scalable-full-stack-apps-on-ethereum-with-polygon-2cfb

[![NFT Marketplace](https://github.com/maximilianou/weekly47/blob/8c5089b78c2c6e5afa2b7944ac11d42dba6d1653/share/NFT_publish202107201834.png?raw=true)](https://github.com/maximilianou/weekly47/blob/8c5089b78c2c6e5afa2b7944ac11d42dba6d1653/share/NFT_publish202107201834.png?raw=true)


#### dapp dmarket create feat-1401-dapp-create

- Makefile
```yaml
step47_1400 dmarket_create:
	cd dapp && npx create-next-app dmarket
	cd dapp/dmarket && npm i ethers hardhat @nomiclabs/hardhat-waffle
	cd dapp/dmarket && npm i ethereum-waffle chai @nomiclabs/hardhat-ethers
	cd dapp/dmarket && npm i web3modal @openzeppelin/contracts ipfs-http-client axios
	cd dapp/dmarket && npm i -D tailwindcss@latest postcss@latest autoprefixer@latest
	cd dapp/dmarket && npx tailwindcss init -p

step47_1499 dmarket_clean:
	cd dapp && rm -rf dmarket
```

- styles/global.css
```css
@tailwind base;
@tailwind components;
@tailwind utilities;
```

#### dapp dmarket hardhat configure
- Makefile
```yaml
step47_1401 dmarket_hardhat_init:
	cd dapp/dmarket && npx hardhat
```

```yaml
:~/projects/weekly47$ make dmarket_hardhat_init
cd dapp/dmarket && npx hardhat
888    888                      888 888               888
888    888                      888 888               888
888    888                      888 888               888
8888888888  8888b.  888d888 .d88888 88888b.   8888b.  888888
888    888     "88b 888P"  d88" 888 888 "88b     "88b 888
888    888 .d888888 888    888  888 888  888 .d888888 888
888    888 888  888 888    Y88b 888 888  888 888  888 Y88b.
888    888 "Y888888 888     "Y88888 888  888 "Y888888  "Y888

Welcome to Hardhat v2.4.3

✔ What do you want to do? · Create a sample project
✔ Hardhat project root: · /home/maximilianou/projects/weekly47/dapp/dmarket
✔ Do you want to add a .gitignore? (Y/n) · y

Project created

Try running some of the following tasks:
  npx hardhat accounts
  npx hardhat compile
  npx hardhat test
  npx hardhat node
  node scripts/sample-script.js
  npx hardhat help
```

#### dapp dmarket hardhat configure file

- Makefile
```yaml
step47_1402 dmarket_hardhat_secret:
	touch dapp/dmarket/.secret
```

- dapp/dmarket/hardhat.config.js
```js
/* hardhat.config.js */
require("@nomiclabs/hardhat-waffle")
const fs = require('fs')
const privateKey = fs.readFileSync(".secret").toString().trim() || "01234567890123456789"

module.exports = {
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {
      chainId: 1337
    },
    mumbai: {
      url: "https://rpc-mumbai.matic.today",
      accounts: [privateKey]
    }
  },
  solidity: {
    version: "0.8.4",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  }
}
```


##### hardhat spin up a local network
- Makefile
```yaml
step47_1404 dmarket_hardhat_node:
	cd dapp/dmarket && npx hardhat node
```
*( this will create a local network with 19 accounts )*

- output 1 ( local env )
```yaml
:~/projects/weekly47$ make dmarket_hardhat_node
cd dapp/dmarket && npx hardhat node
Started HTTP and WebSocket JSON-RPC server at http://127.0.0.1:8545/

Accounts
========
Account #0: 0xf39.............. (10000 ETH)
Private Key: 0xac0....................

Account #1: 0x709.................. (10000 ETH)
Private Key: 0x59c...............

Account #2: 0x3c4.................. (10000 ETH)
Private Key: 0x5de..................

Account #3: 0x90................... (10000 ETH)
Private Key: 0x7c...................
...
```
##### hardhat deploy a local network

- Makefile
```yaml
step47_1405 dmarket_hardhat_deploy_local:
	cd dapp/dmarket && npx hardhat run scripts/deploy.js --network localhost
```

- output 2 ( local env ) the address of the contracts
```yaml
:~/projects/weekly47$ make dmarket_hardhat_deploy_local
cd dapp/dmarket && npx hardhat run scripts/deploy.js --network localhost
Compiling 16 files with 0.8.4
Compilation finished successfully
nftMarket deployed to:  0x5F..................
nft deployed to:  0xe7....................
```
- output 1 ( local env )
```yaml
...
hardhat_addCompilationResult
web3_clientVersion
eth_chainId
eth_accounts
eth_blockNumber
eth_chainId (2)
eth_estimateGas
eth_gasPrice
eth_sendTransaction
  Contract deployment: NFTMarket
  Contract address:    0x5fb....................
  Transaction:         0x67b....................
  From:                0xf39....................
  Value:               0 ETH
  Gas used:            850147 of 850147
  Block #1:            0xfbd....................
eth_chainId
eth_getTransactionByHash
eth_chainId
eth_getTransactionReceipt
eth_accounts
eth_chainId
eth_estimateGas
eth_sendTransaction
  Contract deployment: NFT
  Contract address:    0xe7f....................
  Transaction:         0x1a8....................
  From:                0xf39....................
  Value:               0 ETH
  Gas used:            1389044 of 1389044
  Block #2:            0x7ac....................
eth_chainId
eth_getTransactionByHash
eth_chainId
eth_getTransactionReceipt
...
```
##### add config.js in root folder with contract address ( local env )

- dapp/dmarket/config.js
```ts
export const nftmarketaddress = '0x5Fb.....................';
export const nftaddress = '0xe7f.....................';
```

##### Metamask Import Account
- Switch Metamask wallet to localhost 8545
[![metamask wallet localhost](https://github.com/maximilianou/weekly47/share/metamasklocalhost202107141319.png)](https://github.com/maximilianou/weekly47/share/metamasklocalhost202107141319.png)




### Running nft-marketplace
- Makefile
```yaml
step47_1520 nftmarket_network_start:
	cd dapp/nft-marketplace && npx hardhat node

step47_1521 nftmarket_token_deploy_localhost:
	cd dapp/nft-marketplace && npx hardhat run scripts/deploy.js --network localhost

step47_1523 nftmarket_run_dev:
	cd dapp/nft-marketplace && npm run dev

step47_1524 nftmarket_on_your_browser:
	echo '1. Open your Browser in http://localhost:3000'
	echo '2. Install Metamask on your browser'
	echo '3. Import in Metamask 2 wallet, take the private key from the initial network running'
	echo '4. Add a new NFT over the Site, Using the Metamask Wallet Account A'
	echo '5. Buy the NFT, using the Metamask wallet account B'
	echo '6. Verify how it goes!'
```

- NFT.sol
```ts
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol';
import '@openzeppelin/contracts/utils/Counters.sol';
contract NFT is ERC721URIStorage {
  using Counters for Counters.Counter;
  Counters.Counter private  _tokenIds;
  address contractAddress;
  constructor(address marketplaceAddress) ERC721('Metaverse Token','METT') {
    contractAddress = marketplaceAddress;
  }
  function createToken(string memory tokenURI) public returns (uint) {
    _tokenIds.increment();
    uint256 newItemId = _tokenIds.current();
    _mint(msg.sender, newItemId);
    _setTokenURI(newItemId, tokenURI);
    setApprovalForAll(contractAddress, true);
    return newItemId;
  }
}
```
- NFTMarket.sol
```ts
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import '@openzeppelin/contracts/utils/Counters.sol';
import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/security/ReentrancyGuard.sol';
contract NFTMarket is ReentrancyGuard {
  using Counters for Counters.Counter;
  Counters.Counter private _itemIds;
  Counters.Counter private _itemsSold;
  address payable owner;
  uint256 listingPrice = 0.025 ether;
  constructor(){
    owner = payable(msg.sender);
  }
  struct MarketItem {
    uint itemId;
    address nftContract;
    uint256 tokenId;
    address payable seller;
    address payable owner;
    uint256 price;
    bool sold;
  }
  mapping(uint256 => MarketItem) private idToMarketItem;
  event MarketItemCreated(
    uint indexed itemId,
    address indexed nftContract,
    uint256 indexed tokenId,
    address seller,
    address owner,
    uint256 price,
    bool sold
  );
  function getListingPrice() public view returns (uint256){
    return listingPrice;
  }
  function createMarketItem(
    address nftContract,
    uint256 tokenId,
    uint256 price
  ) public payable nonReentrant {
    require( price > 0, 'Price must be at least 1 wei');
    require( msg.value == listingPrice, 'Price must be equal to listing price');
    _itemIds.increment();
    uint256 itemId = _itemIds.current();
    idToMarketItem[itemId] = MarketItem(
      itemId,
      nftContract,
      tokenId,
      payable(msg.sender),
      payable(address(0)),
      price,
      false
    );
    IERC721(nftContract).transferFrom(msg.sender, address(this), tokenId);
    emit MarketItemCreated(
      itemId,
      nftContract,
      tokenId,
      msg.sender,
      address(0),
      price,
      false
    );
  }
  function createMarketSale(
    address nftContract,
    uint256 itemId
  ) public payable nonReentrant {
    uint price = idToMarketItem[itemId].price;
    uint tokenId = idToMarketItem[itemId].tokenId;
    require(msg.value == price, 'Please submit the asking price in order to complete the purchase');
    idToMarketItem[itemId].seller.transfer(msg.value);
    IERC721(nftContract).transferFrom(address(this), msg.sender, tokenId);
    idToMarketItem[itemId].owner = payable(msg.sender);
    idToMarketItem[itemId].sold = true;
    _itemsSold.increment();
    payable(owner).transfer(listingPrice);
  }
  function fetchMarketItems() public view returns (MarketItem[] memory){
    uint itemCount = _itemIds.current();
    uint unsoldItemCount = _itemIds.current() - _itemsSold.current();
    uint currentIndex = 0;
    MarketItem[] memory items = new MarketItem[](unsoldItemCount);
    for(uint i = 0; i < itemCount; i++){
      if( idToMarketItem[i+1].owner == address(0) ){
        uint currentId = idToMarketItem[i+1].itemId;
        MarketItem storage currentItem = idToMarketItem[currentId];
        items[currentIndex] = currentItem;
        currentIndex += 1;
      }
    }
    return items;
  }
  function fetchMyNFTs() public view returns (MarketItem[] memory){
    uint totalItemCount = _itemIds.current();
    uint itemCount = 0;
    uint currentIndex = 0;
    for(uint i = 0; i < totalItemCount; i++){
      if(idToMarketItem[i+1].owner == msg.sender){
        itemCount += 1;
      }      
    }
    MarketItem[] memory items = new MarketItem[](itemCount);
    for(uint i = 0; i < totalItemCount; i++){
      if(idToMarketItem[i+1].owner == msg.sender){
        uint currentId = idToMarketItem[i+1].itemId;
        MarketItem storage currentItem = idToMarketItem[currentId];
        items[currentIndex] = currentItem;
        currentIndex += 1;
      }
    }
    return items;
  }
  function fetchItemCreated() public view returns (MarketItem[] memory){
    uint totalItemCount = _itemIds.current();
    uint itemCount = 0;
    uint currentIndex = 0;
    for(uint i = 0; i < totalItemCount; i++){
      if(idToMarketItem[i+1].seller == msg.sender){
        itemCount += 1;
      }
    }
    MarketItem[] memory items = new MarketItem[](itemCount);
    for(uint i = 0; i < totalItemCount; i++){
      if(idToMarketItem[i+1].seller == msg.sender){
        uint currentId = idToMarketItem[i+1].itemId;
        MarketItem storage currentItem = idToMarketItem[currentId];
        items[currentIndex] = currentItem;
        currentIndex += 1;
      }
    }
    return items;
  }
}
```

- scripts/deploy.js
```ts
const hre = require("hardhat");
async function main() {
  const NFTMarket = await hre.ethers.getContractFactory('NFTMarket');
  const nftMarket = await NFTMarket.deploy();
  await nftMarket.deployed();
  console.log(`nftMarket deployed to:`, nftMarket.address);
  const NFT = await hre.ethers.getContractFactory('NFT');
  const nft = await NFT.deploy(nftMarket.address);
  await nft.deployed();
  console.log(`nft deployed to:`, nft.address);
}
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
```
- test/sample-test.js
```ts
const { expect } = require("chai");

describe("NFTMarket", function () {
  it("Should create and execute market sales", async function () {
    const Market = await ethers.getContractFactory("NFTMarket");
    const market = await Market.deploy();
    await market.deployed();
    const marketAddress = market.address;
    const NFT = await ethers.getContractFactory("NFT");
    const nft = await NFT.deploy(marketAddress);
    await nft.deployed();
    const nftContractAddress = nft.address;
    let listingPrice = await market.getListingPrice();
    listingPrice = listingPrice.toString();
    const auctionPrice = ethers.utils.parseUnits('100','ether');
    await nft.createToken("https://www.mytokenlocation.com");
    await nft.createToken("https://www.mytokenlocation2.com");
    await market.createMarketItem(nftContractAddress, 1, auctionPrice, { value: listingPrice});
    await market.createMarketItem(nftContractAddress, 2, auctionPrice, { value: listingPrice});
    const [_, buyerAddress, thirdAdress, foutthAdress] = await ethers.getSigners();
    await market.connect(buyerAddress).createMarketSale(
      nftContractAddress, 1, { value: auctionPrice}
    );
    let items = await market.fetchMarketItems();
    items = await Promise.all(items.map(async i => {
      const tokenUri = await nft.tokenURI(i.tokenId);
      let item = {
        price: i.price.toString(),
        tokenId: i.tokenId.toString(),
        seller: i.seller,
        owner: i.owner,
        tokenUri
      }
      return item;
    }));
    console.log(`Items: `, items);
  });
});
```
- pages/_app.js
```tsx
import '../styles/globals.css';
import Link from 'next/link';
function MyApp({ Component, pageProps }) {
  return (
    <div>
      <nav className='border-b p-6'>
        <p className='text-4xl font-bold text-red-700'>Metaverse Marketplace</p>
        <div className='flex mt-4'>
          <Link href='/'>
            <a className='mr-6 text-yellow-600'>
              Home
            </a>
          </Link>
          <Link href='/create-item'>
            <a className='mr-6 text-yellow-600'>
              Sell Digital Asset
            </a>
          </Link>
          <Link href='/my-assets'>
            <a className='mr-6 text-yellow-600'>
              My Digital Assets
            </a>
          </Link>
          <Link href='/creator-dashboard'>
            <a className='mr-6 text-yellow-600'>
              Creator Dashboard
            </a>
          </Link>
        </div>
      </nav>
      <Component {...pageProps} />
    </div>
  )
}
export default MyApp
```

- pages/index.js
```tsx
import { ethers } from 'ethers';
import { useEffect, useState } from 'react';
import axios from 'axios';
import Web3Modal from 'web3modal';
import {
  nftaddress, nftmarketaddress
} from '../.config.js';
import NFT from '../artifacts/contracts/NFT.sol/NFT.json';
import Market from '../artifacts/contracts/NFTMarket.sol/NFTMarket.json';
export default function Home() {
  const [nfts, setNfts] = useState([]);
  const [loadingState, setLoadingState] = useState('not-loaded');
  useEffect( () => {
    loadNFTs();
  },[]);
  async function loadNFTs(){
    const provider = new ethers.providers.JsonRpcProvider(); 
    const tokenContract = new ethers.Contract(nftaddress, NFT.abi, provider);
    const marketContract = new ethers.Contract(nftmarketaddress, Market.abi, provider);
    const data = await marketContract.fetchMarketItems();
    const items = await Promise.all( data.map( async i => {
      const tokenUri = await tokenContract.tokenURI(i.tokenId);
      const meta = await axios.get(tokenUri);
      let price = ethers.utils.formatUnits(i.price.toString(), 'ether');
      let item = {
        price,
        tokenId: i.tokenId.toNumber(),
        seller: i.seller,
        owner: i.owner,
        image: meta.data.image,
        name: meta.data.name,
        description: meta.data.description
      }
      return item;
    }));
    setNfts(items);
    setLoadingState('loaded');
  }
  async function buyNft(nft){
    const web3Modal = new Web3Modal();
    const connection = await web3Modal.connect();
    const provider = new ethers.providers.Web3Provider(connection);
    const signer = provider.getSigner();
    const contract = new ethers.Contract(nftmarketaddress, Market.abi, signer);
    const price = ethers.utils.parseUnits(nft.price.toString(), 'ether');
    const transaction = await contract.createMarketSale(nftaddress, nft.tokenId, {
      value: price
    });
    await transaction.wait();
    loadNFTs();
 
  }
  if(loadingState === 'loaded' && !nfts.length) 
    return (<h1 className='px-20 py-10 text-3xl'>
      Empty Items in Marketplace</h1>);
  return (
    <div className='flex justify-center'>
      <div className='px-4' style={{ maxWidth: '1600px' }}>
        <div className='grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 pt-4'>
          {
            nfts.map( (nft, i) => (
              <div key={i} className='border shadow rounded-xl overflow-hidden'>
                <img src={nft.image} />
                <div className='p-4'>
                  <p style={{ height: '64px' }} className='text-2xl font-semibold'>
                    {nft.name}
                  </p>
                  <div style={{ height: '70px', overflow: 'hidden'}}>
                    <p className='text-gray-400'>{nft.description}</p>
                  </div>
                </div>
                <div className='p-4 bg-black'>
                  <p className='text-2xl mb-4 font-bold text-white'>{nft.price} Matic</p>
                  <button className='w-full bg-yellow-600 text-white font-bold py-2 px-12 rounded'
                    onClick={() => buyNft(nft)} >Buy</button>
                </div>
              </div>
            ))
          }
        </div>        
      </div>
    </div>
  )
}
```

- pages/create-item.js
```tsx
import { useState } from 'react';
import { ethers } from 'ethers';
import { create as ipfsHttpClient } from 'ipfs-http-client';
import { useRouter } from 'next/router';
import Web3Modal from 'web3modal';
const client = ipfsHttpClient(`https://ipfs.infura.io:5001/api/v0`);
import {
  nftaddress, nftmarketaddress
} from '../.config.js';
import NFT from '../artifacts/contracts/NFT.sol/NFT.json';
import Market from '../artifacts/contracts/NFTMarket.sol/NFTMarket.json';
export default function CreateItem(){
  const [fileUrl, setFileUrl] = useState(null);
  const [formInput, updateFormInput] = useState({ price: '', name: '', description: ''});
  const router = useRouter();
  async function onChange(e){
    const file = e.target.files[0];
    try{
      const added = await client.add( 
        file,
        {
          progress: (prog) => console.log(`received: ${prog}`) 
        }
      );
    const url = `https://ipfs.infura.io/ipfs/${added.path}`;
    setFileUrl(url);      
    }catch(e){
      console.log(e);
    }
  }
  async function createItem(){
    const { name, description, price } = formInput;
    if( !name || !description || !price || !fileUrl ) return;
    const data = JSON.stringify({
      name, description, image: fileUrl
    });
    try{
      const added = await client.add(data);
      const url = `https://ipfs.infura.io/ipfs/${added.path}`;
      createSale(url);
    }catch(e){
      console.log(e);
    }
  }
  async function createSale(url){
    const web3Modal = new Web3Modal();
    const connection = await web3Modal.connect();
    const provider = new ethers.providers.Web3Provider(connection);
    const signer = provider.getSigner();
    let contract = new ethers.Contract(nftaddress, NFT.abi, signer);
    let transaction = await contract.createToken(url);
    let tx = await transaction.wait();
    let event = tx.events[0];
    let value = event.args[2];
    let tokenId = value.toNumber();
    const price = ethers.utils.parseUnits(formInput.price, 'ether');
    contract = new ethers.Contract(nftmarketaddress, Market.abi, signer);
    let listingPrice = await contract.getListingPrice();
    listingPrice = listingPrice.toString();
    transaction = await contract.createMarketItem(nftaddress, tokenId, price, { value: listingPrice});
    await transaction.wait();
    router.push('/');
  }
  return (
    <div className='flex justify-center'>
      <div className='w-1/2 flex flex-col pb-12'>
        <input
           placeholder='Asset Name'
           className='mt-8 border rounded p-4'
           onChange={e => updateFormInput({ ...formInput, name: e.target.value })} 
          />
        <textarea
           placeholder='Asset Description'
           className='mt-8 border rounded p-4'
           onChange={e => updateFormInput( {...formInput, description: e.target.value} )}
         />
        <input 
          placeholder='Asset Price in Matic'
          className='mt-2 border rounded p-4'
          onChange={ e => updateFormInput({ ...formInput, price: e.target.value }) }
        />
        <input 
          type='file'
          name='Asset'
          className='my-4'
          onChange={onChange} 
        />
        {
          fileUrl && (
            <img className='rounded mt-4 ' width='350' src={fileUrl}  />
          )
        }
        <button 
          onClick={createItem}
          className='font-bold mt-4 bg-yellow-500 text-white rounded p-4 shadow-lg'
        >
          Create Digital Asset
        </button>
      </div>
    </div>
  )
}
```
- pages/my-assets.js
```tsx
import { ethers } from 'ethers';
import { useEffect, useState } from 'react';
import axios from 'axios';
import Web3Modal from 'web3modal';
import { nftaddress, nftmarketaddress } from '../.config.js';
import NFT from '../artifacts/contracts/NFT.sol/NFT.json';
import Market from '../artifacts/contracts/NFTMarket.sol/NFTMarket.json'
export default function MyAssets(){
  const [nfts, setNfts] = useState([]);
  const [loadingState, setLoadingState] = useState('not-loaded');
  useEffect( () => {
    loadNFTs();
  },[]);
  async function loadNFTs(){
    const web3Modal = new Web3Modal();
    const connection = await web3Modal.connect();
    const provider = new ethers.providers.Web3Provider(connection);
    const signer = provider.getSigner();
    const marketContract = new ethers.Contract(nftmarketaddress, Market.abi, signer);
    const tokenContract = new ethers.Contract(nftaddress, NFT.abi, provider);
    const data = await marketContract.fetchMyNFTs();
    const items = await Promise.all( data.map( async (i) => {
      const tokenUri = await tokenContract.tokenURI(i.tokenId);
      const meta = await axios.get(tokenUri);
      let price = ethers.utils.formatUnits(i.price.toString(), 'ether');
      let item = {
        price,
        tokenId: i.tokenId.toNumber(),
        seller: i.seller,
        owner: i.owner,
        image: meta.data.image,        
      };
      return item;
    }) );
    setNfts(items);
    setLoadingState('loaded');
  }
  if( loadingState === 'loaded' && !nfts.length ){ 
    return (
      <h1 className='py-10 px-20 text-3xl'
         >Empty assets owned</h1>
    );
  }
  return (
    <div className='flex justify-center'>
      <div className='p-4'>
        <div className='grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 pt-4'>
          {
            nfts.map( (nft, i) => (
              <div key={i} className='border shadow rounded-xl overflow-hidden'>
                <img src={nft.image} className='rounded' />
                <div className='p-4 bg-black'>
                  <p className='text-2xl font-bold text-white'
                    >Price - {nft.price} Matic</p>
                </div>
              </div>
            ) )
          }
        </div>
      </div>
    </div>
  );
}
```
- pages/creator-dashboard.js
```tsx
import { ethers } from 'ethers';
import { useEffect, useState } from 'react';
import axios from 'axios';
import Web3Modal from 'web3modal';
import { nftaddress, nftmarketaddress } from '../.config.js';
import NFT from '../artifacts/contracts/NFT.sol/NFT.json';
import Market from '../artifacts/contracts/NFTMarket.sol/NFTMarket.json';
export default function CreatorDashboard(){
  const [nfts, setNfts] = useState([]);
  const [sold, setSold] = useState([]);
  const [loadingState, setLoadingState] = useState('not-loaded');
  useEffect( () => {
    loadNFTs();
  }, []);
  async function loadNFTs(){
    const web3Modal = new Web3Modal();
    const connection = await web3Modal.connect();
    const provider = new ethers.providers.Web3Provider(connection);
    const signer = provider.getSigner();
    const marketContract = new ethers.Contract(nftmarketaddress, Market.abi, signer);
    const tokenContract = new ethers.Contract(nftaddress, NFT.abi, provider);
    const data = await marketContract.fetchItemCreated();
    const items = await Promise.all( data.map( async (i) => {
      const tokenUri = await tokenContract.tokenURI(i.tokenId);
      const meta = await axios.get(tokenUri); 
      let price = ethers.utils.formatUnits(i.price.toString(), 'ether');
      let item = {
        price,
        tokenId: i.tokenId.toNumber(),
        seller: i.seller,
        owner: i.owner,
        sold: i.sold,
        image: meta.data.image,
      };
      return item;
    }) );
    const soldItems = items.filter(i => i.sold);
    setSold(soldItems);
    setNfts(items);
    setLoadingState('loaded');
  }
  return (
    <div>
      <div className='p-4'>
        <h2 className='text-2xl py-2' 
            >Items Created</h2>            
        <div className='grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 pt-4'
            >
          {
            nfts.map( (nft, i) => (
              <div key={i} className='border shadow rounded-xl overflow-hidden'>
                <img src={nft.image} className='rounded'/>
                <div className='p-4 bg-black'>
                  <p className='text-2xl font-bold text-white'
                     >Price - {nft.price} Matic</p>
                </div>
              </div>
            ))
          }
        </div>
      </div>
      <div className='px-4'>
        {
          Boolean(sold.length) && (
            <div>
              <h2 className='text-2xl py-2'
                  >Items Sold</h2>
              <div className='grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 pt-4'>
                {
                  sold.map( (nft, i) => (
                    <div key={i} className='border shadow rounded-xl overflow-hidden'>
                      <img src={nft.image} className='rounded' />
                      <div className='p-4 bg-black'>
                        <p className='text-2xl font-bold text-white'
                           >Price - {nft.price} Matic</p>
                      </div>
                    </div>
                  ))
                }
              </div>
            </div>
          )
        }
      </div>
    </div>
  );
}
```
