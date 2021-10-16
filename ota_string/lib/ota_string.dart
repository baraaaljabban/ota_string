library ota_string;

import 'src/storage/local_storage.dart';

export 'src/annotations/extension_method.dart';
export 'src/networks/network_client.dart';
export 'src/storage/local_storage.dart';

// ignore: non_constant_identifier_names
final OtaLocalStorage OtaStorage = HiveLocalStorage.instance;