part of 'report_bloc.dart';

abstract class ReportState extends Equatable {
  const ReportState();

  @override
  List<Object?> get props => [];
}

class ReportInitial extends ReportState {}

class ReportLoading extends ReportState {}

class ReportDataReceived extends ReportState {
  final List<Map>? foldersReportDataList;

  const ReportDataReceived({@required this.foldersReportDataList});

  @override
  List<Object?> get props => [foldersReportDataList];

  @override
  String toString() => 'ReportDataReceived { foldersReportDataList: $foldersReportDataList }';

}

class ReportFailure extends ReportState {
  final String? error;

  const ReportFailure({@required this.error});

  @override
  List<Object?> get props => [error];

  @override
  String toString() => 'ReportFailure { error: $error }';
}
