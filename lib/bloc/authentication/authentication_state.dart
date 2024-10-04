import 'package:equatable/equatable.dart';
import '../../models/user.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object?> get props => [];
}


class AuthenticationInitial extends AuthenticationState {}


class AuthenticationLoading extends AuthenticationState {}


class AuthenticationSuccess extends AuthenticationState {
  final Profile? authSuccessData;

  const AuthenticationSuccess({this.authSuccessData});

  @override
  List<Object?> get props => [authSuccessData];
}


class AuthenticationFailure extends AuthenticationState {
  final String? authFailureMessage;

  const AuthenticationFailure({this.authFailureMessage});

  @override
  List<Object?> get props => [authFailureMessage];
}


class AuthenticationLogout extends AuthenticationState {

  @override
  List<Object?> get props => [];
}
