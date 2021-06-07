part of 'biometric_bloc.dart';

abstract class BiometricEvent extends Equatable {
  const BiometricEvent();

  @override
  List<Object?> get props => [];
}

class OpenScreen extends BiometricEvent {}

class BiometricRun extends BiometricEvent {}

// class OpenEditScreen extends BiometricEvent {
//   const OpenEditScreen({
//     @required this.containerNumber,
//     @required this.containerZpuList,
//   });
//   final String? containerNumber;
//   final List<Map>? containerZpuList;

//   @override
//   List<Object?> get props => [containerNumber, containerZpuList];

//   @override
//   String toString() =>
//       'OpenEditScreen { containerNumber: $containerNumber containerZpuList: $containerZpuList}';
// }

// class EditZpuEvent extends BiometricEvent {
//   final Map? zpu;
//   final String? oldNumber;

//   const EditZpuEvent({
//     @required this.zpu,
//     @required this.oldNumber,
//   });

//   @override
//   List<Object?> get props => [zpu, oldNumber];

//   @override
//   String toString() => 'EditZpuEvent { zpu: $zpu oldNumber: $oldNumber }';
// }
