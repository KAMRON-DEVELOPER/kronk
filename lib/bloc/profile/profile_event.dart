import 'package:equatable/equatable.dart';

import '../../models/user.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class GetCashedProfileEvent extends ProfileEvent {}

class GetProfileEvent extends ProfileEvent {}

class UpdateProfileEvent extends ProfileEvent {
  final Profile? updateData;

  const UpdateProfileEvent({required this.updateData});
}
