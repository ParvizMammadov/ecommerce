import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:monny/screens/Signin_screen.dart';
import 'package:monny/firebase/auth.dart';

class RegScreen extends StatefulWidget {
  const RegScreen({super.key});

  @override
  State<RegScreen> createState() => _RegScreenState();
}

class _RegScreenState extends State<RegScreen> {
  final TextEditingController _emailConntroller = TextEditingController();
  final TextEditingController _passwordConntroller = TextEditingController();
  // bool _isLoading = false;
  String? _error = 'ok';
  // @override
  // void dispose() {
  //   _emailConntroller;
  //   _passwordConntroller;
  //   super.dispose();
  // }
  Future<void> register() async {
    try {
      await AuthService().signUprWithEmailPassword(
          email: _emailConntroller.text, password: _passwordConntroller.text);
    } on FirebaseAuthException catch (e) {
      _error = e.message.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Registration Screen',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 100, left: 10, right: 10),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                hintText: 'NickName',
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _emailConntroller,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                hintText: 'E-Mail',
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _passwordConntroller,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                hintText: 'Password',
              ),
            ),
            const SizedBox(
              height: 60,
            ),
            ElevatedButton(
              onPressed: () {
                register();
              },
              child: const Text(
                'Lets do it',
                style: TextStyle(color: Colors.black),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SigninScreen(),
                      ));
                },
                child: const Text('Go to Sign in Screen'))
          ],
        ),
      ),
    );
  }
}
