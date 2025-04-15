import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/todo.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// 실제 기기에서는 'http://192.168.x.x:8080' 로 변경 필요
const String baseUrl = 'http://192.168.0.7:8080';

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

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  DateTime selectedDate = DateTime.now();
  final TextEditingController _controller = TextEditingController();

  // ✅ 날짜별로 할 일을 저장하는 구조
  Map<String, List<Todo>> _todosByDate = {};

  // ✅ 현재 선택된 날짜에 해당하는 할 일 리스트만 반환
  List<Todo> get _todosForSelectedDate {
    final key = DateFormat('yyyy-MM-dd').format(selectedDate);
    return _todosByDate[key] ?? [];
  }

  @override
  void initState() {
    super.initState();
    _loadTodosForSelectedDate(); // 앱 시작 시 오늘 날짜 데이터 불러오기
  }

  void _loadTodosForSelectedDate() async {
    final key = DateFormat('yyyy-MM-dd').format(selectedDate);

    try {
      final todos = await fetchTodosByDate(key);

      // ✅ 정렬 추가!
      todos.sort((a, b) {
        if (a.isDone == b.isDone) return 0;
        return a.isDone ? 1 : -1;
      });

      setState(() {
        _todosByDate[key] = todos;
      });
    } catch (e) {
      print('❌ 조회 실패: $e');
    }
  }

  // ✅ 현재 날짜에 할 일 추가
  void _addTodo() async {
    final text = _controller.text.trim();
    final dateStr = DateFormat('yyyy-MM-dd').format(selectedDate);

    if (text.isNotEmpty) {
      bool success = await postTodo(text, dateStr);

      if (success) {
        _controller.clear();

        try {
          final todos = await fetchTodosByDate(dateStr);

          // ✅ 정렬 추가!
          todos.sort((a, b) {
            if (a.isDone == b.isDone) return 0;
            return a.isDone ? 1 : -1; // 체크된 항목은 아래로
          });

          setState(() {
            _todosByDate[dateStr] = todos;
          });
        } catch (e) {
          print("❌ 목록 재조회 실패: $e");
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('서버에 할 일 저장 실패')),
        );
      }
    }
  }

  // ✅ 체크 완료 시 해당 날짜 리스트에서 토글
  void _toggleTodo(int index) async {
    final key = DateFormat('yyyy-MM-dd').format(selectedDate);
    final todo = _todosForSelectedDate[index];

    if (todo.id == null) {
      print("❌ id가 없어서 체크 업데이트 불가");
      return;
    }

    final success = await updateCheckBox(todo.id!, !todo.isDone); // ✅ 서버 요청

    if (success) {
      setState(() {
        todo.isDone = !todo.isDone;
        _sortTodos(key);
      });
    } else {
      print("❌ 체크 상태 업데이트 실패");
    }
  }

  // ✅ 해당 날짜 리스트만 정렬
  void _sortTodos(String key) {
    final todos = _todosByDate[key];
    if (todos == null) return;
    todos.sort((a, b) {
      if (a.isDone == b.isDone) return 0;
      return a.isDone ? 1 : -1;
    });
  }

  void _changeDate(int offset) async {
    setState(() {
      selectedDate = selectedDate.add(Duration(days: offset));
    });

    final key = DateFormat('yyyy-MM-dd').format(selectedDate);

    try {
      final todos = await fetchTodosByDate(key);
      setState(() {
        _todosByDate[key] = todos;
      });
    } catch (e) {
      print('❌ 날짜 변경 시 조회 실패: $e');
    }
  }

  // ✅ 삭제 기능
  void _deleteTodo(int index) async {
    final key = DateFormat('yyyy-MM-dd').format(selectedDate);
    final todo = _todosForSelectedDate[index];

    if (todo.id == null) {
      print("❌ id가 없어서 삭제 불가");
      return;
    }

    final success = await deleteTodoById(todo.id!); // ✅ API 호출

    if (success) {
      setState(() {
        _todosForSelectedDate.removeAt(index); // UI에서 제거
      });
    } else {
      print("❌ 삭제 실패");
    }
  }

  // ✅ 수정 기능
  void _editTodo(int index) {
    final key = DateFormat('yyyy-MM-dd').format(selectedDate);
    final currentTodo = _todosForSelectedDate[index];
    final TextEditingController editController = TextEditingController(text: currentTodo.text);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: const Text(
            '할 일 수정',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Color(0xFF262626)),
          ),
          content: TextField(
            controller: editController,
            decoration: const InputDecoration(hintText: '수정할 내용을 입력하세요'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('취소', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF262626))),
            ),
            TextButton(
              onPressed: () async {
                final newText = editController.text.trim();
                final dateStr = DateFormat('yyyy-MM-dd').format(selectedDate);

                if (currentTodo.id != null && newText.isNotEmpty) {
                  final success = await updateTodo(currentTodo.id!, newText, dateStr); // ✅ API 호출

                  if (success) {
                    setState(() {
                      currentTodo.text = newText;
                    });
                    Navigator.of(context).pop();
                  } else {
                    print('❌ 수정 실패');
                  }
                }
              },
              child: const Text('저장', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF262626))),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('yyyy년 M월 d일').format(selectedDate);
    final remaining = _todosForSelectedDate.where((todo) => !todo.isDone).length;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ✅ 날짜 선택 헤더
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () => _changeDate(-1),
                  ),
                  Text(
                    formattedDate,
                    style: const TextStyle(
                      fontSize: 20, 
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF262626),
                      
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios),
                    onPressed: () => _changeDate(1),
                  ),
                ],
              ),
            ),

            // ✅ 입력 필드
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: '할 일을 입력해주세요.',
                  hintStyle: const TextStyle(
                    fontWeight: FontWeight.w400, // ⬅️ 텍스트 굵기
                    fontSize: 15, // ⬅️ 텍스트 크기
                    color: Color(0xFF737373),  // ⬅️ 텍스트 색상
                  ),

                  // 기본(비활성) border
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8), // ⬅️ 둥근 모서리
                    borderSide: const BorderSide(
                      color: Color(0xFF595959),
                      width: 1.0, // ⬅️ 선 굵기
                    ),
                  ),

                  // 포커스됐을 때 border
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),  // ⬅️ 둥근 모서리 유지
                    borderSide: const BorderSide(
                      color: Color(0xFF595959),
                      width: 1.5, // ⬅️ 선 굵기
                    ),
                  ),

                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14), // 텍스트 패딩 조절

                ),
              ),
            ),

            // ✅ 추가 버튼
            ElevatedButton(
              onPressed: _addTodo,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFECECEC), // 버튼 배경색
                foregroundColor: Color(0xFF595959), // 글자 색
                padding: const EdgeInsets.symmetric(horizontal: 132, vertical: 14), // 버튼 패딩
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('할 일 추가'),
            ),
            const SizedBox(height: 8),
            // ✅ 남은 일 개수 표시
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Text('남은 일 : $remaining개'),
              ),
            ),

            const SizedBox(height: 8),

            // ✅ 할 일 목록
            Expanded(
              child: ListView.builder(
                itemCount: _todosForSelectedDate.length,
                itemBuilder: (context, index) {
                  final todo = _todosForSelectedDate[index];
                  return ListTile(
                    leading: Checkbox(
                      value: todo.isDone,
                      onChanged: (_) => _toggleTodo(index),
                      activeColor: Color(0xFF2AB514),
                    ),
                    title: Text(
                      todo.text,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF262626),
                        decoration: todo.isDone ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    trailing: PopupMenuButton<String>(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // ✅ 둥근 정도
                      ),
                      onSelected: (value) {
                        if (value == 'edit') {
                          _editTodo(index); // ✅ 수정 기능
                        } else if (value == 'delete') {
                          _deleteTodo(index); // ✅ 삭제 기능
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Center(
                            child: Text(
                              '수정',
                              style: TextStyle(
                                color: Color(0xFF262626), // ✅ 글자 색
                                fontSize: 14,             // ✅ 글씨 크기
                                fontWeight: FontWeight.w400, // ✅ 굵기
                              ),
                            ),
                          ),
                        ),
                        // ✅ 구분선
                        const PopupMenuDivider(
                          height: 1,
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Center(
                            child: Text(
                              '삭제',
                              style: TextStyle(
                                color: Color(0xFF262626),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
