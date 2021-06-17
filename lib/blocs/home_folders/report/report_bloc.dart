import 'package:MWPX/services/report_service.dart';
import 'package:MWPX/styles/mwp_icons.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'report_event.dart';
part 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final ReportService? reportService;

  ReportBloc({
    @required this.reportService,
  })  : assert(reportService != null),
        super(ReportInitial());

  @override
  Stream<ReportState> mapEventToState(ReportEvent event) async* {
    if (event is OpenScreen) {
      try {
        yield ReportLoading();
        List<Map> foldersReportDataList = reportService!.foldersReportDataList;
        // throw 'Данных нет';
        List<Map>? newFoldersReportDataList = reportService!.addSvgIcons(
          foldersReportDataList: foldersReportDataList,
          reportSvgIconsList: MwpIcons.svgIconsList,
        );
        yield ReportDataReceived(
          foldersReportDataList: newFoldersReportDataList,
        );
      } catch (error) {
        print('error in ReportBloc $error');
        yield ReportFailure(error: error.toString());
      }
    }
  }
}
