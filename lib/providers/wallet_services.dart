// ignore_for_file: avoid_print
import 'dart:math';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wallet_app/constants.dart';
import 'package:wallet_app/providers/hive.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart' as web3;
import '../models/credentials.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart';

part 'wallet_services.g.dart';

@Riverpod(keepAlive: true)
class WalletServices extends _$WalletServices {
  double balance = 0.00;
  Credentials? creds;

  @override
  double build() {
    return state;
  }

  Future<void> createWallet() async {
    var rng = Random.secure();
    var random = web3.EthPrivateKey.createRandom(rng);

    var address = random.address;
    var privateKey = random.privateKey;

    var privateKeyHex = bytesToHex(privateKey).split('').reversed.join('');
    print(privateKeyHex.length);

    // Making sure privateKeyHex has exactly 64 characters
    if (privateKeyHex.length > 64) {
      privateKeyHex = privateKeyHex.substring(0, 64);
      print(privateKeyHex.length);
    }
    privateKeyHex = privateKeyHex.split('').reversed.join('');
    var addressHex = address.hex;

    print("$addressHex --- ${bytesToHex(privateKey)}");
    print(privateKeyHex);

    await (await ref.read(hiveDbProvider.future))
        .saveCredentials(privateKeyHex, addressHex);

    creds = Credentials(privateKeyHex: privateKeyHex, address: addressHex);
    await refreshBalance();
  }

  Future<double> intialize() async {
    creds = await (await ref.read(hiveDbProvider.future)).getCredentials();
    if (creds == null) {
      await createWallet();
    }
    await refreshBalance();
    state = balance;
    return balance;
  }

  Future<double> refreshBalance() async {
    if (creds == null) {
      return 0.00;
    }
    final client = web3.Web3Client(SEPOLIA_RPC_URL, Client());
    final credentials = web3.EthPrivateKey.fromHex(creds!.privateKeyHex);
    final address = credentials.address;
    final val = await client.getBalance(address);
    balance = val.getInWei / BigInt.from(1000000000000000000);
    state = balance;
    return balance;
  }

  Future<void> sendTransaction(String toAdress, double value) async {
    final client = web3.Web3Client(SEPOLIA_RPC_URL, Client());
    
    final credentials = web3.EthPrivateKey.fromHex(creds!.privateKeyHex);
    final address = credentials.address;
    final BigInt amo = BigInt.from(value * 1000000000000000000);
    print(address.hexEip55);
    print(amo);
    print(credentials.privateKey);
    print(await client.getGasPrice());
    print(await client.getBalance(address));
    var transaction = web3.Transaction(
        to: web3.EthereumAddress.fromHex(toAdress),
        value: web3.EtherAmount.fromBigInt(web3.EtherUnit.wei, amo));
    final supply = await client.signTransaction(credentials, transaction,
        chainId: 11155111);
    final result = await client.sendRawTransaction(supply);
    print(result);
    print(await client.getTransactionCount(address));
    // getTransections();
    await refreshBalance();
    await client.dispose();
  }

  // void getTransections() async {
  //   final url =
  //       'https://deep-index.moralis.io/api/v2/${creds!.address}/verbose?chain=sepolia';

  //   try {
  //     // Send the HTTP GET request with the required headers
  //     final response = await get(
  //       Uri.parse(url),
  //       headers: {
  //         'accept': 'application/json',
  //         'X-API-Key': MORALIS_API_KEY,
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       // Parse the JSON response
  //       print('Response: ${response.body}');
  //       list = Transect.fromJson(json.decode(response.body));
  //       print(list!.result!.length);
  //     } else {
  //       print('Request failed with status code: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error sending request: $e');
  //   }
  // }
}
