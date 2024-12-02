import 'package:solana_wallet/solana_package.dart';
import 'package:solana/dto.dart';
import 'package:solana/solana.dart';
import 'package:solana_wallet/src/Content/AppContent.dart';
import 'package:solana_wallet/src/bip39.dart';
import 'package:solana_wallet/src/type.dart';

/// A Solana.
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
      if (isValidSolanaAddress(receiverAddress) == false) {
        throw new ArgumentError('Invalid receiver address');
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
      if (isValidSolanaAddress(receiverAddress) == false) {
        throw new ArgumentError('Invalid receiver address');
      }
      if (isValidSolanaAddress(tokenAddress) == false) {
        throw new ArgumentError('Invalid token address');
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
      return paramDic = {"status": "Error", "message": "$e"};
    }
  }

  Future<double> getbalance({
    required String address,
    required NetworkType networktype,
  }) async {
    SolanaClient client = _getclient(networktype);
    var tr = await client.rpcClient.getBalance('$address');
    print(tr.value / getPrecision(9));
    return tr.value / getPrecision(9);
  }

  Future<dynamic> getTokenbalance(
      {required String address,
      required String tokenadress,
      required NetworkType networktype}) async {
    try {
      if (isValidSolanaAddress(tokenadress) == false) {
        throw new ArgumentError('Invalid token address');
      }
      if (isValidSolanaAddress(address) == false) {
        throw new ArgumentError('Invalid address');
      }
      SolanaClient client = _getclient(networktype);

      var tokeninfo =
          await getTokenInfo(address: '$tokenadress', networktype: networktype);
      if (tokeninfo.toString().contains('NO')) {
        throw new ArgumentError('Token not found');
      }

      var tr = await client.rpcClient.getTokenAccountsByOwner(
          '$address',
          encoding: Encoding.jsonParsed,
          TokenAccountsFilter.byProgramId('${tokeninfo['value']['owner']}'));

      return tr.toJson()['value'][0]['account']['data']['parsed']['info']
          ['tokenAmount']['uiAmountString'];
    } catch (e) {
      return "$e";
    }
  }

  Future<dynamic> getTokenInfo(
      {required String address, required NetworkType networktype}) async {
    SolanaClient client = _getclient(networktype);
    try {
      var tr = await client.rpcClient
          .getAccountInfo(address, encoding: Encoding.jsonParsed);
      print(tr.toJson());
      return tr.toJson();
    } catch (e) {
      return {"NO": "no found"};
    }
    //data['value']['owner'].toString()
  }

  Future<dynamic> getTokenTransaction(
      {required String walletaddress,
      required String tokenname,
      required NetworkType networktype}) async {
    SolanaClient client = _getclient(networktype);
    var trans = await client.rpcClient.getSignaturesForAddress(
      '$walletaddress',
    );
    List _reportlist = [];
    for (int i = 0; i < trans.length; i++) {
      var decode = await getTransaction_Details(
          trans[i].toJson()['signature'], networktype);
      if (decode.containsKey('data')) {
        continue;
      }
      if (decode['parsed']['type'] == 'transfer' &&
          decode['program'] == tokenname) {
        decode['parsed']['info']['hash'] = trans[i].toJson()['signature'];
        decode['parsed']['info']['date'] = trans[i].toJson()['blockTime'];
        _reportlist.add(decode['parsed']['info']);
      }
    }
    return _reportlist;
  }

  Future<Map<String, dynamic>> getTransaction_Details(
      String sign, NetworkType networktype) async {
    SolanaClient client = _getclient(networktype);

    var tr = await client.rpcClient.getTransaction(sign,
        encoding: Encoding.jsonParsed, commitment: Commitment.finalized);
    print(tr!.meta!.postTokenBalances.toString());
    return tr!.transaction.toJson()['message']['instructions'][0];
  }
}
