import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../bloc/notes/notes_bloc.dart';
import '../../bloc/notes/notes_event.dart';
import '../../bloc/notes/notes_state.dart';
import '../../provider/network_provider.dart';
import '../../provider/selected_note_provider.dart';
import '../../widgets/drawer_widget.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../widgets/top_snack_bar.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isOnline = false;
    ConnectivityProvider connectivityProvider =
        Provider.of<ConnectivityProvider>(context);
    isOnline = connectivityProvider.connectionType == 'Online';
    // final theme = Provider.of<ThemeProvider>(context).currentTheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        // int screenWidth = constraints.maxWidth.floor();
        // int screenHeight = constraints.maxHeight.floor();
        return buildDrawerWidget(
          context: context,
          appBarTitle: 'Note screen',
          body: RefreshIndicator(
            onRefresh: () async {
              print("REFRESH...");
              if (isOnline) {
                context.read<NotesBloc>().add(GetNotesEvent());
              } else {
                showTopSnackBar(
                  context: context,
                  message: "you aren't connected to internet!",
                  backgroundColor: Colors.red,
                  duration: const Duration(milliseconds: 3000),
                );
              }
              return await Future.delayed(const Duration(seconds: 1));
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 40),
              physics: const AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              child: BlocConsumer<NotesBloc, NotesState>(
                listener: (context, state) {
                  if (state is NotesStateLoading) {
                    print('LISTENER NotesStateLoading');
                    if (state.mustRebuild == true) {
                      print("LISTENER NotesStateLoading MUST REBUILD");
                      context.read<NotesBloc>().add(GetNotesEvent());
                    }
                  } else if (state is NotesStateSuccess) {
                    print('LISTENER NotesStateSuccess ${state.notesData}');
                    showTopSnackBar(
                      context: context,
                      message: "notesData success",
                      backgroundColor: Colors.green,
                      duration: const Duration(milliseconds: 2000),
                    );
                  } else if (state is NotesStateFailure) {
                    print(
                        'LISTENER NotesStateFailure ${state.notesFailureMessage}');
                    showTopSnackBar(
                      context: context,
                      message: state.notesFailureMessage,
                      backgroundColor: Colors.red,
                      duration: const Duration(milliseconds: 2000),
                    );
                  }
                },
                builder: (context, state) {
                  print('BUILDER NOTES >> $state');
                  if (state is NotesStateLoading) {
                    if (isOnline) {
                      print('BUILDER GetNotesEvent');
                      context.read<NotesBloc>().add(GetNotesEvent());
                    } else {
                      print('BUILDER GetCacheNotesEvent');
                      context.read<NotesBloc>().add(GetCachedNotesEvent());
                    }
                    return const CircularProgressIndicator();
                  } else if (state is NotesStateSuccess) {
                    return MasonryGridView.custom(
                      padding: const EdgeInsets.all(12),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      gridDelegate:
                          const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                      childrenDelegate: SliverChildBuilderDelegate(
                        childCount: state.notesData.length,
                        addAutomaticKeepAlives: false,
                        addRepaintBoundaries: true,
                        addSemanticIndexes: false,
                        (BuildContext context, int index) {
                          return BuildNote(
                            index: index,
                            body: state.notesData[index]!.body.toString(),
                            isSelected: context
                                .read<SelectedNoteProvider>()
                                .selectedIndexes
                                .contains(index),
                            onLongPress: context
                                .watch<SelectedNoteProvider>()
                                .toggleSelection,
                            selectedIndexes: context
                                .read<SelectedNoteProvider>()
                                .selectedIndexes,
                          );
                        },
                      ),
                    );
                  } else if (state is NotesStateFailure) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          state.notesFailureMessage,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const Text(
                      "Unexpected state",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class BuildNote extends StatelessWidget {
  final String body;
  final int index;
  final bool isSelected;
  final Function(int) onLongPress;
  final List<int> selectedIndexes;

  const BuildNote({
    super.key,
    required this.body,
    required this.index,
    required this.isSelected,
    required this.onLongPress,
    required this.selectedIndexes,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => onLongPress(index),
      onTap: () => selectedIndexes.isNotEmpty ? onLongPress(index) : null,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xff424a61),
          boxShadow: const [BoxShadow(color: Color(0xff362e47), blurRadius: 3)],
          border: Border.all(
            color: isSelected ? const Color(0xff6e45fe) : Colors.transparent,
            width: 2,
            strokeAlign: BorderSide.strokeAlignCenter,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                Text(body, style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
