import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:socify/constants.dart';
import 'package:socify/model/data/user.dart';
import 'package:socify/model/services/firebase_auth.dart';
import 'package:socify/view/screens/home_screen.dart';
import 'package:socify/view/widgets/show_snackbar.dart';
import 'package:socify/view_model/respositories/user_respository.dart';

class SignUpScreen extends StatefulWidget {
  static String routeName = '/signup-email-password';
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confPasswordController = TextEditingController();

  bool _hidden = true;

  @override
  Widget build(BuildContext context) {
    void signUpUser() async {
      if (!formKey.currentState!.validate()) {
        showSnackBar(context, "Enter all values");
        return;
      }
      await context.read<FirebaseAuthMethods>().signUpWithEmail(
            email: emailController.text,
            password: passwordController.text,
            context: context,
            nameController: nameController,
            emailController: emailController,
          );

      Navigator.of(context).pushAndRemoveUntil(
        PageTransition(
          child: HomeScreen(),
          type: PageTransitionType.fade,
        ),
        (route) => false,
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xffd6e2ea),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.85,
          width: MediaQuery.of(context).size.width * 0.9,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            // border: Border.all(
            //   width: 5,
            //   color: Color(0xffbababa),
            // ),
            color: Colors.white,

            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Sign Up",
                  style: TextStyle(fontSize: 30),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: nameController,
                        hintText: 'Enter your name',
                        textInputType: TextInputType.name,
                        validate: (val) {
                          if (val == null) {
                            return "Please enter your name";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        controller: emailController,
                        hintText: 'Enter your email',
                        textInputType: TextInputType.emailAddress,
                        validate: (val) {
                          if (val == null) {
                            return "Please enter your email";
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}')
                              .hasMatch(val)) {
                            return "Please enter valid email";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        controller: phoneController,
                        hintText: 'Enter your phone number',
                        textInputType: TextInputType.phone,
                        validate: (val) {
                          if (val == null) {
                            return "Please enter your phone number";
                          }
                          if (!RegExp(r'^(\+\d{1,2}\s)?\(?\d{3}\)?\d{3}\d{4}$')
                              .hasMatch(val)) {
                            return "Please enter valid phone number";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        controller: passwordController,
                        hintText: 'Enter your password',
                        hidden: _hidden,
                        textInputType: TextInputType.visiblePassword,
                        suffixIcon: IconButton(
                          onPressed: () {
                            _hidden = !_hidden;
                            setState(() {});
                          },
                          icon: Icon(
                            (_hidden)
                                ? CupertinoIcons.eye
                                : CupertinoIcons.eye_slash,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        controller: confPasswordController,
                        hintText: 'Confirm your password',
                        hidden: _hidden,
                        validate: (val) {
                          if (val == null) {
                            return "Enter password";
                          }
                          if (val != passwordController.text) {
                            return "Enter same password";
                          }
                          return null;
                        },
                        textInputType: TextInputType.visiblePassword,
                        suffixIcon: IconButton(
                          onPressed: () {
                            _hidden = !_hidden;
                            setState(() {});
                          },
                          icon: Icon(
                            (_hidden)
                                ? CupertinoIcons.eye
                                : CupertinoIcons.eye_slash,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                FilledButton(
                  onPressed: signUpUser,
                  style: FilledButton.styleFrom(
                    minimumSize:
                        Size(MediaQuery.of(context).size.width / 2.5, 50),
                  ),
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool hidden;
  FormFieldValidator? validate;
  TextInputType? textInputType;
  Widget? suffixIcon;

  CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.hidden = false,
    this.validate,
    this.textInputType,
    this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validate,
      keyboardType: textInputType,
      obscureText: hidden,
      decoration: kInputTextDecoration.copyWith(
        hintText: hintText,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
