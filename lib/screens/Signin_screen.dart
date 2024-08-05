import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:monny/firebase/auth.dart';
import 'package:monny/screens/home_screen.dart';
import 'package:monny/screens/reg_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _RegScreenState();
}

class _RegScreenState extends State<SigninScreen> {
  final TextEditingController _emailConntroller = TextEditingController();
  final TextEditingController _passwordConntroller = TextEditingController();
  String? _error = 'ok';
  Future<void> signin() async {
    try {
      await AuthService().signInWithEmailPassword(
          _emailConntroller.text, _passwordConntroller.text);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
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
          'Signin Screen',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 100, left: 10, right: 10),
        child: Column(
          children: [
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
            const SizedBox(height: 10),
            const SizedBox(
              height: 60,
            ),
            ElevatedButton(
              onPressed: signin,
              child: const Text(
                'Signin',
                style: TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegScreen(),
                      ));
                },
                child: const Text('Dont have Account,Lets do it'))
          ],
        ),
      ),
    );
  }
}
