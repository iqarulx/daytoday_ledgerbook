import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'initiateprofile.dart';

class SigininWithMail extends StatefulWidget {
  const SigininWithMail({super.key});

  @override
  State<SigininWithMail> createState() => _SigininWithMailState();
}

class _SigininWithMailState extends State<SigininWithMail> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _message = '';

  Future<void> _signInOrRegister() async {
    final email = _email.text.trim();
    final password = _password.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _message = "Email and Password cannot be empty.";
      });
      return;
    }

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
      );

      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);

      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Initiateprofile(
            profileName: email,
          ),
        ),
      );
      setState(() {
        _message = "Welcome back, ${userCredential.user?.email}!";
      });
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);

      if (e.code == 'user-not-found') {
        try {
          final UserCredential userCredential = await _auth
              .createUserWithEmailAndPassword(email: email, password: password);

          setState(() {
            _message =
                "Account created successfully, ${userCredential.user?.email}!";
          });
        } on FirebaseAuthException catch (e) {
          setState(() {
            _message = "Error: ${e.message}";
          });
        }
      } else {
        setState(() {
          _message = "Error: ${e.message}";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login / Register"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Email",
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey.shade200,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _password,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                filled: true,
                fillColor: Colors.grey.shade200,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Theme.of(context).primaryColor),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                minimumSize: MaterialStateProperty.all(const Size(80, 40)),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              onPressed: _signInOrRegister,
              child: const Text(
                "Login / Register",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _message,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
