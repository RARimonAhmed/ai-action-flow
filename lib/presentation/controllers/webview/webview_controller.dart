import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import '../../../core/base/base_controller.dart';
import '../../../core/utils/logger.dart';
import '../../../domain/entities/selected_text_entity.dart';
import '../ai_action/ai_action_controller.dart';

class WebViewController extends BaseController {
  // WebView
  InAppWebViewController? webViewController;
  final currentUrl = ''.obs;
  final pageTitle = ''.obs;
  final canGoBack = false.obs;
  final canGoForward = false.obs;
  final progress = 0.0.obs;

  // Text Selection
  final selectedText = Rx(null);
  final showActionBubble = false.obs;
  final bubblePosition = Rx(null);

  // Controllers
  late AIActionController aiActionController;

  // Debouncer for text selection
  Timer? _selectionDebouncer;

  @override
  void initController() {
    AppLogger.i('WebViewController initialized');
    aiActionController = Get.find();
    _setupWebViewSettings();
  }

  @override
  void disposeController() {
    _selectionDebouncer?.cancel();
    webViewController?.dispose();
    AppLogger.i('WebViewController disposed');
  }

  void _setupWebViewSettings() {
    // Any initial settings can be configured here
  }

  // WebView Callbacks
  void onWebViewCreated(InAppWebViewController controller) {
    webViewController = controller;
    AppLogger.i('WebView created');
    _injectTextSelectionScript();
  }

  void onLoadStart(InAppWebViewController controller, Uri? url) {
    if (url != null) {
      currentUrl.value = url.toString();
      AppLogger.d('Loading started: $url');
    }
    setLoading(true);
  }

  void onLoadStop(InAppWebViewController controller, Uri? url) async {
    if (url != null) {
      currentUrl.value = url.toString();
    }

    pageTitle.value = await controller.getTitle() ?? '';
    canGoBack.value = await controller.canGoBack();
    canGoForward.value = await controller.canGoForward();

    setLoading(false);
    AppLogger.d('Loading completed: $url');

    // Re-inject script on page load
    _injectTextSelectionScript();
  }

  void onProgressChanged(InAppWebViewController controller, int progress) {
    this.progress.value = progress / 100;
  }

  void onLoadError(
      InAppWebViewController controller,
      Uri? url,
      int code,
      String message,
      ) {
    AppLogger.e('WebView load error: $message (Code: $code)');
    setError('Failed to load page: $message');
    setLoading(false);
  }

  // Inject JavaScript for text selection handling
  void _injectTextSelectionScript() async {
    if (webViewController == null) return;

    const script = '''
      (function() {
        let selectionTimeout;
        
        document.addEventListener('selectionchange', function() {
          clearTimeout(selectionTimeout);
          
          selectionTimeout = setTimeout(function() {
            const selection = window.getSelection();
            const selectedText = selection.toString().trim();
            
            if (selectedText.length > 0) {
              const range = selection.getRangeAt(0);
              const rect = range.getBoundingClientRect();
              
              // Send selection data to Flutter
              window.flutter_inappwebview.callHandler('onTextSelected', {
                text: selectedText,
                x: rect.left + (rect.width / 2),
                y: rect.top,
                width: rect.width,
                height: rect.height
              });
            } else {
              // Text deselected
              window.flutter_inappwebview.callHandler('onTextDeselected');
            }
          }, 300);
        });
      })();
    ''';

    try {
      await webViewController!.evaluateJavascript(source: script);
      AppLogger.d('Text selection script injected');
    } catch (e) {
      AppLogger.e('Failed to inject script', e);
    }
  }

  // Handle text selection from JavaScript
  void handleTextSelected(Map data) {
    _selectionDebouncer?.cancel();

    _selectionDebouncer = Timer(const Duration(milliseconds: 500), () {
      final text = data['text'] as String;
      final x = (data['x'] as num).toDouble();
      final y = (data['y'] as num).toDouble();

      if (text.length < 3) {
        AppLogger.w('Selected text too short: ${text.length} chars');
        return;
      }

      if (text.length > 5000) {
        Get.snackbar(
          'Selection Too Long',
          'Please select less than 5000 characters',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
        return;
      }

      selectedText.value = SelectedTextEntity(
        text: text,
        positionX: x,
        positionY: y,
        selectedAt: DateTime.now(),
      );

      // Calculate bubble position
      bubblePosition.value = Offset(x, y - 60);
      showActionBubble.value = true;

      AppLogger.i('Text selected: ${text.length} characters');
    });
  }

  // Handle text deselection
  void handleTextDeselected() {
    _selectionDebouncer?.cancel();

    _selectionDebouncer = Timer(const Duration(milliseconds: 300), () {
      hideActionBubble();
    });
  }

  // Action Bubble Actions
  void onActionBubbleTapped() {
    if (selectedText.value != null) {
      AppLogger.i('Action bubble tapped');
      showActionBubble.value = false;
      aiActionController.openPromptSheet(selectedText.value!);
    }
  }

  void hideActionBubble() {
    showActionBubble.value = false;
    bubblePosition.value = null;
    AppLogger.d('Action bubble hidden');
  }

  // Navigation methods
  Future goBack() async {
    if (await webViewController?.canGoBack() ?? false) {
      await webViewController?.goBack();
    }
  }

  Future goForward() async {
    if (await webViewController?.canGoForward() ?? false) {
      await webViewController?.goForward();
    }
  }

  Future reload() async {
    await webViewController?.reload();
  }

  void loadUrl(String url) {
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }
    webViewController?.loadUrl(
      urlRequest: URLRequest(url: WebUri(url)),
    );
  }

  // Clear selection
  void clearSelection() async {
    await webViewController?.evaluateJavascript(
      source: 'window.getSelection().removeAllRanges();',
    );
    selectedText.value = null;
    hideActionBubble();
  }
}