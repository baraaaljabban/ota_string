// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_localize.dart';

// **************************************************************************
// SubClassGenerator
// **************************************************************************

class OtaAppLocalize extends AppLocalize {
  static OtaAppLocalize? _current;
  static OtaAppLocalize get current {
    assert(_current != null,
        'No instance of AppLocalize was loaded. Try to initialize the AppLocalize delegate before accessing AppLocalize.current.');
    return _current!;
  }

  static Future<OtaAppLocalize> load(String locale) async {
    if (locale == 'en') {
      var openbox = await OtaStorage.openStorage('box_en');
      final instance = OtaAppLocalize();
      OtaStorage.openPrevStorage('box_en');
      OtaAppLocalize._current = instance;
      return Future.value(instance);
    } else if (locale == 'zh') {
      var openbox = await OtaStorage.openStorage('box_zh');
      final instance = OtaAppLocalize();
      OtaStorage.openPrevStorage('box_zh');
      OtaAppLocalize._current = instance;
      return Future.value(instance);
    } else if (locale == 'tlh') {
      var openbox = await OtaStorage.openStorage('box_tlh');
      final instance = OtaAppLocalize();
      OtaStorage.openPrevStorage('box_tlh');
      OtaAppLocalize._current = instance;
      return Future.value(instance);
    } else {
      var openbox = await OtaStorage.openStorage('box_en');
      final instance = OtaAppLocalize();
      OtaStorage.openPrevStorage('box_en');
      OtaAppLocalize._current = instance;
      return Future.value(instance);
    }
  }

  Future<void> updateData() async {
    try {
      var transServer =
          'https://aldychris.github.io/JsonMocks/OtaJson/BasicSampleProduction.json';
      const isProd =
          bool.fromEnvironment('otaStringProdEnv', defaultValue: false);
      if (!isProd &&
          'https://aldychris.github.io/JsonMocks/OtaJson/BasicSample.json'
              .isNotEmpty) {
        transServer =
            'https://aldychris.github.io/JsonMocks/OtaJson/BasicSample.json';
      }
      var response = await NetworkClient().getStringTranslation('$transServer');
      OtaStorage.openStorage('box_en').then((value) {
        value.putData(response.data!['response']['config'][0]['value']);
      });
      OtaStorage.openStorage('box_zh').then((value) {
        value.putData(response.data!['response']['config'][1]['value']);
      });
      OtaStorage.openStorage('box_tlh').then((value) {
        value.putData(response.data!['response']['config'][2]['value']);
      });
    } catch (e) {
      print(e);
    }
  }

  String get hello => OtaStorage.getString('hello', defValue: _hello);

  String get name_location =>
      OtaStorage.getString('name_location', defValue: _name_location);
}

extension OtaAppLocalizeExtension on String {
  String replaceOtaStringWith(List<String> listString) {
    final regex = RegExp(r'{[^{}]+(})');
    final match = regex.allMatches(this).toList();
    if (match.length != listString.length) {
      throw ('Arguments(${match.length}) and params(${listString.length}) not match');
    }
    var i = -1;
    return replaceAllMapped(regex, (match) {
      i++;
      return listString[i];
    });
  }
}
