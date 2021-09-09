class Task {
  Task({required this.id, this.task = "", required this.created_at});

  final DateTime created_at;
  final int id;
  final String task;

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'task': this.task,
      'created_at': this.created_at.toString()
    };
  }
}
