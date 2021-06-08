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
//     @required this.containerDataList,
//   });
//   final String? containerNumber;
//   final List<Map>? containerDataList;

//   @override
//   List<Object?> get props => [containerNumber, containerDataList];

//   @override
//   String toString() =>
//       'OpenEditScreen { containerNumber: $containerNumber containerDataList: $containerDataList}';
// }

// class EditEvent extends BiometricEvent {
//   final Map? data;
//   final String? oldNumber;

//   const EditEvent({
//     @required this.data,
//     @required this.oldNumber,
//   });

//   @override
//   List<Object?> get props => [data, oldNumber];

//   @override
//   String toString() =>  EditEvent { data: $data oldNumber: $oldNumber }';
// }
