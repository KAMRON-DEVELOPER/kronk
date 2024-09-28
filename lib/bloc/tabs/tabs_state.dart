import 'package:equatable/equatable.dart';

import '../../models/tab.dart';

abstract class TabsState extends Equatable {
  const TabsState();
  @override
  List<Object?> get props => [];
}

class TabsStateLoading extends TabsState {
  final bool? mustRebuild;
  const TabsStateLoading({this.mustRebuild});

  @override
  List<Object?> get props => [mustRebuild];
}

class TabsStateSuccess extends TabsState {
  final List<MyTab?> tabs;
  final bool? isOpenMenu;
  const TabsStateSuccess({required this.tabs, this.isOpenMenu});

  @override
  List<Object?> get props => [tabs];
}

class TabsStateFailure extends TabsState {
  final String tabsFailureMessage;
  const TabsStateFailure({required this.tabsFailureMessage});

  @override
  List<Object?> get props => [tabsFailureMessage];
}
