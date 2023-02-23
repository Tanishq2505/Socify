import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:socify/model/services/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with AutomaticKeepAliveClientMixin<LoginScreen> {
  bool get wantKeepAlive => true;
  FocusNode emailFocusNode = FocusNode();
  TextEditingController emailController = TextEditingController();
  FocusNode passFocusNode = FocusNode();
  TextEditingController passController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  StateMachineController? controller;

  SMIInput<bool>? isChecking;
  SMIInput<double>? numLook;
  SMIInput<bool>? isHandsUp;
  SMIInput<bool>? trigSuccess;
  SMIInput<bool>? trigFail;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailFocusNode.addListener(emailFocusListener);
    passFocusNode.addListener(passFocusListener);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.removeListener(emailFocusListener);
    passController.removeListener(passFocusListener);
  }

  void emailFocusListener() {
    isChecking?.change(emailFocusNode.hasFocus);
  }

  void passFocusListener() {
    isHandsUp?.change(passFocusNode.hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    FirebaseAuthMethods methods = context.read<FirebaseAuthMethods>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xffd6e2ea),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 32,
              ),
              SizedBox(
                height: 250,
                width: 250,
                child: RiveAnimation.asset(
                  "assets/animated-login-screen.riv",
                  stateMachines: ["Login Machine"],
                  fit: BoxFit.fitHeight,
                  onInit: (Artboard artBoard) {
                    controller = StateMachineController.fromArtboard(
                      artBoard,
                      "Login Machine",
                    );
                    if (controller == null) return;
                    artBoard.addController(controller!);
                    isChecking = controller?.findInput("isChecking");
                    numLook = controller?.findInput("numLook");
                    isHandsUp = controller?.findInput("isHandsUp");
                    trigSuccess = controller?.findInput("trigSuccess");
                    trigFail = controller?.findInput("trigFail");
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                    16,
                  ),
                ),
                padding: const EdgeInsets.all(
                  16,
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(
                            8,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        child: TextFormField(
                          validator: (val) {
                            if (val == null) {
                              return "Please enter your email";
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(val)) {
                              return "Please enter valid email";
                            }
                            return null;
                          },
                          focusNode: emailFocusNode,
                          controller: emailController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Email",
                          ),
                          style: Theme.of(context).textTheme.bodyMedium,
                          onChanged: (value) {
                            numLook?.change(value.length.toDouble() * 2);
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(
                            8,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        child: TextFormField(
                          validator: (val) {
                            if (val == null || val == "" || val.isEmpty) {
                              return "Please enter password";
                            }
                            if (val.length <= 7) {
                              return "Password should has at least 8 letters.";
                            }
                            return null;
                          },
                          focusNode: passFocusNode,
                          controller: passController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Password",
                          ),
                          obscureText: true,
                          style: Theme.of(context).textTheme.bodyMedium,
                          onChanged: (value) {},
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 64,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: () {
                            formKey.currentState!.validate();
                            emailFocusNode.requestFocus();
                          },
                          child: const Text("Login"),
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      InkWell(
                        // onTap: () => Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (builder) => SignUpScreen(),
                        //   ),
                        // ),
                        child: RichText(
                          text: TextSpan(
                              text: "Don't have an account? ",
                              style: GoogleFonts.questrial(
                                color: Colors.black,
                              ),
                              children: [
                                TextSpan(
                                  text: "Sign Up",
                                  style: GoogleFonts.questrial(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black54,
                                  ),
                                ),
                                const TextSpan(
                                  text: " now.",
                                ),
                              ]),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.0),
                        child: Divider(
                          thickness: 2,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 64,
                        child: FilledButton.tonal(
                          style: FilledButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: () async {
                            emailFocusNode.requestFocus();
                            emailFocusNode.unfocus();

                            bool? success =
                                await methods.signInWithGoogle(context);
                            if (success == true) {
                              trigSuccess?.change(true);
                            } else {
                              trigFail?.change(true);
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Login using Google"),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.08,
                                child: Image.network(
                                  'http://pngimg.com/uploads/google/google_PNG19635.png',
                                  fit: BoxFit.cover,
                                  scale: 0.1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
