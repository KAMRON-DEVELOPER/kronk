import 'package:hive/hive.dart';

import '../models/note.dart';

class NoteAdapter extends TypeAdapter<Note> {
  @override
  final int typeId = 2;

  @override
  Note read(BinaryReader reader) {
    return Note(
      id: reader.readString(),
      body: reader.readString(),
      category: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, Note obj) {
    writer.writeString(obj.id ?? '');
    writer.writeString(obj.body ?? '');
    writer.writeString(obj.category ?? '');
  }
}
