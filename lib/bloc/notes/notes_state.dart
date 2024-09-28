import 'package:equatable/equatable.dart';

import '../../models/note.dart';

abstract class NotesState extends Equatable {
  const NotesState();
  @override
  List<Object?> get props => [];
}

class NotesStateLoading extends NotesState {
  final bool? mustRebuild;
  const NotesStateLoading({this.mustRebuild});

  @override
  List<Object?> get props => [mustRebuild];
}

class NotesStateSuccess extends NotesState {
  final List<Note?> notesData;
  const NotesStateSuccess({required this.notesData});

  @override
  List<Object?> get props => [notesData];
}

class NotesStateFailure extends NotesState {
  final String notesFailureMessage;
  const NotesStateFailure({required this.notesFailureMessage});

  @override
  List<Object?> get props => [notesFailureMessage];
}
