class ToDo {
  int? id;
  String body;
  bool? isCompleted;

  ToDo({this.id, required this.body, this.isCompleted});

  factory ToDo.fromJson(Map<String, dynamic> json) {
    int id = json['id'];
    String body = json['body'];
    bool isCompleted = json['isCompleted'];
    return ToDo(id: id, body: body, isCompleted: isCompleted);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['body'] = body;
    data['completed'] = isCompleted;
    return data;
  }
}
