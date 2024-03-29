class Task{
  int? id;
  late String title;
  String? description;
  int isFinish = 0;

  Task({this.id, required this.title, this.description, required this.isFinish});

  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    isFinish = json['isFinish'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['isFinish'] = isFinish;
    return data;
  }

}