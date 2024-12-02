import 'package:Solana_Wallet/solana_package.dart';
import 'package:solana/solana.dart';
import 'package:Solana_Wallet/src/Content/AppContent.dart';
import 'package:Solana_Wallet/src/bip39.dart';
import 'package:Solana_Wallet/src/type.dart';

/// A Calculator.
class Solana {
  /// Returns [value]  Mnemonic values.
  Future<String> generateMnemonic() async {
    return await getMnemonic();
  }

  /// Returns [value] Solana address.
  Future<String> getSolanaAddress({required String mnemonic}) async {
    try {
      print(await isvalidateMnemonic(mnemonic));
      if (await isvalidateMnemonic(mnemonic) == false) {
        throw new ArgumentError('Invalid seed');
      }
      final senderWallet = await Ed25519HDKeyPair.fromMnemonic(mnemonic);
      return senderWallet.address;
    } catch (e) {
      throw new Exception('$e');
    }
  }

  /// Returns  SolanaClient.
  SolanaClient _getclient(NetworkType networktype) {
    SolanaClient client;
    if (networktype == NetworkType.Mainnet) {
      return client = SolanaClient(
        rpcUrl: Uri.parse(Content.Mainnet_RPC),
        websocketUrl: Uri.parse(Content.Mainnet_WEBRPC),
      );
    } else {
      return client = SolanaClient(
        rpcUrl: Uri.parse(Content.Devnet_RPC),
        websocketUrl: Uri.parse(Content.Devnet_WEBRPC),
      );
    }
  }

  Future<Map<String, String>> SendSolCoin({
    required String receiverAddress,
    required num amount,
    required NetworkType networktype,
    required String mnemonic,
  }) async {
    var paramDic;
    try {
      if (await isvalidateMnemonic(mnemonic) == false) {
        throw new ArgumentError('Invalid seed');
      }
      SolanaClient client = _getclient(networktype);

      final senderWallet = await Ed25519HDKeyPair.fromMnemonic(mnemonic);

      var sol = await client.transferLamports(
        destination: Ed25519HDPublicKey.fromBase58('$receiverAddress'),
        lamports: solToLamports(amount).toInt(),
        source: senderWallet,
      );
      return paramDic = {"status": "Done", "message": "$sol"};
    } catch (e) {
      return paramDic = {"status": "Error", "message": "$e"};
    }
  }

  Future<Map<String, String>> SendToken({
    required String receiverAddress,
    required String tokenAddress,
    required num amount,
    required NetworkType networktype,
    required String mnemonic,
  }) async {
    var paramDic;
    try {
      if (await isvalidateMnemonic(mnemonic) == false) {
        throw new ArgumentError('Invalid seed');
      }

      SolanaClient client = _getclient(networktype);

      final senderWallet = await Ed25519HDKeyPair.fromMnemonic(mnemonic);

      var sol = await client.transferSplToken(
          amount: solToLamports(amount).toInt(),
          destination: Ed25519HDPublicKey.fromBase58('$receiverAddress'),
          mint: Ed25519HDPublicKey.fromBase58(tokenAddress),
          owner: senderWallet);
      return paramDic = {"status": "Done", "message": "$sol"};
    } catch (e) {
      return paramDic = {"status": "Done", "message": "$e"};
    }
  }
}
