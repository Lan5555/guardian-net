import 'package:flutter/material.dart';
import 'package:guardian_net/models/user_model.dart';

class ProfileController extends ChangeNotifier {
  final BuildContext context;
  ProfileController({required this.context});
  UserModel? user;
  bool isLoading = false;

 

}
