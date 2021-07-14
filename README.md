# weekly47
## learning graphql

## baby steps: learning smart contract, blockchains, solidity, nextjs, tailwind, ehters, hardhat..
### Building a digital marketplace with Next.js, Tailwind, Solidity, Hardhat, Ethers.js, IPFS, and Polygon

Reference:
- https://dev.to/dabit3/building-scalable-full-stack-apps-on-ethereum-with-polygon-2cfb

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

#### learning Smart Contracts

##### result of executing the test over command line, terminal for CI
- executing test
```js
:~/projects/weekly47$ make dmarket_hardhat_test
cd dapp/dmarket && npx hardhat test

  NFTMarket
items:  [
  {
    price: '1000000000000000000',
    tokenId: '2',
    seller: '0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266',
    owner: '0x0000000000000000000000000000000000000000',
    tokenUri: 'https://mytoken2.simpledoers.com'
  }
]
    ✓ Should create and execute market sales (1111ms)
  1 passing (1s)
```

##### Actions in a Makefile so it is scriptable in the CI
- Makefile
```yaml
step47_1403 dmarket_hardhat_test:
	cd dapp/dmarket && npx hardhat test
```

##### Test to TDD over the contracts, to have the starting points 
- dapp/dmarket/test/sample-test.js
```ts
/* test/sample-test.js */
/* test/sample-test.js */
// import { ethers } from "hardhat"; // SyntaxError: Cannot use import statement outside a module
describe('NFTMarket', () => {
  it('Should create and execute market sales', async () => {
    /* deploy the marketplace */
    const Market = await ethers.getContractFactory('NFTMarket');
    const market = await Market.deploy();
    await market.deployed();
    const marketAddress = market.address;
    /* deploy NFT contract */
    const NFT = await ethers.getContractFactory('NFT');
    const nft = await NFT.deploy(marketAddress);
    await nft.deployed();
    const nftContractAddress = nft.address;
    let listingPrice = await market.getListingPrice();
    listingPrice = listingPrice.toString();
    const auctionPrice = ethers.utils.parseUnits('1', 'ether');
    /* create two tokens */
    await nft.createToken('https://mytoken1.simpledoers.com');
    await nft.createToken('https://mytoken2.simpledoers.com');
    /* put both token for sale */
    await market.createMarketItem(nftContractAddress, 1, auctionPrice, { value: listingPrice });
    await market.createMarketItem(nftContractAddress, 2, auctionPrice, { value: listingPrice });
    const [_, buyerAddress] = await ethers.getSigners();
    /* execute sales of token to another user */
    await market.connect(buyerAddress).createMarketSale(nftContractAddress, 1, { value: auctionPrice });
    /* query for and return the unhold items */
    items = await market.fetchMarketItems();
    items = await Promise.all( items.map( async i => {
      const tokenUri = await nft.tokenURI(i.tokenId);
      let item = {
        price: i.price.toString(),
        tokenId: i.tokenId.toString(),
        seller: i.seller,
        owner: i.owner,
        tokenUri
      };
      return item;
    }));
    console.log('items: ', items);
  });
});
```
##### The Smart Contract of the NFT ( non-fungible token )
- dapp/dmarket/contracts/NFT.sol
```ts
// contracts/NFT.sol
// SPDX-License-Identifier: MIT or Apache-2.0
pragma solidity ^0.8.3;
import '@openzeppelin/contracts/utils/Counters.sol';
import '@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol';
import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import 'hardhat/console.sol';
contract NFT  is ERC721URIStorage {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;
  address contractAddress;
  constructor(address marketplaceAddress) ERC721('Metaverse Tokens', 'METT'){
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
##### The Smart Contract of the Market to create and sale Items
- dapp/dmarket/contracts/Market.sol
```ts
// contracts/Market.sol
// SPDX-License-Identifier: MIT or Apache-2.0
pragma solidity ^0.8.3;
import '@openzeppelin/contracts/utils/Counters.sol';
import '@openzeppelin/contracts/security/ReentrancyGuard.sol';
import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import 'hardhat/console.sol';
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
  event MarketItemCreated (
    uint indexed itemId,
    address indexed nftContract,
    uint256 indexed tokenId,
    address seller,
    address owner,
    uint256 price,
    bool sold
  );
  /* returns the listing price of a contract */
  function getListingPrice() public view returns (uint256) {
    return listingPrice;
  }
  /* places an item for sale on the marketplace */
  function createMarketItem(
    address nftContract,
    uint256 tokenId,
    uint256 price
  ) public payable nonReentrant {
    require( price > 0, "Price  must be at least 1 wei");
    require( msg.value == listingPrice, "Price must be equal to listing price");
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
  /* Creates the sale of a marketplace item */
  /* Transfers ownership of the item, as well as funds between parties */
  function createMarketSale(
    address nftContract,
    uint256 itemId
  ) public payable nonReentrant {
    uint price = idToMarketItem[itemId].price;
    uint tokenId = idToMarketItem[itemId].tokenId;
    require(msg.value == price,
      'Price submit the asking price in order to complete the purchase');
    idToMarketItem[itemId].seller.transfer(msg.value);
    IERC721(nftContract).transferFrom(address(this), msg.sender, tokenId);
    idToMarketItem[itemId].owner = payable(msg.sender);
    idToMarketItem[itemId].sold = true;
    _itemsSold.increment();
    payable(owner).transfer(listingPrice);
  }
  /* return all unsold market items */
  function fetchMarketItems() public view returns (MarketItem[] memory) {
    uint itemCount = _itemIds.current();
    uint unsoldItemCount = _itemIds.current() - _itemsSold.current();
    uint currentIndex = 0;
    MarketItem[] memory items = new MarketItem[](unsoldItemCount);
    for(uint i = 0; i < itemCount; i++){
      if(idToMarketItem[i + 1].owner == address(0)){
        uint currentId = idToMarketItem[i + 1].itemId;
        MarketItem storage currentItem = idToMarketItem[currentId];
        items[currentIndex] = currentItem;
        currentIndex += 1;
      }
    }
    return items;
  }
  /* returns only  itemas that a user  has purchased */
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
      if( idToMarketItem[i+1].owner == msg.sender){
        uint currentId = idToMarketItem[i+1].itemId;
        MarketItem storage currentItem = idToMarketItem[currentId];
        items[currentIndex] = currentItem;
        currentIndex += 1;
      }
    }
    return items;
  }
  /* returns only items a user has created */
  function fetchItemsCreated() public view returns (MarketItem[] memory) {
    uint totalItemCount = _itemIds.current();
    uint itemCount = 0;
    uint currentIndex = 0;
    for(uint i = 0; i < totalItemCount; i++ ){
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

#### dapp dmarket create feat-1410-dapp-ui

- dapp/dmarket/pages/_app.js
```jsx
/* pages/_app.js */
import '../styles/globals.css'
const MyApp = ({ Component, pageProps }) => {
  return (
    <>
      <nav className='border-b p-6'>
        <p className='text-4xl font-bold'>Metaverse Marketplace</p>
        <div className='flex mt-4'>
        <Link href='/'>
            <a className='mr-4 text-pink-500'>Home</a>
          </Link>
          <Link href='/create-item'>
            <a className='mr-6 text-pink-500'>Sell Digital Asset</a>
          </Link>
          <Link href='/my-assets'>
            <a className='mr-6 text-pink-500'>My Digital Asset</a>
          </Link>
          <Link href='/creator-dashboard'>
            <a className='mr-6 text-pink-500'>Creator Dashboard</a>
          </Link>          
        </div>
      </nav>
      <Component {...pageProps} /> 
    </>
  )
}
export default MyApp
```

- dapp/dmarket/pages/index.js
```jsx
/* pages/index.js */
import { ethers } from 'ethers';
import { useEffect, useState } from 'react';
import axios from 'axios';
import Web3Modal from 'web3modal';
import {
  nftaddress, nftmarketaddress
} from '../config';
import NFT from '../artifacts/contracts/NFT.sol/NFT.json';
import Market from '../artifacts/contracts/Market.sol/NFTMarket.json';
export default Home = () => {
  const [nfts, setNfts] = useState([]);
  const [loadingState, setLoadingState] = useState('not-loaded');
  useEffect( () => {
    loadNFTs();
  }, []);
  const loadNFTs = async () => {
    /* create a generic provider  and query for unsold  market items */
    const provider = new ethers.providers.JsonRpcProvider();
    const tokenContract = new ethers.Contract(nftaddress, NFT.abi, provider);
    const marketContract  = new ethers.Contract(nftmarketaddress, Market.abi, provider);
    const data = await marketContract.fetchMarketItems();
    /* map over items returned from smart contract 
       and format them well as fetch their token metadata */
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
        name: meta.data.name,
        description: meta.data.description
      };
      return item;
    } ));
    setNfts(items);
    setLoadingState('loaded');
  } 
  const buyNft = async () => {
    /* needs the user to sign the transaction, so will use Web3Provider and sign it */
    const web3Modal = new Web3Modal();
    const connection = await web3Modal.connect();
    const provider = new ethers.provider.Web3Provider(connection);
    const signer = provider.getSigner();
    const contract = new ethers.Contract(nftmarketaddress, Market.abi, signer);
    /* user will be prompted to pay  the asking process  to complete the transaction */
    const price = ethers.utils.parseUnits( nft.price.toString(), 'ether');
    const transaction = await contract.createMarketPlace(nftaddress, nft.tokenId, {
      value: price
    });
    await transaction.wait();
    loadNFTs();
  }
  if( loadingState === 'loaded' && !nft.length ) 
    return (<h1 className='px-20 py-10 text-3xl'>No items on marketplace</h1>);  
  return (
    <div className='flex justify-center'>
      <div className='px-4' style={{ maxWidth: '1600px'}}>
        <div className='grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 pt-4'>
          {
            nfts.map( (nft, i) => (
              <div key={i} className='border shadow rounded-xl overflow-hidden'>
                <img src={nft.image} />
                <div className='p-4' >
                  <p style={{ height: '64px' }} className='text-2xl font-semibold'>{nft.name}</p>
                  <div style={{ height: '70px', overflow: 'hidden'}}>
                    <p className='text-gray-400'>{nft.description}</p>
                  </div>
                </div>
                <div className='p-4 bg-black'>
                  <p className='text-2xl mb-4 font-bold text-white'>{nft.price} ETH</p>
                  <button className='w-full bg-pink-500 text-white font-bold py-2 px-2 rounded'
                    onClick={() => buyNft(nft)}>
                    Buy
                  </button>
                </div>
              </div>
            ))
          }
        </div>
      </div>
    </div>
  );
}
```

##### create and listing digital assets 

- dapp/dmarket/pages/create-item.js
```jsx
/* pages/create-item.js */
import { useState } from 'react';
import { ethers }  from 'ethers';
import { create as ipfsHttpClient} from 'ipfs-http-client';
import { useRouter } from 'next/router';
import Web3Modal from 'web3modal';
const client = ipfsHttpClient('https://ipfs.infura.io:5001/api/v0');
import {
  nftaddress, nftmarketaddress
} from '../config';
import NFT from '../artifacts/contracts/NFT.sol/NFT.json';
import Market from '../artifacts/contracts/Market.sol/NFTMarket.json';
export default Home = () => {
  const [fileUrl, setFileUrl] = useState(null);
  const [formInput, updateFormInput] = useState({ price: '', name: '', description: ''});
  const router = useRouter();
  const onChange = async (e) => {
    const file = e.target.files[0];
    try{
      const added = await client.add(file, 
        { progress: (prog) => console.log(`received: ${prog}`) });
      const url = `https://ipfs.infura.io/ipfs/${added.path}`;
      setFileUrl(url);
    }catch(error){
      console.log(`Error uploading file: `, error);
    }
  };
  const createMarket = async () => {
    const { name, description, price } = formInput;
    if( !name || !description || !price || !fileUrl ) return;
    /* first, upload to ipfs */
    const data = JSON.stringify({
      name, description, image: fileUrl
    });
    try{
      const added = await client.add(data);
      const url = `https://ipfs.infura.io/ipfs/${added.path}`;
      /* after file is uploaded in ipfs, pass the url to save into Polygon */
      createSale(url);
    }catch(error){
      console.log(`Error uploading file: `, error);
    }
  };
  const createSale = async (url) => {
    const web3Modal = new Web3Modal();
    const connection = await web3Modal.connect();
    const provider = new ethers.providers.Web3Provider(connection);
    const signer = provider.getSigner();
    /* and next, create the item */
    let contract = new ethers.Contract(nftaddress, NFT.abi, signer);
    let transaction = await contract.createToken(url);
    let tx = await transaction.wait();
    let event = tx.events[0];
    let value = event.args[2];
    let tokenId = value.toNumber();
    const price = ethers.utils.parseUnits( formInput.price, 'ether');
    /* then list the item for sale on the marketplace */
    contract = new ethers.Contract(nftmarketaddress, tokenId, price, { value: listingPrice });
    await transaction.wait();
    router.push('/');
  };
  return (
    <div className='flex justify-center'>
      <div className='w-1/2 flex flex-col pb-12'>
        <input placeholder='Asset Name'
               className='mt-8 border rounded p-4'
          onChange={ e => updateFormInput({...formInput, name: e.target.value})} />
        <textarea placeholder='Asset Description'
          className='mt-2 border rounded p-4'
          onChange={ e => updateFormInput({...formInput, description: e.target.value})} />
        <input placeholder='Asset Price in Eth'
          className='mt-2 border rounded p-4'
          onChange={ e => updateFormInput({...formInput, price: e.target.value}) } />
        <input type='file' 
          name='Asset'
          className='my-4'
          onChange={onChange} />
        {
          fileUrl && (
            <img className='rounded mt-4' width='350' src={fileUrl} />
          )
        }
        <button
          onClick={createMarket} 
          className='font-bold mt-4 bg-ping-500 text-white rounded p-4 shadow-lg'
          >Create Digital Asset</button>
      </div>
    </div>
  );
}
```

##### create dashboard
