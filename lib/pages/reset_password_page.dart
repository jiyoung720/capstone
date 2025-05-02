import 'package:flutter/material.dart';

class ResetPasswordPage extends StatelessWidget {
  final emailController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(color: Colors.white),

          // 제목
          const Positioned(
            top: 87,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                '👀 Reset Password',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
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

          // 입력 폼
          Positioned(
            top: 190,
            left: 32,
            right: 32,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildLabel('이메일'),
                buildInput(emailController),
                const SizedBox(height: 12),
                buildLabel('새 비밀번호'),
                buildInput(newPasswordController, obscure: true),
                const SizedBox(height: 12),
                buildLabel('비밀번호 재입력'),
                buildInput(confirmPasswordController, obscure: true),
              ],
            ),
          ),

          // 로그인 하기 버튼
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
                // TODO: 비밀번호 재설정 처리 로직
              },
              child: const Text(
                '로그인 하기',
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
