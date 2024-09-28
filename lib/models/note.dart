import 'package:hive/hive.dart';

class Note extends HiveObject {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? body;
  @HiveField(2)
  String? category;

  Note({
    this.id,
    this.body,
    this.category,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      body: json['body'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "body": body ?? "",
      "category": category ?? "",
    };
  }

  forUpdate(Note? updateData) {
    return Note(
      body: updateData?.body ?? body,
      category: updateData?.category ?? category,
    );
  }
}
