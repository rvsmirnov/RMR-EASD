part of 'biometric_bloc.dart';

abstract class BiometricState extends Equatable {
  const BiometricState();

  @override
  List<Object?> get props => [];
}

class BiometricInitial extends BiometricState {}

class BiometricLoading extends BiometricState {}

class BiometricAvailable extends BiometricState {}

class BiometricNotAvailable extends BiometricState {}

class BiometricSucess extends BiometricState {}

class BiometricFailure extends BiometricState {
  final String? error;

  const BiometricFailure({@required this.error});

  @override
  List<Object?> get props => [error];

  @override
  String toString() => 'BiometricFailure { error: $error }';
}
