import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../../app/router/route_names.dart';

class SplashController extends ChangeNotifier {
  bool _isReady = false;

  bool get isReady => _isReady;

  Timer? _timer;

  void initialize({required void Function(String route) onComplete}) {
    _timer?.cancel();

    _timer = Timer(const Duration(milliseconds: 2200), () {
      _isReady = true;
      notifyListeners();

      onComplete(RouteNames.home);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
