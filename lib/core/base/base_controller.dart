import 'package:get/get.dart';

abstract class BaseController extends GetxController {
  final _isLoading = false.obs;
  final _error = ''.obs;

  bool get isLoading => _isLoading.value;
  String get error => _error.value;

  void setLoading(bool value) => _isLoading.value = value;
  void setError(String value) => _error.value = value;
  void clearError() => _error.value = '';

  @override
  void onInit() {
    super.onInit();
    initController();
  }

  void initController();
}