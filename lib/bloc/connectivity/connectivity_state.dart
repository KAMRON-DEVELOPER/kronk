import 'package:equatable/equatable.dart';

abstract class ConnectivityState extends Equatable {
  const ConnectivityState();

  @override
  List<Object> get props => [];
}

// Initial state before any connectivity check
class ConnectivityInitial extends ConnectivityState {}

// State when connectivity check is successful
class ConnectivitySuccess extends ConnectivityState {
  @override
  List<Object> get props => [];
}

// State when there is no connectivity
class ConnectivityFailure extends ConnectivityState {
  @override
  List<Object> get props => [];
}
