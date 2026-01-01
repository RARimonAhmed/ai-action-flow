import 'package:get_storage/get_storage.dart';

class StorageProvider {
  final GetStorage _storage;

  StorageProvider(this._storage);

  Future write(String key, dynamic value) async {
    await _storage.write(key, value);
  }

  T? read(String key) {
    return _storage.read(key);
  }

  Future remove(String key) async {
    await _storage.remove(key);
  }

  Future clear() async {
    await _storage.erase();
  }

  bool hasData(String key) {
    return _storage.hasData(key);
  }
}