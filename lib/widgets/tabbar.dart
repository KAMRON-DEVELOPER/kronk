import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../bloc/connectivity/connectivity_bloc.dart';
import '../bloc/tabs/tabs_bloc.dart';
import '../bloc/tabs/tabs_event.dart';
import '../bloc/tabs/tabs_state.dart';
import '../models/tab.dart';
import '../provider/theme_provider.dart';

class CustomTabBar extends StatefulWidget {
  const CustomTabBar({super.key});

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (context) => TabsBloc(
        connectivityBloc: context.read<ConnectivityBloc>(),
      ),
      child: BlocConsumer<TabsBloc, TabsState>(
        listener: (context, state) {
          if (state is TabsStateLoading) {
            print("LISTENER STATE ** TabsStateLoading");
          } else if (state is TabsStateSuccess) {
            print("LISTENER STATE ** TabsStateSuccess ${state.tabs}");
          } else if (state is TabsStateFailure) {
            print(
                "LISTENER STATE ** TabsStateFailure ${state.tabsFailureMessage}");
          }
        },
        builder: (context, state) {
          if (state is TabsStateSuccess) {
            print("tabs in success >> ${state.tabs}");
            return Container(
              height: screenHeight/25,
              decoration: BoxDecoration(
                color: theme.background1,
                border: const Border(
                  top: BorderSide(color: Colors.green, width: 0.1),
                ),
              ),
              child: ReorderableListView.builder(
                header: const Row(
                  children: [Text("Header")],
                ),
                footer: const Row(
                  children: [Text("Footer")],
                ),
                scrollDirection: Axis.horizontal,
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) {
                      newIndex--;
                    }

                    List<MyTab?> tabs = state.tabs;
                    MyTab? item = tabs.removeAt(oldIndex);
                    tabs.insert(newIndex, item);
                  });

                  context.read<TabsBloc>().add(
                        ChangeTabOrderEvent(
                          oldIndex: oldIndex,
                          newIndex: newIndex,
                        ),
                      );
                },
                itemCount: state.tabs.length,
                itemBuilder: (context, index) => GestureDetector(
                  key: ValueKey(index),
                  onTap: () => Navigator.pushNamed(
                      context, "/home/${state.tabs[index]!.name}"),
                  // onLongPress: () {
                  //   context
                  //       .read<TabsBloc>()
                  //       .add(TabMenuOpenEvent(index: index));
                  // },
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.fromLTRB(16, 2, 16, 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color:
                          index != 0 ? theme.background3 : theme.activeTabColor,
                    ),
                    child: Text(
                      "${state.tabs[index]!.name}",
                      style: TextStyle(
                        color: theme.text1,
                      ),
                    ),
                  ),
                ),
              ),
            );
          } else if (state is TabsStateLoading) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'skeleton...',
                  style: TextStyle(color: Colors.white, fontSize: screenWidth/14),
                ),
              ],
            );
          } else if (state is TabsStateFailure) {
            List<MyTab?> tabs = [
              MyTab.fromJson({"id": null, "name": "profile"}),
              MyTab.fromJson({"id": null, "name": "notes"}),
              MyTab.fromJson({"id": null, "name": "   +   "}),
            ];
            print("tabs in failure >> $tabs");
            return Container(
              height: screenHeight/25,
              decoration: BoxDecoration(
                color: theme.background1,
                border: const Border(
                  top: BorderSide(color: Colors.green, width: 0.1),
                ),
              ),
              child: ReorderableListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(4),
                itemCount: tabs.length,
                onReorder: (oldIndex, newIndex) {
                  context.read<TabsBloc>().add(
                        ChangeTabOrderEvent(
                            oldIndex: oldIndex, newIndex: newIndex),
                      );
                },
                itemBuilder: (context, index) => Draggable<GestureDetector>(
                  key: ValueKey(index),
                  data: GestureDetector(
                    key: ValueKey(index),
                    onTap: () => Navigator.pushNamed(
                        context, "/home/${tabs[index]!.name}"),
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.fromLTRB(16, 2, 16, 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: index != 0 ? Colors.redAccent : Colors.red,
                      ),
                      child: Text(
                        "${tabs[index]!.name}",
                        style: TextStyle(
                          color: theme.text1,
                        ),
                      ),
                    ),
                  ),
                  feedback: GestureDetector(
                    key: ValueKey(index),
                    onTap: () => Navigator.pushNamed(
                        context, "/home/${tabs[index]!.name}"),
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.fromLTRB(16, 2, 16, 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color:
                            index != 0 ? Colors.orangeAccent : Colors.orange,
                      ),
                      child: Text(
                        "${tabs[index]!.name}",
                        style: TextStyle(
                          color: theme.text1,
                        ),
                      ),
                    ),
                  ),
                  child: GestureDetector(
                    key: ValueKey(index),
                    onTap: () => Navigator.pushNamed(
                        context, "/home/${tabs[index]!.name}"),
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.fromLTRB(16, 2, 16, 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: index != 0
                            ? theme.background3
                            : theme.activeTabColor,
                      ),
                      child: Text(
                        "${tabs[index]!.name}",
                        style: TextStyle(
                          color: theme.text1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          } else {
            return const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "unexpected state",
                  style: TextStyle(color: Colors.white, fontSize: 28),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
