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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
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
        // Disable text selection context menu
        disableContextMenu: true,
      ),
      onWebViewCreated: (webViewController) {
        controller.onWebViewCreated(webViewController);

        // Inject CSS to customize text selection colors and hide selection handles
        webViewController.evaluateJavascript(source: """
          (function() {
            var style = document.createElement('style');
            style.innerHTML = `
              ::selection {
                background-color: rgba(52, 133, 255, 0.1) !important;
                color: #3485FF !important;
              }
              ::-moz-selection {
                background-color: rgba(52, 133, 255, 0.1) !important;
                color: #3485FF !important;
              }
              
              /* Hide selection handles and tooltips */
              ::-webkit-selection-handle,
              ::-webkit-selection-handle-left,
              ::-webkit-selection-handle-right {
                display: none !important;
                visibility: hidden !important;
                background-color: #3485FF !important;
              }
              
              /* Hide Android selection action mode */
              .android-action-mode {
                display: none !important;
              }
            `;
            document.head.appendChild(style);
          })();
        """);
      },
      onLoadStop: (webViewController, url) {
        controller.onLoadStop(webViewController, url);

        // Re-inject CSS after page load to ensure it applies
        webViewController.evaluateJavascript(source: """
          (function() {
            var style = document.createElement('style');
            style.innerHTML = `
              ::selection {
                background-color: rgba(52, 133, 255, 0.1) !important;
                color: #3485FF !important;
              }
              ::-moz-selection {
                background-color: rgba(52, 133, 255, 0.1) !important;
                color: #3485FF !important;
              }
              
              /* Hide selection handles and tooltips */
              ::-webkit-selection-handle,
              ::-webkit-selection-handle-left,
              ::-webkit-selection-handle-right {
                display: none !important;
                visibility: hidden !important;
                background-color: #3485FF !important;
              }
              
              /* Hide Android selection action mode */
              .android-action-mode {
                display: none !important;
              }
            `;
            document.head.appendChild(style);
          })();
        """);
      },
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