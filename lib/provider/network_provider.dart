import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityProvider extends ChangeNotifier {
  late String? _connectionType;
  late bool _hasConnectionChanged;
  late Connectivity _connectivity;
  late StreamSubscription<List<ConnectivityResult>> _streamSubscription;

  ConnectivityProvider() {
    _connectivity = Connectivity();
    checkConnection();
  }

  void checkConnection() async {
    List<ConnectivityResult> connectionResult =
        await _connectivity.checkConnectivity();
    if (connectionResult.contains(ConnectivityResult.mobile)) {
      _connectionType = 'Mobile';
      notifyListeners();
    } else if (connectionResult.contains(ConnectivityResult.wifi)) {
      _connectionType = 'Wifi';
      notifyListeners();
    } else if (connectionResult.contains(ConnectivityResult.none)) {
      _connectionType = null;
      notifyListeners();
    }

    _streamSubscription = _connectivity.onConnectivityChanged.listen(
      (List<ConnectivityResult> event) {
        ConnectivityResult wifi = ConnectivityResult.wifi;
        ConnectivityResult mobile = ConnectivityResult.mobile;
        if (event.contains(wifi) || event.contains(mobile)) {
          _hasConnectionChanged = true;
          notifyListeners();
        } else if (event.contains(ConnectivityResult.none)) {
          _hasConnectionChanged = false;
          notifyListeners();
        }
      },
    );
  }

  String? get connectionType => _connectionType;
  bool get hasConnectionChanged => _hasConnectionChanged;

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }
}
