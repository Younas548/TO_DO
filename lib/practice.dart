class Task {
  final String id;
  final String title;
  bool isDone;
  DateTime? createdAt;

  Task({
    required this.id,
    required this.title,
    this.isDone = false,
    this.createdAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'].toString(),
      title: json['title'],
      // API 'completed' bhejti hai; agar kabhi local-saved JSON 'isDone' bhi
      // ho, wo bhi chal jaye — dono handle kar liye
      isDone: json['completed'] ?? json['isDone'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isDone': isDone,
      // DateTime seedha JSON mein nahi ja sakta, isliye ISO string banayi
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}