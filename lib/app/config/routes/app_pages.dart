import 'package:ai_action_flow/presentation/pages/webview/webview_binding.dart';
import 'package:ai_action_flow/presentation/pages/webview/webview_page.dart';
import 'package:get/get.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.initial,
      page: () => WebViewPage(),
      binding: WebViewBinding(),
    ),
  ];
}