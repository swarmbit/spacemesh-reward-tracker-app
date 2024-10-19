import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spacemesh_reward_tracker/data/account_group.dart';

import '../data/account.dart';
import '../data/account_rewards.dart';

class AccountStorage {
  static final AccountStorage _singleton = AccountStorage._internal();

  final _storageAccountKey = "app.accounts.values.";
  final _storageAddressesKey = "app.account.addresses";
  final _storageNumberRewardsKey = "number_rewards";

  final _storageExpectedLayers = "expected_layers";

  final _storageExpectedLayersEpochs = "epochs_expected_layers";

  final _storageAccountGroup = "account_group";

  List<String> _addresses = [];
  final List<Account> _accounts = [];

  final Map<String, Map<String, List<AccountRewards>>> expectedRewardsEpoch =
      new Map();

  Completer<SharedPreferences>? _completer;
  SharedPreferences? _prefs;

  AccountStorage._internal() {
    _afterPrefsInit();
  }

  Future<SharedPreferences> afterInit() async {
    if (_prefs != null) {
      return Future.value(_prefs);
    } else {
      return _afterPrefsInit();
    }
  }

  Future<SharedPreferences> _afterPrefsInit() {
    if (_completer == null || _completer!.isCompleted) {
      _completer = Completer<SharedPreferences>();
      _initPrefs().then((value) {
        _prefs = value;
        _completer!.complete(value);
      });
    }
    return _completer!.future;
  }

  Future<SharedPreferences> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    var persistedAccountAddresses = _prefs!.getStringList(_storageAddressesKey);
    debugPrint("Load persisted account addresses: $persistedAccountAddresses");
    if (persistedAccountAddresses != null) {
      _addresses = persistedAccountAddresses;
      for (var address in _addresses) {
        var account = await _getAccountFromStorage(address);
        if (account != null) {
          _accounts.add(account);

          var expectedRewardsEpochs = await _getExpectedLayersEpochs(address);
          if (expectedRewardsEpochs != null) {
            expectedRewardsEpochs.forEach((element) async {
              var expectedLayers = await _getExpectedLayers(address, element);
              if (expectedLayers != null) {
                expectedRewardsEpoch.putIfAbsent(address, () => new Map());
                expectedRewardsEpoch[address]![element] = expectedLayers;
              }
            });
          }
        }
      }
    }

