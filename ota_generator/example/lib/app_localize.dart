import 'package:ota_string/ota_string.dart';
import 'package:hive/hive.dart';

part 'app_localize.g.dart';

@OtaStringClass(
    translationServerStg:
        'https://aldychris.github.io/JsonMocks/OtaJson/BasicSample.json',
    translationServer:
        'https://aldychris.github.io/JsonMocks/OtaJson/BasicSampleProduction.json',
    languageKey: ['en', 'zh', 'tlh'])
class AppLocalize {
  final String _hello = 'DefaultHello';
  final String _name_location = 'My Name is {name}, Im from {location}';
}
