// ignore_for_file: unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_notes/home_page.dart';
import 'package:firebase_notes/sign_up_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  //route defined here
  static route() => MaterialPageRoute(
        builder: (context) => const LoginPage(),
      );

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  //firebase enail pasward login funcion
  Future<void> loginUserWithEmailAndPassword() async {
    try {
      //using this user credential we can get all data
      final userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Navigator.of(context).pushReplacement(MyHomePage.route());
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(child: Text("Failed to LogIn: ${e.message}")),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Sign In.",
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                hintText: "Email",
              ),
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(
                hintText: 'Password',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await loginUserWithEmailAndPassword();
              },
              child: const Text(
                "SIGN IN",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(context, SignUpPage.route());
              },
              child: RichText(
                text: TextSpan(
                    text: 'Don\'t have an account? ',
                    style: Theme.of(context).textTheme.titleMedium,
                    children: [
                      TextSpan(
                          text: 'Sign Up',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ))
                    ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
