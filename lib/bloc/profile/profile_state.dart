import 'package:equatable/equatable.dart';
import '../../models/user.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileStateLoading extends ProfileState {
  final bool? mustRebuild;

  const ProfileStateLoading({this.mustRebuild});

  @override
  List<Object?> get props => [mustRebuild];
}

class ProfileStateSuccess extends ProfileState {
  final Profile? profileData;

  const ProfileStateSuccess({required this.profileData});

  @override
  List<Object?> get props => [profileData];
}

class ProfileStateFailure extends ProfileState {
  final String profileFailureMessage;

  const ProfileStateFailure({required this.profileFailureMessage});

  @override
  List<Object?> get props => [profileFailureMessage];
}
