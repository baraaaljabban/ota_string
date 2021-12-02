import 'package:hive/hive.dart';

abstract class OtaLocalStorage {
  Future<dynamic> openStorage(String storageName);
  dynamic openPrevStorage(String storageName);

  void deleteData(String key);

  String getString(String key, {String defValue});
  void putData(Map<String, dynamic> entries);
}

class HiveLocalStorage implements OtaLocalStorage {

  late Box<dynamic> _boxUpdate;
  late Box<dynamic> _boxOpen;

  static final OtaLocalStorage _instance = HiveLocalStorage._internal();

  HiveLocalStorage._internal();

  static OtaLocalStorage get instance => _instance;

  @override
  Future<dynamic> openStorage(String storageName) async {
    _boxUpdate = await Hive.openBox<dynamic>(storageName);
    return this;
  }

  @override
  dynamic openPrevStorage(String storageName) async {
    _boxOpen = Hive.box<dynamic>(storageName);
    return _boxOpen;
  }

  @override
  void deleteData(String key) {
    Hive.deleteBoxFromDisk(key);
  }

  @override
  String getString(String key, {String defValue = ''}) {
    return _boxOpen.get(key, defaultValue: defValue) as String;
  }

  @override
  void putData(Map<String, dynamic> entries) async {
    _boxUpdate.putAll(entries);
  }

}