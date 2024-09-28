import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/note.dart';
import '../../provider/data_repository.dart';
import '../../services/users_api.dart';
import '../../services/notes_api.dart';
import '../connectivity/connectivity_bloc.dart';
import '../connectivity/connectivity_state.dart';
import 'notes_event.dart';
import 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final ConnectivityBloc connectivityBloc;
  late StreamSubscription connectivitySubscription;

  late DataRepository dataRepository;
  late AuthApiService authApiService;
  late NoteApiService noteApiService;
  NotesBloc({required this.connectivityBloc})
      : super(const NotesStateLoading()) {
    on<GetNotesEvent>(_getNotesEvent);
    on<GetCachedNotesEvent>(_getCacheNotesEvent);
    on<ChangeNotesCategoryEvent>(
      (event, emit) =>
          _changeNotesCategoryEvent(event, emit, event.notesFormData),
    );
    on<CreateNoteEvent>(
      (event, emit) => _createNoteEvent(event, emit, event.noteFormData),
    );
    on<UpdateNoteEvent>(
      (event, emit) =>
          _updateNoteEvent(event, emit, event.index, event.noteFormData),
    );
    on<DeleteNoteEvent>(
      (event, emit) => _deleteNoteEvent(event, emit, event.index),
    );

    dataRepository = DataRepository();
    authApiService = AuthApiService();
    noteApiService = NoteApiService();

    listenToConnectivityBloc();
  }

  void listenToConnectivityBloc() {
    connectivitySubscription = connectivityBloc.stream.listen(
      (state) {
        if (state is ConnectivitySuccess) {
          add(GetNotesEvent());
        } else if (state is ConnectivityFailure) {
          add(GetCachedNotesEvent());
        }
      },
    );
  }

  void _getCacheNotesEvent(NotesEvent event, Emitter<NotesState> emit) async {
    try {
      List<Note?> notes = await dataRepository.getNotes();
      if (notes.isNotEmpty) {
        emit(NotesStateSuccess(notesData: notes));
      } else {
        emit(
          const NotesStateFailure(
            notesFailureMessage: "No cached notes available",
          ),
        );
      }
    } catch (e) {
      print("catch _getCacheNotesEvent >> $e");
      emit(
        const NotesStateFailure(
          notesFailureMessage: "something went wrong in _getCacheNotesEvent",
        ),
      );
    }
  }

  void _getNotesEvent(NotesEvent event, Emitter<NotesState> emit) async {
    try {
      bool isAuthenticated = await dataRepository.getIsAuthenticated();
      if (isAuthenticated) {
        String? access = await dataRepository.getAccessToken();
        List<Note?>? notes =
            await noteApiService.fetchNotes(accessToken: access);
        bool isNoteSavedLocale = await dataRepository.setNotes(notes!);
        if (isNoteSavedLocale) {
          emit(NotesStateSuccess(notesData: notes));
        } else {
          emit(
            const NotesStateFailure(
              notesFailureMessage: "Notes couldn't saved to locale",
            ),
          );
        }
      } else {
        emit(
          const NotesStateFailure(
            notesFailureMessage: "User is not authenticated",
          ),
        );
      }
    } catch (e) {
      print("catch _getNotesEvent >> $e");
      emit(
        const NotesStateFailure(
          notesFailureMessage: "something went wrong in _getNotesEvent",
        ),
      );
    }
  }

  void _changeNotesCategoryEvent(NotesEvent event, Emitter<NotesState> emit,
      List<Note?> notesFormData) async {
    try {
      emit(const NotesStateLoading(mustRebuild: true));
    } catch (e) {
      print("catch _changeNoteOrderEvent >> $e");
      emit(
        const NotesStateFailure(
          notesFailureMessage: "couldn't changed note order",
        ),
      );
    }
  }

  void _createNoteEvent(
      NotesEvent event, Emitter<NotesState> emit, Note? noteFormData) async {
    try {
      String? accessToken = await dataRepository.getAccessToken();
      Note? newNote = await noteApiService.fetchCreateNote(
        accessToken: accessToken,
        note: noteFormData,
      );
      if (newNote != null) {
        bool isNoteSavedLocale = await dataRepository.addNote(newNote);
        if (isNoteSavedLocale) {
          emit(const NotesStateLoading(mustRebuild: true));
        } else {
          emit(
            const NotesStateFailure(
              notesFailureMessage: "note couldn't save in locale",
            ),
          );
        }
      } else {
        emit(
          const NotesStateFailure(
            notesFailureMessage: "note couldn't created in server",
          ),
        );
      }
    } catch (e) {
      print("catch _createNoteEvent >> $e");
      emit(
        const NotesStateFailure(
          notesFailureMessage: "something went wrong in _createNoteEvent",
        ),
      );
    }
  }

  void _updateNoteEvent(NotesEvent event, Emitter<NotesState> emit, int index,
      Note? noteFormData) async {
    try {
      String? id = dataRepository.notesBox.getAt(index)?.id;
      String? accessToken = await dataRepository.getAccessToken();
      bool isUpdated = await noteApiService.fetchUpdateNote(
        accessToken: accessToken,
        id: id,
        note: noteFormData,
      );
      if (isUpdated) {
        bool isUpdatedLocal =
            await dataRepository.updateNotes(index, noteFormData);
        if (isUpdatedLocal) {
          emit(const NotesStateLoading(mustRebuild: true));
        } else {
          emit(const NotesStateFailure(
              notesFailureMessage: "note couldn't updated in locale"));
        }
      } else {
        emit(
          const NotesStateFailure(
            notesFailureMessage: "note couldn't updated in server",
          ),
        );
      }
    } catch (e) {
      print("catch _updateNoteEvent >> $e");
      emit(
        const NotesStateFailure(
          notesFailureMessage: "something went wrong in _updateNoteEvent",
        ),
      );
    }
  }

  void _deleteNoteEvent(
      NotesEvent event, Emitter<NotesState> emit, int index) async {
    try {
      Note? victimNote = dataRepository.notesBox.getAt(index);
      String? accessToken = await dataRepository.getAccessToken();
      bool isDeleted = await noteApiService.fetchDeleteNote(
          accessToken: accessToken, id: victimNote?.id);
      print('isDeleted _deleteNoteEvent >> $isDeleted');
      if (isDeleted) {
        bool isDeletedLocale = await dataRepository.deleteNotes(index);
        if (isDeletedLocale) {
          emit(const NotesStateLoading(mustRebuild: true));
        } else {
          emit(
            const NotesStateFailure(
              notesFailureMessage: "note couldn't deleted in locale",
            ),
          );
        }
      } else {
        emit(
          const NotesStateFailure(
            notesFailureMessage: "note couldn't deleted in server",
          ),
        );
      }
    } catch (e) {
      print("catch _deleteTabEvent >> $e");
      emit(
        const NotesStateFailure(
          notesFailureMessage: "something went wrong in _deleteTabEvent",
        ),
      );
    }
  }
}
