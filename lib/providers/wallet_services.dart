import 'dart:math';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wallet_app/constants.dart';
import 'package:wallet_app/providers/dio.dart';
import 'package:wallet_app/providers/hive.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart' as web3;
import 'package:web_socket_channel/io.dart';
import '../models/credentials.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart';

import '../models/transaction.dart';

part 'wallet_services.g.dart';

@Riverpod(keepAlive: true)
class WalletServices extends _$WalletServices {
  late web3.Web3Client client;
  double balance = 0.00;
  Credentials? creds;
  List<Transaction> transactions = [];
  List<Transaction> pendingTransactions = [];

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

    // Making sure privateKeyHex has exactly 64 characters
    if (privateKeyHex.length > 64) {
      privateKeyHex = privateKeyHex.substring(0, 64);
    }
    privateKeyHex = privateKeyHex.split('').reversed.join('');
    var addressHex = address.hex;

    await (await ref.read(hiveDbProvider.future))
        .saveCredentials(privateKeyHex, addressHex);

    creds = Credentials(privateKeyHex: privateKeyHex, address: addressHex);
    await refreshBalance();
  }

  Future<double> intialize() async {
    client = web3.Web3Client(SEPOLIA_RPC_URL, Client());

    creds = await (await ref.read(hiveDbProvider.future)).getCredentials();
    if (creds == null) {
      await createWallet();
    }
    await refreshBalance();

    loop();
    state = balance;
    return balance;
  }

  Future<double> refreshBalance() async {
    if (creds == null) {
      return 0.00;
    }
    final credentials = web3.EthPrivateKey.fromHex(creds!.privateKeyHex);
    final address = credentials.address;
    final val = await client.getBalance(address);
    balance = val.getInWei / BigInt.from(1000000000000000000);
    state = balance;
    return balance;
  }

  Future<void> sendTransaction(String toAdress, double value) async {
    final credentials = web3.EthPrivateKey.fromHex(creds!.privateKeyHex);
    final BigInt amo = BigInt.from(value * 1000000000000000000);

    var transaction = web3.Transaction(
        to: web3.EthereumAddress.fromHex(toAdress),
        value: web3.EtherAmount.fromBigInt(web3.EtherUnit.wei, amo));
    final supply = await client.signTransaction(credentials, transaction,
        chainId: 11155111);
    String transactionHash = await client.sendRawTransaction(supply);
    transactions.insert(
      0,
      Transaction(
          hash: transactionHash,
          from: creds!.address,
          to: toAdress,
          value: value,
          timestamp: DateTime.now(),
          type: TransactionType.pending),
    );
    var transactionReceipt =
        await client.getTransactionReceipt(transactionHash);
    print(transactionReceipt);
    transactions[0].type = TransactionType.sent;
    await refreshBalance();
  }

  Future<void> getTransactions() async {
    final url =
        'https://deep-index.moralis.io/api/v2/${creds!.address}/verbose?chain=sepolia';

    try {
      // Send the HTTP GET request with the required headers
      final response = await ref.read(dioProvider).get(
            url,
            options: Options(
              headers: {
                'accept': 'application/json',
                'X-API-Key': MORALIS_API_KEY,
              },
            ),
          );

      if (response.statusCode != 200) {
        transactions = [];
        return;
      }

      // Convert and return the response as a List of Transactions
      final data = response.data['result'];
      transactions = List<Transaction>.from(
        data.map(
          (transaction) => Transaction(
            hash: transaction['hash'],
            from: transaction['from_address'],
            to: transaction['to_address'],
            // Convert value from wei to ether
            value: BigInt.from(double.parse(transaction['value'])) /
                BigInt.from(1000000000000000000),
            timestamp: DateTime.parse(transaction['block_timestamp']),
            type: transaction['from_address'] == creds!.address
                ? TransactionType.sent
                : TransactionType.received,
          ),
        ),
      );
    } catch (e) {
      // Rip
      print("Died lmao $e");
    }
  }

  Future<void> loop() async {}
}
