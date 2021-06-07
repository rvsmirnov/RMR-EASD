import 'package:MWPX/services/biometric_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:meta/meta.dart';

part 'biometric_event.dart';
part 'biometric_state.dart';

class BiometricBloc extends Bloc<BiometricEvent, BiometricState> {
  final BiometricService? biometricService;

  BiometricBloc({
    @required this.biometricService,
  })  : assert(biometricService != null),
        super(BiometricInitial());

  // @override
  // BiometricState get initialState => BiometricInitial();

  String biometricName = '';
  String globalBiometrivName = '';

  @override
  Stream<BiometricState> mapEventToState(BiometricEvent event) async* {
    if (event is OpenScreen) {
      try {
        yield BiometricLoading();

        // проверяем, подключена ли биометрия на устройстве
        bool canCheckBiometrics = await biometricService!.checkingBiometrics();
        // Если подключена, проверяем какая биометрия доступна
        if (canCheckBiometrics) {
          List<BiometricType> biometricTypeList =
              await biometricService!.getAvailableBiometrics();
          print('-- список доступной биометрии $biometricTypeList');
          if (biometricTypeList.contains(BiometricType.fingerprint)) {
            // Touch ID.
            biometricName = 'fingerprint';
            globalBiometrivName = 'fingerprint';
          } else if (biometricTypeList.contains(BiometricType.face)) {
            biometricName = 'face';
            globalBiometrivName = 'face';
          }
          yield BiometricAvailable();
        } else {
          yield BiometricNotAvailable();
        }
      } catch (error) {
        print('error in BiometricBloc $error');
        yield BiometricFailure(error: error.toString());
      }
    }
    if (event is BiometricRun) {
      try {
        bool authenticated =
            await biometricService!.authenticationWithBiometrics();
        if (authenticated) {
          yield BiometricSucess();
        } else {
          throw ('Аутентификация не выполнена!');
        }
      } catch (error) {
        print('error in BiometricBloc $error');
        yield BiometricFailure(error: error.toString());
      }
    }
    // if (event is OpenEditScreen) {
    //   try {
    //     yield BiometricLoading();
    //     List<Map> containerZpuList = List<Map>.empty();
    //     // Выбираем ЗПУ конкретного вагона
    //     event.containerZpuList?.forEach(
    //       (e) {
    //         print('--- e[containerNumber] ${e['containerNumber']}');
    //         print('--- event.containerNumber ${event.containerNumber}');
    //         if (e['containerNumber'] == event.containerNumber) {
    //           containerZpuList.add(e);
    //         }
    //       },
    //     );
    //     zpuList = containerZpuList;
    //     print('--- --- containerZpuList in OpenEditScreen $zpuList');
    //     yield BiometricDataReceived(zpuList: zpuList);
    //   } catch (error) {
    //     print('error in BiometricBloc $error');
    //     yield BiometricFailure(error: error.toString());
    //   }
    // }
  }
}
