import 'package:solana_wallet/solana_package.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> main() async {
  var solana = Solana();

  ///Get the 12 words seed phrase with unique combination
  var seed = await solana.generateMnemonic();
  print("Seed phrase:-  $seed");

  ///Get the Solana address with 12 words seed phrase.
  var address = await solana.getSolanaAddress(mnemonic: seed);
  print("Solana Address:- $address");

  ///Get the sol coin balance with account address.
  var solBalance = await solana.getbalance(
      address: '7ZrqonmBFEqN7kkAKRwHr6aaWCrqANWSHGSEjNeNxVoj',
      networktype: NetworkType.Devnet);
  print("Sol balance:- $solBalance");

  ///Testing seed phrase for Devnet
  String testseed =
      'annual route hard section online fall employ valve glow february box audit';

  ///transfer the sol from one account to other account
  await solana.SendSolCoin(
          receiverAddress: 'B3iBp3F2xMHiwswx78RGzYiSVbQ54rpR9TmGUqdkA8d5',
          amount: num.parse('0.01'),
          networktype: NetworkType.Devnet,
          mnemonic: testseed)
      .then((Value) {
    print(Value);
    //SUCESS {status: Done, message: 46SSVqsikY1r6QVyZRu2mPnYxLBCuXkCWY5v9gtFScwRDWU935MTFMerK4sdANhdiM3eJZCgRUXcrwesguwHGEtE}
  });

  ///Transfer the Solana base Token from one account to other account
  await solana.SendToken(
          receiverAddress: 'B3iBp3F2xMHiwswx78RGzYiSVbQ54rpR9TmGUqdkA8d5',
          tokenAddress: '7QgoLNQCLfAc5mbBuERVXma1SxFmCokPgh6LBTqdU5Vh',
          amount: num.parse('0.01'),
          networktype: NetworkType.Devnet,
          mnemonic: testseed)
      .then((Value) {
    print(Value);
    //SUCESS {status: Done, message: 46SSVqsikY1r6QVyZRu2mPnYxLBCuXkCWY5v9gtFScwRDWU935MTFMerK4sdANhdiM3eJZCgRUXcrwesguwHGEtE}
  });
}
