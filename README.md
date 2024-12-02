This Flutter package provides seamless interaction with the Solana blockchain. It supports functionalities like sending SOL and SPL tokens, 
fetching wallet balances, and connecting to the Solana network. Built with developers in mind, the package ensures robust, secure, 
and efficient transactions on the Solana blockchain.
## Features
Send SOL: Transfer native SOL tokens to any Solana wallet address.
Send SPL Tokens: Transfer any SPL token by specifying its mint address.
Get Balance: Fetch the current SOL or SPL token balance of a wallet.
Connect Wallet: Enable wallet connection and management.
Network Configuration: Easily switch between mainnet, testnet, and devnet.

## Getting started
Use this package as a library
Depend on it

flutter pub add Solana_Wallet

## Usage
Future<void> main() async {
  var solana = Solana();

  var seed = await solana.generateMnemonic();
  print("Seed phrase:-  $seed");

  var address = await solana.getSolanaAddress(mnemonic: seed);
  print("Solana Address:- $address");

  var solBalance = await solana.getbalance(
      address: '7ZrqonmBFEqN7kkAKRwHr6aaWCrqANWSHGSEjNeNxVoj',
      networktype: NetworkType.Devnet);
  print("Sol balance:- $solBalance");

  String testseed =
      'annual route hard section online fall employ valve glow february box audit';

  await solana.SendSolCoin(
          receiverAddress: 'B3iBp3F2xMHiwswx78RGzYiSVbQ54rpR9TmGUqdkA8d5',
          amount: num.parse('0.01'),
          networktype: NetworkType.Devnet,
          mnemonic: testseed)
      .then((Value) {
    print(Value);
  });

  await solana.SendToken(
          receiverAddress: 'B3iBp3F2xMHiwswx78RGzYiSVbQ54rpR9TmGUqdkA8d5',
          tokenAddress: '7QgoLNQCLfAc5mbBuERVXma1SxFmCokPgh6LBTqdU5Vh',
          amount: num.parse('0.01'),
          networktype: NetworkType.Devnet,
          mnemonic: testseed)
      .then((Value) {
    print(Value);
  });
}

```dart
 const solana = Solana();
```

