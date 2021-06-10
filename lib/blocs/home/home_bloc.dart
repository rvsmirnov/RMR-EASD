import 'package:MWPX/services/home_service.dart';
import 'package:MWPX/styles/mwp_icons.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeService? homeService;

  HomeBloc({
    @required this.homeService,
  })  : assert(homeService != null),
        super(HomeInitial());

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is OpenScreen) {
      try {
        yield HomeLoading();
        List<Map> foldersHomeDataList = homeService!.foldersHomeDataList;
        // throw 'Данных нет';
        List<Map>? newFoldersHomeDataList = homeService!.addSvgIcons(
          foldersHomeDataList: foldersHomeDataList,
          homeSvgIconsList: MwpIcons.homeSvgIconsList,
        );
        yield HomeDataReceived(
          foldersHomeDataList: newFoldersHomeDataList,
        );
      } catch (error) {
        print('error in HomeBloc $error');
        yield HomeFailure(error: error.toString());
      }
    }
  }
}
