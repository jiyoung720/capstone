import 'package:flutter/material.dart';
import '../api/todo_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // ✅ Login 텍스트
          const Positioned(
            top: 266,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                "✅ Login",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                  height: 49 / 32,
                  color: Colors.black,
                  fontFamily: 'KoPubWorldDotum',
                ),
              ),
            ),
          ),

          // 이메일 입력 필드
          Positioned(
            top: 386,
            left: 30,
            right: 30,
            child: Container(
              width: 200,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFF4F4F4),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.centerLeft,
              child: TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: '이메일',
                  hintStyle: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF8C8C8C),
                    letterSpacing: 0.1,
                    fontFamily: 'KoPubWorldDotum',
                  ),
                ),
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),

          // 비밀번호 입력 필드
          Positioned(
            top: 444,
            left: 30,
            right: 30,
            child: Container(
              width: 200,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFF4F4F4),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.centerLeft,
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: '비밀번호',
                  hintStyle: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF8C8C8C),
                    letterSpacing: 0.1,
                    fontFamily: 'KoPubWorldDotum',
                  ),
                ),
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),

          // 로그인 버튼
          Positioned(
            top: 550,
            left: 30,
            right: 30,
            child: SizedBox(
              width: 200,
              height: 45.45,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF333333),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  final email = emailController.text.trim();
                  final password = passwordController.text.trim();

                  print('입력된 email: [$email]');
                  print('입력된 password: [$password]');

                  if (email.isEmpty || password.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('이메일과 비밀번호를 모두 입력해주세요.')),
                    );
                    return;
                  }

                  final token = await loginUser(email, password);

                  if (token != null) {
                    print('로그인 성공! JWT: $token');

                    // ✅ 필요 시 토큰 저장
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.setString('accessToken', token);

                    // ✅ 할 일 페이지로 이동
                    Navigator.pushReplacementNamed(context, '/todo');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('로그인에 실패했습니다.')),
                    );
                  }
                },
                child: const Text(
                  "로그인",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFECECEC),
                    letterSpacing: 0.1,
                    height: 28 / 18,
                    fontFamily: 'KoPubWorldDotum',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
