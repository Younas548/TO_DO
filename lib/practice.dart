class Task {
 final String title;
  final String id;
  bool isDone;
  DateTime? createdAt;
  Task({required this.id, required this.title, this.isDone=false, this.createdAt});
  factory Task.fromJson(Map<String,dynamic> json){
    return Task(
        id: json['id'].toString(),
        title:json['title'],
        isDone: json['isDone'] ?? false,
        createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }
  Map<String,dynamic> toJson(){
    return{
      'id': id,
      'title':title,
      'isDone': isDone,
      'createdAt': createdAt,
    };
  }
}