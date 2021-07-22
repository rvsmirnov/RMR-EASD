import 'package:MWPX/services/report_service.dart';
import 'package:MWPX/styles/mwp_icons.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'rk_card_event.dart';
part 'rk_card_state.dart';

class RKCardBloc extends Bloc<RKCardEvent, RKCardState> {
  final ReportService? reportService;

  RKCardBloc({
    @required this.reportService,
  })  : assert(reportService != null),
        super(RKCardInitial());

  @override
  Stream<RKCardState> mapEventToState(RKCardEvent event) async* {
    if (event is OpenScreen) {
      try {
        yield RKCardLoading();
        // yield RKCardDataReceived(
        //   foldersRKCardDataList: newFoldersRKCardDataList,
        // );
      } catch (error) {
        print('error in RKCardBloc $error');
        yield RKCardFailure(error: error.toString());
      }
    }
  }
}
