import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/tab.dart';
import '../../provider/data_repository.dart';
import '../../services/users_api.dart';
import '../../services/notes_api.dart';
import '../connectivity/connectivity_bloc.dart';
import '../connectivity/connectivity_state.dart';
import 'tabs_event.dart';
import 'tabs_state.dart';

class TabsBloc extends Bloc<TabsEvent, TabsState> {
  final ConnectivityBloc connectivityBloc;
  late StreamSubscription connectivitySubscription;

  late DataRepository dataRepository;
  late AuthApiService authApiService;
  late NoteApiService noteApiService;
  TabsBloc({required this.connectivityBloc}) : super(const TabsStateLoading()) {
    on<GetTabsEvent>(_getTabsEvent);
    on<GetCashedTabsEvent>(_getCachedTabs);
    on<ChangeTabOrderEvent>((event, emit) =>
        _changeTabOrderEvent(event, emit, event.oldIndex, event.newIndex));
    on<CreateTabEvent>(
        (event, emit) => _createTabEvent(event, emit, event.newTabFormData));
    on<UpdateTabEvent>((event, emit) =>
        _updateTabEvent(event, emit, event.index, event.tabFormData));
    on<DeleteTabEvent>(
        (event, emit) => _deleteTabEvent(event, emit, event.index));
    on<TabMenuOpenEvent>(
        (event, emit) => _tabMenuOpenEvent(event, emit, event.index));
    dataRepository = DataRepository();
    authApiService = AuthApiService();
    noteApiService = NoteApiService();

    listenToConnectivityBloc();
  }

  void listenToConnectivityBloc() {
    connectivitySubscription = connectivityBloc.stream.listen(
      (state) {
        if (state is ConnectivitySuccess) {
          add(GetTabsEvent());
        } else if (state is ConnectivityFailure) {
          add(GetCashedTabsEvent());
        }
      },
    );
  }

  void _getCachedTabs(TabsEvent event, Emitter<TabsState> emit) async {
    try {
      List<MyTab?> tabs = await dataRepository.getTabs();
      if (tabs.isNotEmpty) {
        emit(TabsStateSuccess(tabs: tabs));
      } else {
        emit(
          const TabsStateFailure(
            tabsFailureMessage: "No cached tabs available",
          ),
        );
      }
    } catch (e) {
      print("catch _getCachedTabs >> $e");
      emit(
        const TabsStateFailure(
          tabsFailureMessage: "something went wrong in _getCachedTabs",
        ),
      );
    }
  }

  void _getTabsEvent(TabsEvent event, Emitter<TabsState> emit) async {
    try {
      bool isAuthenticated = await dataRepository.getIsAuthenticated();
      if (isAuthenticated) {
        String? access = await dataRepository.getAccessToken();
        List<MyTab?>? tabs =
            await noteApiService.fetchTabs(accessToken: access);
        if (tabs != null) {
          tabs.insert(0, MyTab.fromJson({"id": "", "name": "profile"}));
          tabs.insert(1, MyTab.fromJson({"id": "", "name": "notes"}));
          tabs.add(MyTab.fromJson({"id": "", "name": "  +  "}));
          print("tabs >> $tabs");
          bool isTabsSavedLocale = await dataRepository.setTabs(tabs);
          if (isTabsSavedLocale) {
            print("tabs are saved");
            emit(TabsStateSuccess(tabs: tabs));
          } else {
            emit(
              const TabsStateFailure(
                tabsFailureMessage: "tabs couldn't saved locale",
              ),
            );
          }
        }
      } else {
        emit(
          const TabsStateFailure(
            tabsFailureMessage: "User not authenticated",
          ),
        );
      }
    } catch (e) {
      print("catch _fetchTabs >> $e");
      emit(
        const TabsStateFailure(
          tabsFailureMessage: "something went wrong in _fetchTabs",
        ),
      );
    }
  }

