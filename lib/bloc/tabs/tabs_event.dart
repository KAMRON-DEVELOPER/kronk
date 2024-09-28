import 'package:equatable/equatable.dart';
import '../../models/tab.dart';

abstract class TabsEvent extends Equatable {
  const TabsEvent();

  @override
  List<Object?> get props => [];
}

class GetCashedTabsEvent extends TabsEvent {}

class GetTabsEvent extends TabsEvent {}

class ChangeTabOrderEvent extends TabsEvent {
  final int oldIndex;
  final int newIndex;

  const ChangeTabOrderEvent({required this.oldIndex, required this.newIndex});
}

class CreateTabEvent extends TabsEvent {
  final MyTab newTabFormData;

  const CreateTabEvent({required this.newTabFormData});

  @override
  List<Object> get props => [newTabFormData];
}

class UpdateTabEvent extends TabsEvent {
  final int index;
  final MyTab tabFormData;

  const UpdateTabEvent({required this.index, required this.tabFormData});

  @override
  List<Object> get props => [index, tabFormData];
}

class DeleteTabEvent extends TabsEvent {
  final int index;

  const DeleteTabEvent({required this.index});

  @override
  List<Object> get props => [index];
}

class TabMenuOpenEvent extends TabsEvent {
  final int index;

  const TabMenuOpenEvent({required this.index});

  @override
  List<Object> get props => [index];
}
