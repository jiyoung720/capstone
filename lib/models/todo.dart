class Todo {
  int? id;
  String text;
  bool isDone;

  Todo({this.id, required this.text, this.isDone = false});

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      text: json['contents'], // 백엔드 필드명과 맞춰야 함
      isDone: json['isCheck'] ?? false,
    );
  }
}