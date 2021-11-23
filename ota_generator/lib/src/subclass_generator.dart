import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:ota_string/ota_string.dart';
import 'package:source_gen/source_gen.dart';
import 'model_visitor.dart';

class SubClassGenerator extends GeneratorForAnnotation<OtaStringClass> {
  @override
  String generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    final visitor = ModelVisitor();
    element.visitChildren(visitor);

    final classBuffer = StringBuffer();

    final className = 'Ota${visitor.className}';
    final translationServer = annotation.read('translationServer').stringValue;
    final translationServerValue = annotation.read('translationServerStg');
    var translationServerStg = '';
    if (!translationServerValue.isNull) {
      translationServerStg = translationServerValue.stringValue;
    }

    final listOfLangKey = annotation
        .read('languageKey')
        .listValue
        .map((e) => e.toStringValue())
        .toList();
    final listOfBoxKey = listOfLangKey.map((e) => 'box_$e').toList();

    // start the Subclass
    classBuffer.writeln('class $className extends ${visitor.className} {');
    _getCurrentInstance(classBuffer, className, visitor);
    _loadString(classBuffer, className, listOfLangKey, listOfBoxKey);
    _updateData(classBuffer, className, visitor, translationServer,
        translationServerStg, listOfBoxKey);
    _generateGetters(visitor, classBuffer);

    // end the Subclass
    classBuffer.writeln('}');

    _writeExtension(classBuffer, className);

    // return '/*' + classBuffer.toString() + '*/';
    return classBuffer.toString();
  }

  void _loadString(StringBuffer classBuffer, String className,
      List<String?> listOfLangKey, List<String> listOfBoxKey) {
    classBuffer
        .writeln('static Future<$className> load(String locale) async {');

    for (var i = 0; i < listOfLangKey.length; i++) {
      var lang = listOfLangKey[i];
      var boxKey = listOfBoxKey[i];
      if (i == 0) {
        classBuffer.writeln("if(locale == '$lang'){");
        classBuffer
            .writeln("var openbox = await OtaStorage.openStorage('$boxKey');");
        classBuffer.writeln('final instance = OtaAppLocalize();');
        classBuffer.writeln("OtaStorage.openPrevStorage('$boxKey');");
        classBuffer.writeln('OtaAppLocalize._current = instance;');
        classBuffer.writeln('return Future.value(instance);');
        classBuffer.writeln('}');
      } else if (i < listOfLangKey.length) {
        classBuffer.writeln("else if(locale == '$lang'){");
        classBuffer
            .writeln("var openbox = await OtaStorage.openStorage('$boxKey');");
        classBuffer.writeln('final instance = OtaAppLocalize();');
        classBuffer.writeln("OtaStorage.openPrevStorage('$boxKey');");
        classBuffer.writeln('OtaAppLocalize._current = instance;');
        classBuffer.writeln('return Future.value(instance);');
        classBuffer.writeln('}');
      }
    }
    var defaultBoxKey = listOfBoxKey.first;
    classBuffer.writeln('else {');
    classBuffer.writeln(
        "var openbox = await OtaStorage.openStorage('$defaultBoxKey');");
    classBuffer.writeln('final instance = OtaAppLocalize();');
    classBuffer.writeln("OtaStorage.openPrevStorage('$defaultBoxKey');");
    classBuffer.writeln('OtaAppLocalize._current = instance;');
    classBuffer.writeln('return Future.value(instance);');
    classBuffer.writeln('}');
    classBuffer.writeln('}');
  }

  void _getCurrentInstance(
      StringBuffer classBuffer, String className, ModelVisitor visitor) {
    classBuffer.writeln('static $className? _current;');
    classBuffer.writeln('static $className get current {');
    classBuffer.writeln(
        "assert(_current != null, 'No instance of ${visitor.className} was loaded. Try to initialize the ${visitor.className} delegate before accessing AppLocalize.current.');");
    classBuffer.writeln('return _current!;');
    classBuffer.writeln('}');
  }

  void _generateGetters(ModelVisitor visitor, StringBuffer classBuffer) {
    for (final field in visitor.fields.keys) {
      final variable =
          field.startsWith('_') ? field.replaceFirst('_', '') : field;
      classBuffer.writeln();
      classBuffer.writeln(
          "${visitor.fields[field]} get $variable => OtaStorage.getString('$variable', defValue: _$variable);");
    }
  }

  void _updateData(
      StringBuffer classBuffer,
      String className,
      ModelVisitor visitor,
      String translationServer,
      String? translationServerStg,
      List<String> listOfBoxKey) {
    classBuffer.writeln('Future<void> updateData() async {');
    classBuffer.writeln('try{');

    classBuffer.writeln("var transServer = '$translationServer';");
    classBuffer.writeln(
        "const isProd = bool.fromEnvironment('otaStringProdEnv', defaultValue: false);");
    classBuffer.writeln("if(!isProd && '$translationServerStg'.isNotEmpty){");
    classBuffer.writeln("transServer = '$translationServerStg';");
    classBuffer.writeln('}');

    classBuffer.writeln(
        "var response = await NetworkClient().getStringTranslation('\$transServer');");
    for (var i = 0; i < listOfBoxKey.length; i++) {
      var boxKey = listOfBoxKey[i];
      classBuffer.writeln("OtaStorage.openStorage('$boxKey').then((value) {");
      classBuffer.writeln(
          "value.putData(response.data!['response']['config'][$i]['value']);");
      classBuffer.writeln('});');
    }

    classBuffer.writeln('} catch (e) {');
    classBuffer.writeln('print(e);');
    classBuffer.writeln('}');
    classBuffer.writeln('}');
  }

  void _writeExtension(StringBuffer classBuffer, String className) {
    classBuffer.writeln('extension ${className}Extension on String {');
    classBuffer
        .writeln('String replaceOtaStringWith(List<String> listString) {');
    classBuffer.writeln("final regex = RegExp(r'{[^{}]+(})');");
    classBuffer.writeln('final match = regex.allMatches(this).toList();');
    classBuffer.writeln('if(match.length != listString.length) {');
    classBuffer.writeln(
        "throw('Arguments(\${match.length}) and params(\${listString.length}) not match');");
    classBuffer.writeln('}');
    classBuffer.writeln('var i = -1;');
    classBuffer.writeln('return replaceAllMapped(regex, (match) {');
    classBuffer.writeln('i++;');
    classBuffer.writeln('return listString[i];');
    classBuffer.writeln('});');
    classBuffer.writeln('}');
    classBuffer.writeln('}');
  }
}
