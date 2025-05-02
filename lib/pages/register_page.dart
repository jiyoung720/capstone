import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 배경
          Container(color: Colors.white),

          // 제목
          const Positioned(
            top: 87,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                '📝 Register',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                  color: Colors.black,
                ),
              ),
            ),
          ),

          // 회색 배경 박스
          Positioned(
            top: 163,
            left: 0,
            right: 0,
            child: Container(
              height: 680,
              decoration: const BoxDecoration(
                color: Color(0xFFF4F4F4),
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              ),
            ),
          ),

          // 입력 폼들
          Positioned(
            top: 190,
            left: 32,
            right: 32,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildLabel('이름'),
                buildInput(nameController),
                const SizedBox(height: 12),
                buildLabel('이메일'),
                buildInput(emailController),
                const SizedBox(height: 12),
                buildLabel('비밀번호'),
                buildInput(passwordController, obscure: true),
                const SizedBox(height: 12),
                buildLabel('비밀번호 재입력'),
                buildInput(confirmPasswordController, obscure: true),
              ],
            ),
          ),

          // 회원가입 버튼
          Positioned(
            top: 626,
            left: 32,
            right: 32,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF333333),
                minimumSize: Size(double.infinity, 54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                // TODO: 회원가입 처리 로직
              },
              child: const Text(
                '회원 가입',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.8,
                  color: Color(0xFFECECEC),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 레이블
  Widget buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.5,
          color: Color(0xFF262626),
        ),
      ),
    );
  }

  // 입력 필드
  Widget buildInput(TextEditingController controller, {bool obscure = false}) {
    return Container(
      height: 43,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.centerLeft,
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
        style: TextStyle(fontSize: 15),
      ),
    );
  }
}
