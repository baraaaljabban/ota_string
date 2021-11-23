import 'package:hive/hive.dart';

abstract class OtaLocalStorage {
  Future<dynamic> openStorage(String storageName);
  dynamic openPrevStorage(String storageName);

  void deleteData(String key);

  String getString(String key, {String defValue});
  void putData(Map<String, dynamic> entries);
}

class HiveLocalStorage implements OtaLocalStorage {

  late Box<dynamic> _box;

  static final OtaLocalStorage _instance = HiveLocalStorage._internal();

  HiveLocalStorage._internal();

  static OtaLocalStorage get instance => _instance;

  @override
  Future<dynamic> openStorage(String storageName) async {
    _box = await Hive.openBox<dynamic>(storageName);
    return this;
  }

  @override
  dynamic openPrevStorage(String storageName) async {
    _box = Hive.box<dynamic>(storageName);
    return _box;
  }

  @override
  void deleteData(String key) {
    Hive.deleteBoxFromDisk(key);
  }

  @override
  String getString(String key, {String defValue = ''}) {
    return _box.get(key, defaultValue: defValue) as String;
  }

  @override
  void putData(Map<String, dynamic> entries) async {
    _box.putAll(entries);
  }

}