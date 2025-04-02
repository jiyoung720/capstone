import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/todo.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  DateTime selectedDate = DateTime.now();
  final TextEditingController _controller = TextEditingController();

  List<Todo> _todos = [];

  void _addTodo() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _todos.add(Todo(text: text));
        _controller.clear();
      });
    }
  }

  void _toggleTodo(int index) {
    setState(() {
      _todos[index].isDone = !_todos[index].isDone;
    });
  }

  void _changeDate(int offset) {
    setState(() {
      selectedDate = selectedDate.add(Duration(days: offset));
    });
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('yyyy년 M월 d일').format(selectedDate);
    final remaining = _todos.where((todo) => !todo.isDone).length;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ✅ 날짜 선택 헤더
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
            Text('남은 일 : $remaining개'),

            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: _todos.length,
                itemBuilder: (context, index) {
                  final todo = _todos[index];
                  return ListTile(
                    leading: Checkbox(
                      value: todo.isDone,
                      onChanged: (_) => _toggleTodo(index),
                    ),
                    title: Text(
                      todo.text,
                      style: TextStyle(
                        decoration: todo.isDone ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    trailing: const Icon(Icons.more_vert),
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
