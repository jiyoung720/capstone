import 'package:flutter/material.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // ✅ Todo List 텍스트
          const Positioned(
            top: 300,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                "✅ Todo List",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                  color: Colors.black,
                  height: 49 / 32, // line-height 대응
                  fontFamily: 'KoPubWorldDotum', // pubspec.yaml에 폰트 추가 시 적용 가능
                ),
              ),
            ),
          ),

          // 로그인 버튼
          Positioned(
            top: 469,
            left: 70,
            right: 70,
            child: SizedBox(
              height: 45,
              width: 250,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF333333),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => Navigator.pushNamed(context, '/login'),
                child: const Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.1,
                    height: 28 / 18,
                    color: Color(0xFFECECEC),
                    fontFamily: 'KoPubWorldDotum',
                  ),
                ),
              ),
            ),
          ),

          // 회원가입 버튼
          Positioned(
            top: 528,
            left: 70,
            right: 70,
            child: SizedBox(
              height: 45,
              width: 250,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Color(0xFFECECEC),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  side: BorderSide.none,
                ),
                onPressed: () => Navigator.pushNamed(context, '/register'),
                child: const Text(
                  "Register",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.1,
                    height: 28 / 18,
                    color: Color(0xFF262626),
                    fontFamily: 'KoPubWorldDotum',
                  ),
                ),
              ),
            ),
          ),

          // Forgot Password 텍스트 버튼
          Positioned(
            top: 586,
            left: 0,
            right: 0,
            child: Center(
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size(100, 18),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () => Navigator.pushNamed(context, '/reset'),
                child: const Text(
                  "Forgot Password",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.1,
                    height: 17 / 11,
                    decoration: TextDecoration.underline,
                    color: Color(0xFF262626),
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
