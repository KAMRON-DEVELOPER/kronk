import 'package:equatable/equatable.dart';
import '../../models/user.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object?> get props => [];
}

class RegisterSubmitEvent extends AuthenticationEvent {
  final Profile registerData;

  const RegisterSubmitEvent({required this.registerData});

  @override
  List<Object> get props => [registerData];
}

class VerifySubmitEvent extends AuthenticationEvent {
  final Profile verifyData;

  const VerifySubmitEvent({required this.verifyData});

  @override
  List<Object> get props => [verifyData];
}

class LoginSubmitEvent extends AuthenticationEvent {
  final Profile loginData;

  const LoginSubmitEvent({required this.loginData});

  @override
  List<Object> get props => [loginData];
}
