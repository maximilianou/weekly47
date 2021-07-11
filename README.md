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

