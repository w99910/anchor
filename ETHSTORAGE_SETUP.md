# EthStorage Integration Setup

This guide explains how to set up EthStorage integration to store journal summaries on the blockchain.

## What is EthStorage?

EthStorage is a decentralized storage layer that provides long-term data availability powered by Ethereum. It allows you to permanently store data on-chain, making your journal summaries immutable and verifiable.

## Setup Instructions

### 1. Create a Wallet for Testing

⚠️ **IMPORTANT**: Create a **new wallet** specifically for testing. Never use your main wallet with real funds!

You can create a wallet using:

- MetaMask (browser extension or mobile app)
- Any Ethereum wallet that can show you your private key

### 2. Export Your Private Key

From your testing wallet, export the private key:

**MetaMask:**

1. Click on the three dots menu (⋮)
2. Go to "Account Details"
3. Click "Show Private Key"
4. Enter your password
5. Copy the private key (starts with `0x`)

### 3. Configure Environment Variables

Add your private key to the `.env` file in the project root:

```env
# EthStorage Configuration
# WARNING: Never commit this file with real keys!
ETHSTORAGE_PRIVATE_KEY=0xabcd1234...your_64_character_private_key_here

# Optional: Pre-deployed FlatDirectory contract address
# ETHSTORAGE_FLAT_DIRECTORY=0x...
```

**Security Notes:**

- The `.env` file is already in `.gitignore` (never commit it!)
- Use a dedicated testing wallet with only testnet tokens
- Never share your private key with anyone

### 4. Get Testnet ETH

You need Sepolia testnet ETH to pay for gas fees.

**Get Sepolia ETH from a faucet:**

1. Visit: https://sepoliafaucet.com/ or https://www.alchemy.com/faucets/ethereum-sepolia
2. Enter your wallet address
3. Request testnet ETH (you'll need ~0.01 ETH for several uploads)

### 5. Test the Integration

1. Run the app: `flutter run`
2. Create and finalize a journal entry
3. On the summary page, click "Store on EthStorage (Testnet)"
4. Wait for the transaction to complete
5. Click "View" to see your transaction on Etherscan

## Network Details

| Property       | Value                                  |
| -------------- | -------------------------------------- |
| Network Name   | Sepolia Testnet                        |
| RPC URL        | https://rpc.sepolia.org                |
| EthStorage RPC | https://rpc.testnet.ethstorage.io:9546 |
| Chain ID       | 11155111                               |
| Explorer       | https://sepolia.etherscan.io           |

## What Gets Stored?

When you upload a journal summary to EthStorage, the following data is stored:

```json
{
  "entryId": 123,
  "summary": "AI-generated summary of your entry...",
  "emotionStatus": "Reflective",
  "actionItems": ["suggestion 1", "suggestion 2"],
  "riskStatus": "low",
  "timestamp": "2026-01-31T12:00:00.000Z",
  "walletAddress": "0x...",
  "version": "1.0"
}
```

**Note:** The raw journal content is NOT stored on-chain, only the AI-generated analysis results.

## Costs

On the testnet, transactions are free (you use testnet tokens, not real ETH).

On mainnet (when available), typical costs would be:

- Gas fee: ~0.001-0.01 ETH
- Storage fee: Depends on data size

## Troubleshooting

### "EthStorage private key not configured"

Make sure you've added `ETHSTORAGE_PRIVATE_KEY` to your `.env` file and restarted the app.

### "Insufficient funds"

Get more testnet ETH from the faucet.

### "Transaction failed"

- Check the explorer for error details
- Make sure you're connected to the correct network
- Try increasing gas limit

### "Invalid private key format"

- Private key must start with `0x`
- Private key must be 66 characters (including `0x`)
- Make sure there are no extra spaces

## Resources

- [EthStorage Documentation](https://docs.ethstorage.io/)
- [EthStorage SDK](https://github.com/ethstorage/ethstorage-sdk)
- [Sepolia Etherscan](https://sepolia.etherscan.io)
- [Sepolia Faucet](https://sepoliafaucet.com/)
