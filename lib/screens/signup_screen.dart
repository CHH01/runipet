import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  final _nameController = TextEditingController();
  final _birthController = TextEditingController();
  final _emailController = TextEditingController();
  final _verificationCodeController = TextEditingController();
  final _apiService = ApiService(
    baseUrl: 'http://10.0.2.2:5000',
    secureStorage: const FlutterSecureStorage()
  );
  
  bool _isUsernameAvailable = false;
  bool _isEmailVerified = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    _nameController.dispose();
    _birthController.dispose();
    _emailController.dispose();
    _verificationCodeController.dispose();
    super.dispose();
  }

  Future<void> _checkUsername() async {
    if (_usernameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('아이디를 입력해주세요.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _apiService.post('/auth/check-username', {
        'username': _usernameController.text,
      });

      setState(() {
        _isUsernameAvailable = response['available'] ?? false;
        _isLoading = false;
      });

      if (_isUsernameAvailable) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('사용 가능한 아이디입니다.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('이미 사용 중인 아이디입니다.')),
        );
      }
    } catch (e) {
      setState(() {
        _isUsernameAvailable = false;
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
      );
    }
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
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('인증 코드가 이메일로 전송되었습니다.')),
      );
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('인증 코드 전송에 실패했습니다.')),
      );
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('이메일 인증이 완료되었습니다.')),
      );
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('인증 코드가 올바르지 않습니다.')),
      );
    }
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_isUsernameAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('아이디 중복 확인이 필요합니다.')),
      );
      return;
    }
    if (!_isEmailVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('이메일 인증이 필요합니다.')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _apiService.register(
        _usernameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text,
        _nameController.text.trim(),
      );
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
      );
    }
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
                      Expanded(
                        child: TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            hintText: '아이디',
                            filled: true,
                            fillColor: Color(0xFFF5F5F5),
                            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '아이디를 입력해주세요.';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      _buildSmallButton('중복확인', _checkUsername),
                    ],
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: '비밀번호',
                      filled: true,
                      fillColor: Color(0xFFF5F5F5),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '비밀번호를 입력해주세요.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: _passwordConfirmController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: '비밀번호 재입력',
                      filled: true,
                      fillColor: Color(0xFFF5F5F5),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '비밀번호를 다시 입력해주세요.';
                      }
                      if (value != _passwordController.text) {
                        return '비밀번호가 일치하지 않습니다.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: '이름',
                      filled: true,
                      fillColor: Color(0xFFF5F5F5),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '이름을 입력해주세요.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: _birthController,
                    decoration: InputDecoration(
                      hintText: '생년월일',
                      filled: true,
                      fillColor: Color(0xFFF5F5F5),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '생년월일을 입력해주세요.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: '이메일',
                            filled: true,
                            fillColor: Color(0xFFF5F5F5),
                            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '이메일을 입력해주세요.';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      _buildSmallButton('인증코드 발송', _sendVerificationCode),
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _verificationCodeController,
                          decoration: InputDecoration(
                            hintText: '인증코드 입력',
                            filled: true,
                            fillColor: Color(0xFFF5F5F5),
                            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '인증코드를 입력해주세요.';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      _buildSmallButton('코드확인', _verifyCode),
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
                      onPressed: _isLoading ? null : _signUp,
                      child: _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
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

  Widget _buildSmallButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      onPressed: _isLoading ? null : onPressed,
      child: Text(text, style: TextStyle(color: Colors.white)),
    );
  }
}
