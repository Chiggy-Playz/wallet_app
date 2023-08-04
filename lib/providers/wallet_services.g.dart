// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_services.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$walletServicesHash() => r'f5afe444497cd5c10fab208f027788b0ecd0cca3';

/// See also [WalletServices].
@ProviderFor(WalletServices)
final walletServicesProvider =
    NotifierProvider<WalletServices, Wallet>.internal(
  WalletServices.new,
  name: r'walletServicesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$walletServicesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$WalletServices = Notifier<Wallet>;
String _$balanceHash() => r'7e2516fe086a48238599c1ca04b685fd2a54d264';

/// See also [Balance].
@ProviderFor(Balance)
final balanceProvider = NotifierProvider<Balance, double>.internal(
  Balance.new,
  name: r'balanceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$balanceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Balance = Notifier<double>;
String _$transactionsHash() => r'c74310f296c988a19d912e693fb6be7b6a77f30c';

/// See also [Transactions].
@ProviderFor(Transactions)
final transactionsProvider =
    NotifierProvider<Transactions, List<Transaction>>.internal(
  Transactions.new,
  name: r'transactionsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$transactionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Transactions = Notifier<List<Transaction>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
