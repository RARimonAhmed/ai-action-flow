import 'package:get_storage/get_storage.dart';
import '../../../core/utils/logger.dart';

class StorageProvider {
  final GetStorage _storage;

  StorageProvider(this._storage);

  // Keys
  static const String keyHistory = 'ai_response_history';
  static const String keySettings = 'app_settings';
  static const String keyLastSession = 'last_session';

  Future write(String key, dynamic value) async {
    try {
      await _storage.write(key, value);
      AppLogger.d('Storage write: $key');
    } catch (e) {
      AppLogger.e('Storage write error', e);
      rethrow;
    }
  }

  T? read(String key) {
    try {
      final value = _storage.read(key);
      AppLogger.d('Storage read: $key');
      return value;
    } catch (e) {
      AppLogger.e('Storage read error', e);
      return null;
    }
  }

  Future remove(String key) async {
    try {
      await _storage.remove(key);
      AppLogger.d('Storage remove: $key');
    } catch (e) {
      AppLogger.e('Storage remove error', e);
      rethrow;
    }
  }

  Future clear() async {
    try {
      await _storage.erase();
      AppLogger.i('Storage cleared');
    } catch (e) {
      AppLogger.e('Storage clear error', e);
      rethrow;
    }
  }

  bool hasData(String key) {
    return _storage.hasData(key);
  }

  List getKeys() {
    return _storage.getKeys();
  }

  void listenKey(String key, Function(dynamic) callback) {
    _storage.listenKey(key, callback);
  }
}