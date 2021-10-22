import 'package:rxdart/rxdart.dart';

import 'app_localize.dart';

class OtaStringBloc {
  late final PublishSubject<String> _stringMoreSubject =
      PublishSubject<String>();
  Stream<String> get stringObservable => _stringMoreSubject.stream;

  void getHiString() async {
    var res = OtaAppLocalize.current.hello;
    _stringMoreSubject.add(res);
  }

  void getIntroductionString() async {
    var res = OtaAppLocalize.current.name_location
        .replaceOtaStringWith(['Spock', 'Vulcan']);
    _stringMoreSubject.add(res);
  }

  void updateData() async {
    OtaAppLocalize.current.updateData();
  }

  void loadEn() async {
    OtaAppLocalize.load('en');
  }

  void loadZh() async {
    OtaAppLocalize.load('zh');
  }

  void loadKlingon() async {
    OtaAppLocalize.load('tlh');
  }

  void dispose() {
    _stringMoreSubject.close();
  }
}
