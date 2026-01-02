import 'package:ai_action_flow/core/network/network_info.dart';
import 'package:ai_action_flow/data/providers/local/storage_provider.dart';
import 'package:ai_action_flow/data/providers/network/api_provider.dart';
import 'package:ai_action_flow/data/providers/network/dio_client.dart';
import 'package:ai_action_flow/data/repositories/ai_repository_impl.dart';
import 'package:ai_action_flow/domain/repositories/ai_repository.dart';
import 'package:ai_action_flow/domain/usecases/generate_ai_response_usecase.dart';
import 'package:ai_action_flow/domain/usecases/get_prompts_usecase.dart';
import 'package:ai_action_flow/presentation/controllers/ai_action/ai_action_controller.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../controllers/webview/webview_controller.dart';

class WebViewBinding extends Bindings {
  @override
  void dependencies() {
    // Core
    Get.lazyPut<NetworkInfo>(() => NetworkInfoImpl(Connectivity()));
    Get.lazyPut(() => DioClient());

    // Providers
    Get.lazyPut(() => ApiProvider(Get.find<DioClient>()));
    Get.lazyPut(() => StorageProvider(GetStorage()));

    // Repository (Register the implementation, not the interface)
    Get.lazyPut<AIRepository>(() => AIRepositoryImpl(
      apiProvider: Get.find<ApiProvider>(),
      networkInfo: Get.find<NetworkInfo>(),
      storageProvider: Get.find<StorageProvider>(),
    ));

    // Use Cases
    Get.lazyPut(() => GetPromptsUseCase(Get.find<AIRepository>()));
    Get.lazyPut(() => GenerateAIResponseUseCase(Get.find<AIRepository>()));

    // Controllers
    Get.lazyPut(() => AIActionController(
      generateAIResponseUseCase: Get.find<GenerateAIResponseUseCase>(),
      getPromptsUseCase: Get.find<GetPromptsUseCase>(),
    ));
    Get.lazyPut(() => WebViewController());
  }
}