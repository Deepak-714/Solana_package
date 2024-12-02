import 'package:bip39/bip39.dart' as bip39;

Future<bool> isvalidateMnemonic(String mnemonic) async {
  bool ischcek = await bip39.validateMnemonic(mnemonic);
  return ischcek;
}

Future<String> getMnemonic() async {
  String mnemonic = await bip39.generateMnemonic();
  return mnemonic;
}
