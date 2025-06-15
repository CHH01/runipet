import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FindPasswordScreen extends StatefulWidget {
  const FindPasswordScreen({super.key});

  @override
  State<FindPasswordScreen> createState() => _FindPasswordScreenState();
}

class _FindPasswordScreenState extends State<FindPasswordScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _verificationCodeController = TextEditingController();
  final _apiService = ApiService(
    baseUrl: 'http://10.0.2.2:5000',
    secureStorage: const FlutterSecureStorage()
  );
  bool _isLoading = false;
  bool _isEmailVerified = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _verificationCodeController.dispose();
    super.dispose();
  }

  Future<void> _sendVerificationCode() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('이메일을 입력해주세요.')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _apiService.post('/auth/verify-email/send', {'email': email});
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('인증 코드가 이메일로 전송되었습니다.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('인증 코드 전송에 실패했습니다.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _verifyCode() async {
    final email = _emailController.text.trim();
    final code = _verificationCodeController.text.trim();
    
    if (email.isEmpty || code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('이메일과 인증 코드를 모두 입력해주세요.')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _apiService.post('/auth/verify-email/confirm', {
        'email': email,
        'code': code
      });
      setState(() {
        _isEmailVerified = true;
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('이메일 인증이 완료되었습니다.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('인증 코드가 올바르지 않습니다.')),
        );
      }
      setState(() => _isLoading = false);
    }
  }

  void _goToResetPassword() {
    if (!_isEmailVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('이메일 인증이 필요합니다.')),
      );
      return;
    }

    Navigator.pushNamed(
      context,
      '/reset_password',
      arguments: {
        'username': _usernameController.text.trim(),
        'email': _emailController.text.trim(),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
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
                    GestureDetector(
                      onTap: () => Navigator.pushReplacementNamed(context, '/find_id'),
                      child: Text('아이디 찾기', style: TextStyle(color: Colors.grey)),
                    ),
                    SizedBox(width: 30),
                    Text('비밀번호 찾기', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                  ],
                ),
                Divider(thickness: 1, color: Colors.grey),
                SizedBox(height: 20),
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    hintText: '아이디',
                    filled: true,
                    fillColor: Color(0xFFF5F5F5),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: '등록된 이메일',
                          filled: true,
                          fillColor: Color(0xFFF5F5F5),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      onPressed: _isLoading ? null : _sendVerificationCode,
                      child: Text('인증코드 발송', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _verificationCodeController,
                        decoration: InputDecoration(
                          hintText: '인증코드를 입력하세요',
                          filled: true,
                          fillColor: Color(0xFFF5F5F5),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      onPressed: _isLoading ? null : _verifyCode,
                      child: Text('코드 확인', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    onPressed: _isLoading ? null : _goToResetPassword,
                    child: Text('비밀번호 재설정'),
                  ),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('로그인 화면으로 돌아가기'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
