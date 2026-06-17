import 'package:flutter/material.dart';
import 'package:guardian_net/models/user_model.dart';

class SessionProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isLoggedIn = false;

  UserModel? get user => _user;
  bool get isLoggedIn => _isLoggedIn;

  void setUser(UserModel? user) {
    _user = user;
    _isLoggedIn = user != null;
    notifyListeners();
  }

  void logout() {
    _user = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}
