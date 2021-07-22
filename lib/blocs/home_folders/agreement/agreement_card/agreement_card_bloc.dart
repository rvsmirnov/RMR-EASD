import 'package:MWPX/services/report_service.dart';
import 'package:MWPX/styles/mwp_icons.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'agreement_card_event.dart';
part 'agreement_card_state.dart';

class AgreementCardBloc extends Bloc<AgreementCardEvent, AgreementCardState> {
  final ReportService? reportService;

  AgreementCardBloc({
    @required this.reportService,
  })  : assert(reportService != null),
        super(AgreementCardInitial());

  @override
  Stream<AgreementCardState> mapEventToState(AgreementCardEvent event) async* {
    if (event is OpenScreen) {
      try {
        yield AgreementCardLoading();
        List<Map> foldersAgreementCardDataList = reportService!.foldersReportDataList;
        // throw 'Данных нет';
        List<Map>? newFoldersAgreementCardDataList = reportService!.addSvgIcons(
          foldersReportDataList: foldersAgreementCardDataList,
          reportSvgIconsList: MwpIcons.svgIconsList,
        );
        yield AgreementCardDataReceived(
          foldersAgreementCardDataList: newFoldersAgreementCardDataList,
        );
      } catch (error) {
        print('error in AgreementCardBloc $error');
        yield AgreementCardFailure(error: error.toString());
      }
    }
  }
}
