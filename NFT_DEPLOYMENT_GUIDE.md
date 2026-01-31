# Deploying Anchor Streak NFT Contract to Sepolia Testnet

This guide will walk you through deploying the NFT reward contract for the Anchor app. No prior blockchain development experience needed!

## Prerequisites

1. **MetaMask Wallet** - Browser extension
2. **Sepolia Test ETH** - Free, for gas fees

---

## Step 1: Set Up MetaMask

### Install MetaMask

1. Go to [metamask.io](https://metamask.io/)
2. Click "Download" and install the browser extension
3. Create a new wallet (save your seed phrase securely!)

### Add Sepolia Testnet

1. Open MetaMask
2. Click the network dropdown (top left, says "Ethereum Mainnet")
3. Click "Show test networks" toggle at the bottom
4. Select "Sepolia"

### Get Free Test ETH

You need test ETH to pay for deployment gas fees (completely free!):

| Faucet              | URL                                                               |
| ------------------- | ----------------------------------------------------------------- |
| Google Cloud Faucet | https://cloud.google.com/application/web3/faucet/ethereum/sepolia |
| Alchemy Faucet      | https://sepoliafaucet.com/                                        |
| Infura Faucet       | https://www.infura.io/faucet/sepolia                              |

1. Visit one of the faucets above
2. Connect your MetaMask wallet or paste your wallet address
3. Request test ETH (usually 0.1-0.5 ETH)
4. Wait a few seconds for it to arrive in your wallet

---

## Step 2: Deploy Using Remix IDE (Easiest Method)

### Open Remix

1. Go to [remix.ethereum.org](https://remix.ethereum.org/)
2. This is a browser-based IDE for Solidity - no installation needed!

### Create the Contract

1. In the left sidebar, click the "File Explorer" icon (📁)
2. Click the "+" button to create a new file
3. Name it `AnchorStreakNFT.sol`
4. Paste this contract code:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title AnchorStreakNFT
 * @dev NFT rewards for journaling streak milestones in Anchor app
 */
contract AnchorStreakNFT is ERC721, ERC721URIStorage, Ownable {
    uint256 private _tokenIdCounter;

    // Milestone IDs: 0=FirstStep, 1=WeekWarrior, 2=MonthlyMaster, 3=CenturyChampion, 4=YearLegend
    mapping(address => mapping(uint256 => bool)) public hasClaimed;

    // Base URI for metadata (can be updated later)
    string private _baseTokenURI;

    // Milestone names for events
    string[5] public milestoneNames = [
        "First Step",
        "Week Warrior",
        "Monthly Master",
        "Century Champion",
        "Year Legend"
    ];

    event StreakNFTMinted(
        address indexed recipient,
        uint256 indexed tokenId,
        uint256 indexed milestoneId,
        string milestoneName
    );

    constructor() ERC721("Anchor Streak NFT", "ANCHOR") Ownable(msg.sender) {
        _baseTokenURI = "https://anchor.app/api/nft/metadata/";
    }

    /**
     * @dev Mint a streak reward NFT
     * @param to Recipient address
     * @param milestoneId The milestone (0-4)
     */
    function mintStreakReward(address to, uint256 milestoneId) external {
        require(milestoneId < 5, "Invalid milestone");
        require(!hasClaimed[to][milestoneId], "Already claimed this milestone");

        hasClaimed[to][milestoneId] = true;

        uint256 tokenId = _tokenIdCounter;
        _tokenIdCounter++;

        _safeMint(to, tokenId);

        // Set token URI: baseURI + milestoneId
        string memory tokenURI = string(
            abi.encodePacked(_baseTokenURI, _toString(milestoneId))
        );
        _setTokenURI(tokenId, tokenURI);

        emit StreakNFTMinted(to, tokenId, milestoneId, milestoneNames[milestoneId]);
    }

    /**
     * @dev Check if an address has claimed a milestone
     */
    function hasClaimedMilestone(address user, uint256 milestoneId) external view returns (bool) {
        return hasClaimed[user][milestoneId];
    }

    /**
     * @dev Get all claimed milestones for an address
     */
    function getClaimedMilestones(address user) external view returns (bool[5] memory) {
        bool[5] memory claimed;
        for (uint256 i = 0; i < 5; i++) {
            claimed[i] = hasClaimed[user][i];
        }
        return claimed;
    }

    /**
     * @dev Update base URI (owner only)
     */
    function setBaseURI(string memory newBaseURI) external onlyOwner {
        _baseTokenURI = newBaseURI;
    }

    /**
     * @dev Get total minted NFTs
     */
    function totalSupply() external view returns (uint256) {
        return _tokenIdCounter;
    }

    // Required overrides
    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721URIStorage) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    // Helper to convert uint to string
    function _toString(uint256 value) internal pure returns (string memory) {
        if (value == 0) return "0";
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits--;
            buffer[digits] = bytes1(uint8(48 + value % 10));
            value /= 10;
        }
        return string(buffer);
    }
}
```

### Compile the Contract

1. Click the "Solidity Compiler" icon in the left sidebar (looks like "S")
2. Select compiler version: `0.8.20` or higher
3. Click "Compile AnchorStreakNFT.sol"
4. Wait for the green checkmark ✓

### Deploy the Contract

1. Click the "Deploy & Run" icon (looks like ▶️ with an arrow)
2. Set "Environment" to **"Injected Provider - MetaMask"**
3. MetaMask will pop up - confirm you're on Sepolia network
4. Make sure "AnchorStreakNFT" is selected in the Contract dropdown
5. Click **"Deploy"**
6. MetaMask will pop up asking you to confirm the transaction
7. Click "Confirm" and wait ~15-30 seconds

### Save Your Contract Address

1. After deployment, you'll see your contract under "Deployed Contracts"
2. Click the copy icon next to the contract address
3. **Save this address!** You'll need it for the app

Example: `0x1234567890abcdef1234567890abcdef12345678`

---

## Step 3: Verify on Etherscan (Optional but Recommended)

1. Go to [sepolia.etherscan.io](https://sepolia.etherscan.io/)
2. Search for your contract address
3. Click "Contract" tab → "Verify and Publish"
4. Fill in:
   - Compiler Type: Solidity (Single file)
   - Compiler Version: v0.8.20
   - License: MIT
5. Paste the contract code and submit

---

## Step 4: Update Your Flutter App

Open `lib/services/nft_service.dart` and update the contract address:

```dart
// Line ~82 - Update with your deployed contract address
static const String _contractAddress = '0xYOUR_CONTRACT_ADDRESS_HERE';
```

---

## Step 5: Test Minting

1. Run your Flutter app
2. Connect your MetaMask wallet (Settings → Web3)
3. Create a journal entry to get your first streak
4. Go to the Rewards page (tap the streak card)
5. Click "Mint" on the "First Step" NFT
6. Confirm in MetaMask
7. Check on OpenSea: `https://testnets.opensea.io/assets/sepolia/YOUR_CONTRACT_ADDRESS/0`

