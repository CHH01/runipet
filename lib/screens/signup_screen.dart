import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    '회원가입',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(child: _buildTextField('아이디')),
                      SizedBox(width: 10),
                      _buildSmallButton('중복확인'),
                    ],
                  ),
                  SizedBox(height: 15),
                  _buildTextField('비밀번호', obscureText: true),
                  SizedBox(height: 15),
                  _buildTextField('비밀번호 재입력', obscureText: true),
                  SizedBox(height: 15),
                  _buildTextField('이름'),
                  SizedBox(height: 15),
                  _buildTextField('생년월일'),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(child: _buildTextField('이메일')),
                      SizedBox(width: 10),
                      _buildSmallButton('인증코드 발송'),
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(child: _buildTextField('인증코드 입력')),
                      SizedBox(width: 10),
                      _buildSmallButton('코드확인'),
                    ],
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        // 회원가입 버튼 클릭 시
                      },
                      child: Text(
                        '가입하기',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hintText, {bool obscureText = false}) {
    return TextFormField(
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Color(0xFFF5F5F5),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildSmallButton(String text) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      onPressed: () {
        // 버튼 클릭 이벤트
      },
      child: Text(text, style: TextStyle(color: Colors.white)),
    );
  }
}
