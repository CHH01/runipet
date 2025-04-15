import 'package:flutter/material.dart';
import 'screens/signup_screen.dart';

void main() {
  runApp(SignUpApp());
}

class SignUpApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '회원가입',
      debugShowCheckedModeBanner: false,
      home: SignUpScreen(),
    );
  }
}
