import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:spacemesh_reward_tracker/data/client/swarmbit_poet.dart';
import 'package:spacemesh_reward_tracker/data/network_info.dart';

class NetworkInfoStorage {
  static final NetworkInfoStorage _singleton = NetworkInfoStorage._internal();

  final _storageNetworkInfoKey = "network_info";
  final _storageNetworkPoetsKey = "network_poets";

  Completer<SharedPreferences>? _completer;
  SharedPreferences? _prefs;

  NetworkInfoStorage._internal() {
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
    return _prefs!;
  }

  factory NetworkInfoStorage() {
    return _singleton;
  }

  NetworkInfo? getNetworkInfo() {
    NetworkInfo? networkInfo;
    if (_prefs != null) {
      var networkInfoStr = _prefs!.getString(_storageNetworkInfoKey);
      if (networkInfoStr != null) {
        networkInfo = NetworkInfo.fromJson(jsonDecode(networkInfoStr));
      }
    }
    return networkInfo;
  }

  Future<bool> saveNetworkInfo(NetworkInfo networkInfo) async {
    var sharedPrefs = await afterInit();
    return sharedPrefs.setString(
        _storageNetworkInfoKey, jsonEncode(networkInfo.toJson()));
  }

  Future<bool> savePoets(List<SwarmbitPoet> poets) async {
    var sharedPrefs = await afterInit();
    return sharedPrefs.setStringList(_storageNetworkPoetsKey,
        poets.map((e) => jsonEncode(e.toJson())).toList());
  }

  List<SwarmbitPoet>? getPoets() {
    List<SwarmbitPoet>? poets;
    if (_prefs != null) {
      var poetsString = _prefs!.getStringList(_storageNetworkPoetsKey);
      if (poetsString != null) {
        poets = poetsString
            .map((e) => SwarmbitPoet.fromJson(jsonDecode(e)))
            .toList();
      }
    }
    return poets;
  }
}
