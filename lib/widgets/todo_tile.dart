import 'package:flutter/material.dart';
import '../models/todo.dart';

// ✅ 할 일 항목 UI 위젯
class TodoTile extends StatelessWidget {
  final Todo todo;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TodoTile({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: todo.isDone,
        onChanged: (_) => onToggle(),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        onSelected: (value) {
          if (value == 'edit') {
            onEdit();
          } else if (value == 'delete') {
            onDelete();
          }
        },
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'edit',
            child: Center(
              child: Text('수정', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
            ),
          ),
          const PopupMenuDivider(height: 1),
          const PopupMenuItem(
            value: 'delete',
            child: Center(
              child: Text('삭제', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
            ),
          ),
        ],
      ),
    );
  }
}