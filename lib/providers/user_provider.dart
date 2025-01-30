import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shoporia_app/controllers/db_service.dart';
import 'package:shoporia_app/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  StreamSubscription<DocumentSnapshot>? userSubscription;
  String name = 'User';
  String email = '';
  String address = '';
  String phone = '';

  UserProvider() {
    loadUserData();
  }

  void loadUserData() {
    userSubscription?.cancel();
    userSubscription = DbService().readUserdata().listen((snapshot) {
      final UserModel data =
          UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
      name = data.name;
      email = data.email;
      address = data.address;
      phone = data.phone;
      notifyListeners();
    });
  }

  void cancelProvider() {
    userSubscription?.cancel();
  }

  @override
  void dispose() {
    cancelProvider();
    super.dispose();
  }
}
