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
