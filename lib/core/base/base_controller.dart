import 'package:get/get.dart';
import '../utils/logger.dart';

abstract class BaseController extends GetxController {
  final _isLoading = false.obs;
  final _error = Rx("null");
  final _isInitialized = false.obs;

  bool get isLoading => _isLoading.value;
  String? get error => _error.value;
  bool get isInitialized => _isInitialized.value;

  void setLoading(bool value) {
    _isLoading.value = value;
    AppLogger.d('${runtimeType}: Loading state changed to $value');
  }

  void setError(String? value) {
    _error.value = value;
    if (value != null) {
      AppLogger.e('${runtimeType}: Error occurred: $value');
    }
  }

  void clearError() => _error.value = null;

  void setInitialized(bool value) {
    _isInitialized.value = value;
    AppLogger.i('${runtimeType}: Initialized state: $value');
  }

  @override
  void onInit() {
    super.onInit();
    AppLogger.i('${runtimeType}: onInit called');
    initController();
  }

  @override
  void onReady() {
    super.onReady();
    AppLogger.i('${runtimeType}: onReady called');
  }

  @override
  void onClose() {
    AppLogger.i('${runtimeType}: onClose called - cleaning up resources');
    disposeController();
    super.onClose();
  }

  // Abstract methods to be implemented by child controllers
  void initController();
  void disposeController() {
    // Override in child classes if needed
  }
}