# MetaMask & Wallet Integration Setup

This guide explains how to set up real cryptocurrency wallet integration in the Anchor app using Reown AppKit (formerly WalletConnect).

## Prerequisites

1. **Reown Account** - Create a free account at [cloud.reown.com](https://cloud.reown.com/)
2. **Alchemy Account** (optional) - For better RPC performance at [alchemy.com](https://www.alchemy.com/)

## Quick Setup

### 1. Get Your Reown Project ID

1. Go to [cloud.reown.com](https://cloud.reown.com/)
2. Create a new project
3. Copy your **Project ID**

### 2. Run the App with Your Project ID

```bash
# Using environment variable (recommended)
flutter run --dart-define=REOWN_PROJECT_ID=your_project_id_here

# With Alchemy API key for better RPC (optional)
flutter run \
  --dart-define=REOWN_PROJECT_ID=your_project_id_here \
  --dart-define=ALCHEMY_API_KEY=your_alchemy_key_here
```

### 3. Alternative: Edit the Config File

If you prefer, you can directly edit `lib/config/web3_config.dart`:

```dart
static const String projectId = 'your_project_id_here';
```

## Supported Wallets

The app automatically detects and supports:

- **MetaMask** - Most popular Ethereum wallet
- **Trust Wallet** - Multi-chain mobile wallet
- **Coinbase Wallet** - Coinbase's official wallet
- **Rainbow** - User-friendly Ethereum wallet
- **WalletConnect** - Connect any WalletConnect-compatible wallet
- And 300+ other wallets

## Platform-Specific Setup

### iOS

The app is already configured to detect installed wallets. If you're building for iOS:

```bash
cd ios
pod install
cd ..
```

### Android

No additional setup required. Wallet detection is configured in `AndroidManifest.xml`.

## Testing

### Using Testnet (Recommended for Development)

By default, the app is configured to use **Sepolia Testnet** for safe testing:

1. Get testnet ETH from [sepoliafaucet.com](https://sepoliafaucet.com/)
2. Switch your wallet to Sepolia network
3. Test payments without real money

### Switching to Mainnet

Edit `lib/config/web3_config.dart`:

```dart
static const bool useTestnet = false;  // Change to false for mainnet
```

## How It Works

1. **Connect Wallet** - User taps "Connect wallet" button
2. **Wallet Selection** - Beautiful modal shows available wallets
3. **Approve Connection** - User approves in their wallet app
4. **Sign Transaction** - For payments, user signs the transaction
5. **Complete** - Transaction is sent to the blockchain

## Features

- **Multi-wallet support** - MetaMask, Trust, Coinbase, Rainbow, and more
- **Multi-chain support** - Ethereum, Polygon, Arbitrum, Sepolia
- **Deep linking** - Seamless redirect between app and wallet
- **Session persistence** - Stay connected across app restarts
- **Beautiful UI** - Native wallet selection modal

## Troubleshooting

### "Wallet not found" on iOS Simulator

iOS Simulator doesn't have real wallets installed. Test on a real device or use WalletConnect QR code to connect a wallet on another device.

### "Connection rejected"

Make sure:

1. Your Reown Project ID is correct
2. The app's bundle ID is registered in your Reown project
3. The user approved the connection in their wallet

### Transaction Fails

Check:

1. Sufficient balance for gas fees
2. Correct network selected
3. Wallet is unlocked

## Security Notes

- Never commit your Project ID to public repositories
- Use environment variables for sensitive configuration
- Test thoroughly on testnet before mainnet
- The recipient wallet address in config is where payments are sent

## Resources

- [Reown AppKit Documentation](https://docs.reown.com/appkit/flutter)
- [Ethereum Development](https://ethereum.org/developers)
- [Sepolia Testnet Faucet](https://sepoliafaucet.com/)
