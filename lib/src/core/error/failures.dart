import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final List<Object?> properties;

  const Failure([this.properties = const <Object?>[]]);

  @override
  List<Object?> get props => properties;
}

// General failures
class ServerFailure extends Failure {
  final String message;
  ServerFailure({required this.message}) : super([message]);
}

class CacheFailure extends Failure {
  final String message;
  CacheFailure({required this.message}) : super([message]);
}

class NetworkFailure extends Failure {
  final String message;
  NetworkFailure({required this.message}) : super([message]);
}

class UnknownFailure extends Failure {
  final String message;
  UnknownFailure({required this.message}) : super([message]);
}
