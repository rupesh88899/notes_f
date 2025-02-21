// ignore_for_file: unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_notes/login_page.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  //route defined here
  static route() => MaterialPageRoute(
        builder: (context) => const SignUpPage(),
      );

  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  //firebase enail pasward signin funcion
  Future<void> createUserWithEmailPasward() async {
    try {
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Navigator.of(context).pushReplacement(LoginPage.route());
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(child: Text("Failed to SignUp: ${e.message}")),
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
              "Sign Up.",
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const SizedBox(height: 20),
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
                await createUserWithEmailPasward();
              },
              child: const Text(
                "SIGN UP",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(context, LoginPage.route());
              },
              child: RichText(
                text: TextSpan(
                    text: 'Already have an account? ',
                    style: Theme.of(context).textTheme.titleMedium,
                    children: [
                      TextSpan(
                          text: 'Sign In',
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
