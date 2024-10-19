import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../data/account.dart';
import '../data/account_group.dart';
import '../data/state/address_label.dart';
import '../service/account_service.dart';
import '../storage/account_storage.dart';

class AccountsProvider extends ChangeNotifier {
  final AccountStorage _accountStorage = AccountStorage();
  AccountService accountService = AccountService();
  List<AddressLabel> _savedAccounts = [];
  bool initFinished = false;

  AccountGroup? accountGroup;

  AccountsProvider() {
    _accountStorage.afterInit().then((value) {
      _accountStorage.getAccountGroup().then((value) {
        accountGroup = value;
        notifyListeners();
      });
      // --- Migration to account labels --- //
      _accountStorage
          .getAccounts()
          .where((account) => account.label == null)
          .map((a) => a.address)
          .forEach((address) async {
        var stored = _accountStorage.getAccount(address);
        if (stored != null) {
          stored.setDefaultLabel();
          await _accountStorage.updateAccount(stored);
        }
      });
      //  --- //

      _savedAccounts = _accountStorage
          .getAccounts()
          .map((element) => AddressLabel(element.address, element.label))
          .toList();

      accountService
          .getAccountGroup(_savedAccounts.map((e) => e.address).toList())
          .then((value) {
        accountGroup = value;
        _accountStorage
            .saveAccountGroup(value)
            .then((value) => debugPrint("Saved account group"));
        notifyListeners();
      });

      initFinished = true;
      debugPrint("Loaded ${_savedAccounts.length} saved accounts");
      notifyListeners();
    });
  }

  UnmodifiableListView<AddressLabel> get savedAccounts =>
      UnmodifiableListView(_savedAccounts);

  void addAccount(Account account) async {
    await _accountStorage.addAccount(account);
    _savedAccounts.add(AddressLabel(account.address, account.label));
    notifyListeners();
    accountGroup = await accountService
        .getAccountGroup(_savedAccounts.map((e) => e.address).toList());
    _accountStorage
        .saveAccountGroup(accountGroup)
        .then((value) => debugPrint("Saved account group"));
    notifyListeners();
  }

  void removeAccount(String address) async {
    await _accountStorage.removeAccount(address);
    _savedAccounts.removeWhere((element) => element.address == address);
    notifyListeners();
    accountGroup = await accountService
        .getAccountGroup(_savedAccounts.map((e) => e.address).toList());
    _accountStorage
        .saveAccountGroup(accountGroup)
        .then((value) => debugPrint("Saved account group"));
    notifyListeners();
  }

  Future<bool> refreshAccountGroup() async {
    accountGroup = await accountService
        .getAccountGroup(_savedAccounts.map((e) => e.address).toList());
    _accountStorage
        .saveAccountGroup(accountGroup)
        .then((value) => debugPrint("Saved account group"));
    notifyListeners();
    return true;
  }

  void loadAccounts() {
    _savedAccounts = _accountStorage
        .getAccounts()
        .map((element) => AddressLabel(element.address, element.label))
        .toList();
    notifyListeners();
  }
}
