import 'dart:convert';
import '../models/todo.dart';
import 'package:http/http.dart' as http;

// 실제 기기에서는 'http://192.168.x.x:8080' 로 변경 필요
const String baseUrl = 'http://192.168.0.7:8080';
// const String baseUrl = 'http://10.31.0.198:8080';

// ✅ 회원가입 API
Future<bool> registerUser(String name, String email, String password) async {
  final url = Uri.parse('$baseUrl/main/signup');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'name': name,
      'email': email,
      'password': password,
    }),
  );
  return response.statusCode == 200;
}

// ✅ 로그인 API
Future<String?> loginUser(String email, String password) async {
  final url = Uri.parse('$baseUrl/main/login');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'email': email,
      'password': password,
    }),
  );
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['accessToken']; // JWT 토큰 반환
  }
  return null;
}

// ✅ 비밀번호 재설정 API
Future<bool> resetUserPassword(String email, String newPassword) async {
  final url = Uri.parse('$baseUrl/main/reset-password');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'email': email,
      'newPassword': newPassword,
    }),
  );
  return response.statusCode == 200;
}

// ✅ 서버에 할 일 추가 요청 함수
Future<bool> postTodo(String contents, String date) async {
  final url = Uri.parse('$baseUrl/todolist');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json; charset=utf-8'},
    body: utf8.encode(jsonEncode({
      'contents': contents,
      'isCheck': false,
      'doDate': date,
    })),
  );

  return response.statusCode == 200 || response.statusCode == 201;
}

// ✅ API - 날짜별 할 일 조회
Future<List<Todo>> fetchTodosByDate(String date) async {
  final url = Uri.parse('$baseUrl/todolist/date/$date');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final String decoded = utf8.decode(response.bodyBytes);
    final List jsonList = jsonDecode(decoded);
    return jsonList.map((json) => Todo.fromJson(json)).toList();
  } else {
    throw Exception('불러오기 실패: ${response.body}');
  }
}

// ✅ 체크박스 상태 업데이트 API
Future<bool> updateCheckBox(int id, bool isChecked) async {
  final url = Uri.parse('$baseUrl/todolist/checkBox');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'id': id,
      'isCheck': isChecked,
    }),
  );
  return response.statusCode == 200;
}

// ✅ 삭제 API 호출 함수
Future<bool> deleteTodoById(int id) async {
  final url = Uri.parse('$baseUrl/todolist/$id');
  final response = await http.delete(url);

  return response.statusCode == 200 || response.statusCode == 204;
}

// ✅ 수정 API
Future<bool> updateTodo(int id, String contents, String date) async {
  final url = Uri.parse('$baseUrl/todolist/update');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'id': id,
      'contents': contents,
      'date': date, // yyyy-MM-dd
    }),
  );

  return response.statusCode == 200;
}