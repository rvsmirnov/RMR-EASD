import 'package:MWPX/services/report_service.dart';
import 'package:MWPX/styles/mwp_icons.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'decision_card_event.dart';
part 'decision_card_state.dart';

class DecisionCardBloc extends Bloc<DecisionCardEvent, DecisionCardState> {
  final ReportService? reportService;

  DecisionCardBloc({
    @required this.reportService,
  })  : assert(reportService != null),
        super(DecisionCardInitial());

  @override
  Stream<DecisionCardState> mapEventToState(DecisionCardEvent event) async* {
    if (event is OpenScreen) {
      try {
        yield DecisionCardLoading();
        List<Map> foldersDecisionCardDataList = reportService!.foldersReportDataList;
        // throw 'Данных нет';
        List<Map>? newFoldersDecisionCardDataList = reportService!.addSvgIcons(
          foldersReportDataList: foldersDecisionCardDataList,
          reportSvgIconsList: MwpIcons.svgIconsList,
        );
        yield DecisionCardDataReceived(
          foldersDecisionCardDataList: newFoldersDecisionCardDataList,
        );
      } catch (error) {
        print('error in DecisionCardBloc $error');
        yield DecisionCardFailure(error: error.toString());
      }
    }
  }
}
