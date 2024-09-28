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
  final Profile? registerSuccessData;
  final Profile? verifySuccessData;
  final Profile? loginSuccessData;

  const AuthenticationSuccess({
    this.registerSuccessData,
    this.verifySuccessData,
    this.loginSuccessData,
  });

  @override
  List<Object?> get props => [
        registerSuccessData,
        verifySuccessData,
        loginSuccessData,
      ];
}

class AuthenticationFailure extends AuthenticationState {
  final String? registerFailureMessage;
  final String? loginFailureMessage;
  final String? verifyFailureMessage;

  const AuthenticationFailure({
    this.registerFailureMessage,
    this.verifyFailureMessage,
    this.loginFailureMessage,
  });

  @override
  List<Object?> get props => [
        registerFailureMessage,
        verifyFailureMessage,
        loginFailureMessage,
      ];
}