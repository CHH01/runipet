import 'package:flutter/material.dart';
// 추가: reset 화면 import

class FindPasswordScreen extends StatelessWidget {
  const FindPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                Image.asset('assets/images/logo.png', width: 200, height: 100),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('아이디 찾기', style: TextStyle(color: Colors.grey)),
                    SizedBox(width: 30),
                    Text('비밀번호 찾기', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                  ],
                ),
                Divider(thickness: 1, color: Colors.grey),
                SizedBox(height: 20),
                _buildTextField('아이디'),
                SizedBox(height: 15),
                _buildTextField('등록된 이메일'),
                SizedBox(height: 20),
                _buildOrangeButton('인증코드 발송'),
                SizedBox(height: 15),
                _buildTextField('인증코드를 입력하세요'),
                SizedBox(height: 20),
                _buildOrangeButton('코드 확인'),
                SizedBox(height: 20),
                _buildGreyButton('비밀번호 설정', context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Color(0xFFF5F5F5),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildOrangeButton(String text) {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        onPressed: () {},
        child: Text(text),
      ),
    );
  }

  Widget _buildGreyButton(String text, BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/reset_password');
        },
        child: Text(text),
      ),
    );
  }
}
