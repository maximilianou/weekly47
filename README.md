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

