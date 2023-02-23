import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socify/model/data/user.dart';
import 'package:socify/model/services/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    UserData userData = context.watch<UserData>();
    FirebaseAuthMethods methods = context.read<FirebaseAuthMethods>();
    print(userData.id);
    return Scaffold(
      body: Center(
        child: OutlinedButton(
          onPressed: () {
            methods.signOut(context);
          },
          child: Text("Log Out"),
        ),
      ),
    );
  }
}