---

## NFT Metadata (Optional Enhancement)

For proper NFT images and descriptions, you can create metadata JSON files:

### Example: First Step (milestone 0)

Host this JSON at your baseURI + "0":

```json
{
  "name": "First Step",
  "description": "Completed your first journal entry in Anchor - the beginning of your mental wellness journey!",
  "image": "ipfs://YOUR_IMAGE_CID",
  "attributes": [
    { "trait_type": "Milestone", "value": "First Step" },
    { "trait_type": "Rarity", "value": "Starter" },
    { "trait_type": "Required Days", "value": 1 }
  ]
}
```

### Easy Metadata Hosting Options:

1. **IPFS via Pinata**: [pinata.cloud](https://pinata.cloud/) - Free tier available
2. **Your own server**: Host JSON files at `https://yoursite.com/api/nft/metadata/0`, `/1`, etc.
3. **GitHub Pages**: Free hosting for static JSON files

---

## Troubleshooting

### "Insufficient funds"

→ Get more test ETH from a faucet

### "Transaction failed"

→ Check that you're on Sepolia network in MetaMask

### "Already claimed this milestone"

→ Each wallet can only claim each milestone once (by design)

### Contract not deploying

→ Make sure compiler version matches (0.8.20+)

---

## Milestone Reference

| Index | Name             | Required Streak | Rarity    |
| ----- | ---------------- | --------------- | --------- |
| 0     | First Step       | 1 day           | Starter   |
| 1     | Week Warrior     | 7 days          | Common    |
| 2     | Monthly Master   | 30 days         | Rare      |
| 3     | Century Champion | 100 days        | Epic      |
| 4     | Year Legend      | 365 days        | Legendary |

---

## Need Help?

- Remix Docs: https://remix-ide.readthedocs.io/
- OpenZeppelin Docs: https://docs.openzeppelin.com/contracts/
- Sepolia Etherscan: https://sepolia.etherscan.io/
