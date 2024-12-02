import 'package:flutter_test/flutter_test.dart';

import 'package:solana_package/solana_package.dart';

Future<void> main() async {
  // test('adds one to input values', () {
  //   final calculator = Calculator();
  //   expect(calculator.addOne(2), 3);
  //   expect(calculator.addOne(-7), -6);
  //   expect(calculator.addOne(0), 1);
  // });
  var solana = Solana();

  ///Get the 12 words seed phrase with unique combination
  var seed = await solana.generateMnemonic();
  print("Seed phrase:-  $seed");

  ///Get the Solana address with 12 words seed phrase.
  var address = await solana.getSolanaAddress(mnemonic: seed);
  print("Solana Address:- $address");
}
