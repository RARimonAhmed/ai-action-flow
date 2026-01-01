import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import '../../controllers/webview/webview_controller.dart';
import '../../widgets/action_bubble_widget.dart';
import '../../widgets/promt_bottomsheet.dart';

class WebViewPage extends StatelessWidget {
  WebViewPage({super.key});

  final controller = Get.find<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Text Assistant'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.webViewController?.reload(),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Obx(() => controller.progress.value < 1.0
                  ? LinearProgressIndicator(value: controller.progress.value)
                  : const SizedBox.shrink()),
              Expanded(child: _buildWebView()),
            ],
          ),
          Obx(() => controller.showActionBubble.value &&
              controller.bubblePosition.value != null
              ? ActionBubbleWidget(
            position: controller.bubblePosition.value!,
            onTap: controller.onActionBubbleTapped,
          )
              : const SizedBox.shrink()),
          const PromptBottomSheet(),
        ],
      ),
    );
  }

  Widget _buildWebView() {
    return InAppWebView(
      initialUrlRequest: URLRequest(
        url: WebUri('https://www.example.com'), // Default URL
      ),
      initialSettings: InAppWebViewSettings(
        javaScriptEnabled: true,
        javaScriptCanOpenWindowsAutomatically: true,
        useOnLoadResource: true,
        useShouldOverrideUrlLoading: true,
      ),
      onWebViewCreated: controller.onWebViewCreated,
      onLoadStop: controller.onLoadStop,
      onProgressChanged: controller.onProgressChanged,
      onLoadError: (controller, url, code, message) {
        Get.snackbar(
          'Error',
          'Failed to load page: $message',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }
}