  void _changeTabOrderEvent(TabsEvent event, Emitter<TabsState> emit,
      int oldIndex, int newIndex) async {
    try {
      if (oldIndex < newIndex) {
        newIndex--;
      }
      List<MyTab?> unOrderedTabs = await dataRepository.getTabs();
      final tab = unOrderedTabs.removeAt(oldIndex);
      unOrderedTabs.insert(newIndex, tab);

      await dataRepository.clearTabs();
      bool isTabsSavedLocale = await dataRepository.setTabs(unOrderedTabs);

      if (isTabsSavedLocale) {
        emit(TabsStateSuccess(tabs: unOrderedTabs));
      } else {
        print("unOrderedTabs not saved?");
      }
    } catch (e) {
      print("catch _changeOrderEvent >> $e");
      emit(
        const TabsStateFailure(
          tabsFailureMessage: "couldn't changed tab order",
        ),
      );
    }
  }

  void _createTabEvent(
      TabsEvent event, Emitter<TabsState> emit, MyTab tabFormData) async {
    try {
      String? accessToken = await dataRepository.getAccessToken();
      MyTab? newTab = await noteApiService.fetchCreateTab(
        accessToken: accessToken,
        newTabData: tabFormData,
      );
      if (newTab != null) {
        bool isAddedTab = await dataRepository.addTab(newTab);
        if (isAddedTab) {
          emit(const TabsStateLoading(mustRebuild: true));
        } else {
          emit(
            const TabsStateFailure(
              tabsFailureMessage: "tab couldn't created in locale",
            ),
          );
        }
      } else {
        emit(
          const TabsStateFailure(
            tabsFailureMessage: "tab couldn't created in server",
          ),
        );
      }
    } catch (e) {
      print("catch _createTabEvent >> $e");
      emit(
        const TabsStateFailure(
          tabsFailureMessage: "something went wrong in _createdTabEvent",
        ),
      );
    }
  }

  void _updateTabEvent(TabsEvent event, Emitter<TabsState> emit, int index,
      MyTab tabFormData) async {
    try {
      String? id = dataRepository.tabsBox.getAt(index)?.id;
      String? accessToken = await dataRepository.getAccessToken();
      bool isUpdated = await noteApiService.fetchUpdateTab(
        accessToken: accessToken,
        id: id,
        updateTabData: tabFormData,
      );
      if (isUpdated) {
        bool isUpdatedLocal =
            await dataRepository.updateTabs(index, tabFormData);
        if (isUpdatedLocal) {
          emit(const TabsStateLoading(mustRebuild: true));
        } else {
          emit(const TabsStateFailure(
              tabsFailureMessage: "tab couldn't updated in locale"));
        }
      } else {
        emit(
          const TabsStateFailure(
            tabsFailureMessage: "tab couldn't updated in server",
          ),
        );
      }
    } catch (e) {
      print("catch _updateTabEvent >> $e");
      emit(
        const TabsStateFailure(
          tabsFailureMessage: "something went wrong in _updateTabEvent",
        ),
      );
    }
  }

  void _deleteTabEvent(
      TabsEvent event, Emitter<TabsState> emit, int index) async {
    try {
      MyTab? victimTab = dataRepository.tabsBox.getAt(index);
      String? accessToken = await dataRepository.getAccessToken();
      bool isDeleted = await noteApiService.fetchDeleteTab(
          accessToken: accessToken, id: victimTab?.id);
      print('isDeleted _deleteTabEvent >> $isDeleted');
      if (isDeleted) {
        bool isDeletedLocale = await dataRepository.deleteTabs(index);
        if (isDeletedLocale) {
          emit(const TabsStateLoading(mustRebuild: true));
        } else {
          emit(
            const TabsStateFailure(
              tabsFailureMessage: "tab couldn't deleted in locale",
            ),
          );
        }
      } else {
        emit(
          const TabsStateFailure(
            tabsFailureMessage: "tab couldn't deleted in server",
          ),
        );
      }
    } catch (e) {
      print("catch _deleteTabEvent >> $e");
      emit(
        const TabsStateFailure(
          tabsFailureMessage: "something went wrong in _deleteTabEvent",
        ),
      );
    }
  }

  void _tabMenuOpenEvent(
      TabsEvent event, Emitter<TabsState> emit, int index) async {}
}
