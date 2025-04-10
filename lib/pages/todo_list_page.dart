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

  // ✅ 날짜별로 할 일을 저장하는 구조
  Map<String, List<Todo>> _todosByDate = {};

  // ✅ 현재 선택된 날짜에 해당하는 할 일 리스트만 반환
  List<Todo> get _todosForSelectedDate {
    final key = DateFormat('yyyy-MM-dd').format(selectedDate);
    return _todosByDate[key] ?? [];
  }

  // ✅ 현재 날짜에 할 일 추가
  void _addTodo() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      final key = DateFormat('yyyy-MM-dd').format(selectedDate);
      setState(() {
        _todosByDate[key] = [..._todosForSelectedDate, Todo(text: text)];
        _sortTodos(key);
        _controller.clear();
      });
    }
  }
  // ✅ 체크 완료 시 해당 날짜 리스트에서 토글
  void _toggleTodo(int index) {
    final key = DateFormat('yyyy-MM-dd').format(selectedDate);
    setState(() {
      _todosForSelectedDate[index].isDone = !_todosForSelectedDate[index].isDone;
      _sortTodos(key);
    });
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

  void _changeDate(int offset) {
    setState(() {
      selectedDate = selectedDate.add(Duration(days: offset));
    });
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
