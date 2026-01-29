# Quick Start Guide - MetaMask Integration

## For You (Developer)

### 1. Get Your API Keys

**Infura (Recommended for beginners):**
1. Visit: https://infura.io/
2. Sign up → Create Project
3. Copy the endpoint URL from your project dashboard
   ```
   https://mainnet.infura.io/v3/YOUR_API_KEY
   ```

**WalletConnect:**
1. Visit: https://cloud.walletconnect.com/
2. Sign up → Create Project
3. Copy your Project ID

### 2. Configure

Edit `lib/config/web3_config.dart`:

```dart
class Web3Config {
  // Paste your Infura URL here
  static const String rpcUrl = 'https://mainnet.infura.io/v3/YOUR_API_KEY';
  
  // Paste your WalletConnect Project ID here
  static const String walletConnectProjectId = 'YOUR_PROJECT_ID';
  
  // Your Ethereum wallet address where you want to receive payments
  static const String recipientWalletAddress = '0xYOUR_WALLET_ADDRESS';
}
```

### 3. Test on Mobile

```bash
# Build and run on Android
flutter run

# Build and run on iOS
flutter run
```

**Note:** Web3 wallet connections work best on mobile devices. Desktop support varies by platform.

## For Testing

### Use Sepolia Testnet (Free Test ETH)

1. Change config to testnet:
```dart
static const String rpcUrl = 'https://sepolia.infura.io/v3/YOUR_API_KEY';
static const int chainId = 11155111; // Sepolia
```

2. Get free test ETH:
   - Visit: https://sepoliafaucet.com/
   - Enter your wallet address
   - Receive free test ETH

### Install MetaMask on Phone

- **Android:** https://play.google.com/store/apps/details?id=io.metamask
- **iOS:** https://apps.apple.com/app/metamask/id1438144202

## How Users Will Pay

1. User selects "Digital Wallet" payment option
2. User taps "Connect wallet" 
3. MetaMask app opens → User approves connection
4. Back in your app, user sees their wallet address
5. User taps "Pay $X"
6. MetaMask opens → User confirms transaction
7. Payment sent! ✅

## Common Issues

**"Wallet doesn't open"**
- Make sure MetaMask is installed on the phone
- Try restarting the app

**"Connection fails"**
- Double-check your WalletConnect Project ID
- Verify internet connection

**"Transaction rejected"**
- User cancelled in MetaMask
- User doesn't have enough ETH for gas fees

## Production Checklist

Before launching to real users:

- [ ] Test full flow on Sepolia testnet
- [ ] Switch to mainnet RPC URL
- [ ] Update chainId to 1 (mainnet)
- [ ] Test with small real payment
- [ ] Add error handling for edge cases
- [ ] Set up payment confirmation notifications
- [ ] Document payment flow for users
- [ ] Consider gas price fluctuations in pricing

## Cost Estimates

**Free Tiers:**
- Infura: 100,000 requests/day
- Alchemy: 300M compute units/month  
- WalletConnect: Unlimited

**Sufficient for:** Thousands of transactions per day

## Security Notes

1. **Never commit API keys to Git**
   - Add `lib/config/web3_config.dart` to `.gitignore`
   - Use environment variables in production

2. **Transaction Risks**
   - Transactions are irreversible
   - Test thoroughly before mainnet
   - Consider implementing a confirmation step

3. **User Experience**
   - ETH price fluctuates - update rates regularly
   - Show clear gas fee estimates
   - Provide helpful error messages

## Need Help?

- WalletConnect Discord: https://discord.com/invite/walletconnect
- Infura Docs: https://docs.infura.io/
- Flutter Web3: https://pub.dev/packages/web3dart

---

**Your implementation is ready!** Just add your API keys and you're good to go. 🚀
