import 'package:flutter/material.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.fromSwatch().copyWith(primary: Colors.blue),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: Colors.blue),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          hintStyle: TextStyle(color: Colors.grey),
          labelStyle: TextStyle(color: Colors.grey),
        ),
      ),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 80),
              const SizedBox(height: 10),
              Image.asset("assests/images/icon1.png", height: 200),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: SizedBox(
                    // Limit the max height to avoid infinite height error
                    // or you can remove height if you want it fully scrollable
                    height: MediaQuery.of(context).size.height * 0.55,
                    child: SignInScreen(
                      providers: [EmailAuthProvider()],
                      actions: [
                        AuthStateChangeAction<SignedIn>((context, state) {
                          Navigator.pushReplacementNamed(context, '/home');
                        }),
                      ],
                      showAuthActionSwitch: false,
                    ),
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
