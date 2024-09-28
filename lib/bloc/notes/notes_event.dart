import 'package:equatable/equatable.dart';

import '../../models/note.dart';

abstract class NotesEvent extends Equatable {
  const NotesEvent();

  @override
  List<Object?> get props => [];
}

class GetNotesEvent extends NotesEvent {}

class GetCachedNotesEvent extends NotesEvent {}

class CreateNoteEvent extends NotesEvent {
  final Note? noteFormData;

  const CreateNoteEvent({required this.noteFormData});

  @override
  List<Object?> get props => [noteFormData];
}

class ChangeNotesCategoryEvent extends NotesEvent {
  final List<Note?> notesFormData;

  const ChangeNotesCategoryEvent({required this.notesFormData});

  @override
  List<Object?> get props => [notesFormData];
}

class UpdateNoteEvent extends NotesEvent {
  final int index;
  final Note? noteFormData;

  const UpdateNoteEvent({required this.index, required this.noteFormData});

  @override
  List<Object?> get props => [index, noteFormData];
}

class DeleteNoteEvent extends NotesEvent {
  final int index;

  const DeleteNoteEvent({required this.index});

  @override
  List<Object?> get props => [index];
}

class ChangeColorsEvent extends NotesEvent {}

class PinEvent extends NotesEvent {}