    return _prefs!;
  }

  factory AccountStorage() {
    return _singleton;
  }

  UnmodifiableListView<Account> getAccounts() {
    return UnmodifiableListView(_accounts);
  }

  UnmodifiableListView<AccountRewards>? getAccountEpochExpectedRewards(
      String address, num epoch) {
    var rewards = expectedRewardsEpoch[address]?[epoch.toString()]?.toList();
    if (rewards != null) {
      return UnmodifiableListView(rewards);
    }
    return null;
  }

  Account? getAccount(String address) {
    var accountIndex =
        _accounts.indexWhere((element) => element.address == address);
    if (accountIndex > -1) {
      return _accounts[accountIndex];
    } else {
      return null;
    }
  }

  Future<int?> getNumberRewards(String address) async {
    var sharedPrefs = await afterInit();
    return sharedPrefs
        .getInt("$_storageAddressesKey.$address.$_storageNumberRewardsKey");
  }

  Future<AccountGroup?> getAccountGroup() async {
    var sharedPrefs = await afterInit();
    var accountGroupStr = sharedPrefs.getString(_storageAccountGroup);
    if (accountGroupStr != null) {
      return AccountGroup.fromJson(jsonDecode(accountGroupStr));
    }
    return null;
  }

  bool accountExists(String address) {
    var accountIndex =
        _accounts.indexWhere((element) => element.address == address);
    return accountIndex > -1;
  }

  Future<bool> addAccount(Account account) async {
    debugPrint("account_storage.addAccount: ${account.toJson().toString()}");
    _accounts.add(account);
    _addresses.add(account.address);
    return await _addAccountToStorage(account);
  }

  Future<bool> addNumberRewards(String address, int numberRewards) async {
    var sharedPrefs = await afterInit();
    return await sharedPrefs.setInt(
        "$_storageAddressesKey.$address.$_storageNumberRewardsKey",
        numberRewards);
  }

  Future<bool> saveExpectedLayers(
      String address, num epoch, List<AccountRewards> expectedLayers) async {
    var sharedPrefs = await afterInit();
    var savedEpochs = sharedPrefs.getStringList(
        "$_storageAddressesKey.$address.$_storageExpectedLayersEpochs");
    if (savedEpochs != null) {
      savedEpochs.add(epoch.toString());
    } else {
      savedEpochs = [epoch.toString()];
    }
    expectedRewardsEpoch.putIfAbsent(address, () => new Map());
    expectedRewardsEpoch[address]![epoch.toString()] = expectedLayers;
    await sharedPrefs.setStringList(
        "$_storageAddressesKey.$address.$_storageExpectedLayersEpochs",
        savedEpochs);
    return await sharedPrefs.setStringList(
        "$_storageAddressesKey.$address.$epoch.$_storageExpectedLayers",
        expectedLayers.map((e) => json.encode(e.toJson())).toList());
  }

  Future<bool> saveAccountGroup(AccountGroup? accountGroup) async {
    var sharedPrefs = await afterInit();
    if (accountGroup != null) {
      await sharedPrefs.setString(
          _storageAccountGroup, jsonEncode(accountGroup));
    } else {
      await sharedPrefs.remove(_storageAccountGroup);
    }
    return true;
  }

  Future<bool> removeExpectedLayers(String address, num epoch) async {
    var sharedPrefs = await afterInit();
    await sharedPrefs.remove(
        "$_storageAddressesKey.$address.$epoch.$_storageExpectedLayers");
    if (expectedRewardsEpoch[address] != null) {
      expectedRewardsEpoch[address]!.remove(epoch.toString());
    }

    var savedEpochs = sharedPrefs.getStringList(
        "$_storageAddressesKey.$address.$_storageExpectedLayersEpochs");
    if (savedEpochs != null) {
      savedEpochs.remove(epoch);
      await sharedPrefs.setStringList(
          "$_storageAddressesKey.$address.$_storageExpectedLayersEpochs",
          savedEpochs);
    }
    return true;
  }

  Future<List<String>?> _getExpectedLayersEpochs(String address) async {
    var sharedPrefs = await afterInit();
    return await sharedPrefs.getStringList(
        "$_storageAddressesKey.$address.$_storageExpectedLayersEpochs");
  }

  Future<List<AccountRewards>?> _getExpectedLayers(
      String address, String epoch) async {
    var sharedPrefs = await afterInit();
    return await sharedPrefs
        .getStringList(
            "$_storageAddressesKey.$address.$epoch.$_storageExpectedLayers")
        ?.map((e) => AccountRewards.fromJson(jsonDecode(e)))
        .toList();
  }

  Future<bool> removeAccount(String address) async {
    _accounts.removeWhere((account) => account.address == address);
    _addresses.removeWhere((element) => element == address);
    return await _removeAccountFromStorage(address);
  }

  Future<bool> updateAccount(Account account) async {
    var accountIndex =
        _accounts.indexWhere((element) => element.address == account.address);
    if (accountIndex > -1) {
      _accounts[accountIndex] = account;
      return await _updateAccountOnStorage(account);
    } else {
      return false;
    }
  }

  Future<bool> _addAccountToStorage(Account account) async {
    var sharedPrefs = await afterInit();
    debugPrint("Add address to _addresses: $_addresses");
    await sharedPrefs.setStringList(_storageAddressesKey, _addresses);
    return sharedPrefs.setString(
        _getStorageKey(account.address), jsonEncode(account.toJson()));
  }

  Future<bool> _updateAccountOnStorage(Account account) async {
    var sharedPrefs = await afterInit();
    var key = _getStorageKey(account.address);
    if (sharedPrefs.getString(key) != null) {
      await sharedPrefs.remove(key);
    }
    return _addAccountToStorage(account);
  }

  Future<bool> _removeAccountFromStorage(String address) async {
    var sharedPrefs = await afterInit();
    await sharedPrefs.setStringList(_storageAddressesKey, _addresses);
    await sharedPrefs
        .remove("$_storageAddressesKey.$address.$_storageNumberRewardsKey");
    await _removeExpectedLayersFromStorage(address);
    return sharedPrefs.remove(_getStorageKey(address));
  }

  Future<bool> _removeExpectedLayersFromStorage(String address) async {
    var sharedPrefs = await afterInit();
    await sharedPrefs
        .remove("$_storageAddressesKey.$address.$_storageExpectedLayersEpochs");
    var epochLayersToClean = expectedRewardsEpoch[address];
    if (epochLayersToClean != null) {
      epochLayersToClean.forEach((key, value) async {
        await sharedPrefs.remove(
            "$_storageAddressesKey.$address.$key.$_storageExpectedLayers");
      });
    }
    return true;
  }

  Future<Account?> _getAccountFromStorage(String address) async {
    var sharedPrefs = await afterInit();
    var accountString = sharedPrefs.getString(_getStorageKey(address));
    if (accountString != null) {
      return Account.fromJson(jsonDecode(accountString));
    }
    return null;
  }

  String _getStorageKey(String address) {
    return _storageAccountKey + address;
  }
}
