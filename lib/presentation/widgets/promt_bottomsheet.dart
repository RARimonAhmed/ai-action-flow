import 'package:ai_action_flow/app/config/constants/app_images.dart';
import 'package:ai_action_flow/presentation/controllers/ai_action/ai_action_controller.dart';
import 'package:ai_action_flow/presentation/controllers/webview/webview_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'prompt_chip_widget.dart';
import 'result_view_widget.dart';

class PromptBottomSheet extends StatelessWidget {
  const PromptBottomSheet({super.key});

  AIActionController get controller => Get.find<AIActionController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.showBottomSheet.value) return const SizedBox.shrink();

      return GestureDetector(
        onTap: () {
          controller.closePromptSheet();
          _clearTextSelection();
        },
        behavior: HitTestBehavior.opaque,
        child: DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return GestureDetector(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildDragHandle(),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: scrollController,
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildCustomPromptInput(),
                              const SizedBox(height: 20),
                              _buildPromptSelector(),
                              const SizedBox(height: 20),
                              _buildActionButtons(),
                              const SizedBox(height: 16),
                              _buildResultView(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ));
            },
        ),
      );
    });
  }

  void _clearTextSelection() {
    final webViewController = Get.find<WebViewController>().webViewController;
    webViewController?.evaluateJavascript(source: """
      window.getSelection().removeAllRanges();
    """);
  }

  Widget _buildDragHandle() {
    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 8),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildCustomPromptInput() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.only(left: 20, top: 4, bottom: 4, right: 12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.customPromptController,
              decoration: const InputDecoration(
                hintText: 'Write a promt here...',
                hintStyle: TextStyle(
                  color: Color(0xFFAAAAAA),
                  fontSize: 16,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
              style: const TextStyle(fontSize: 16),
            ),
          ),
          IconButton(
            onPressed: controller.submitCustomPrompt,
            icon: Image.asset(AppImages.sendIcon, height: 25,)
          ),
        ],
      ),
    );
  }

  Widget _buildPromptSelector() {
    return Obx(() => Wrap(
      spacing: 12,
      runSpacing: 12,
      children: controller.availablePrompts.map((prompt) {
        final isSelected = controller.selectedPrompt.value?.id == prompt.id;
        return PromptChipWidget(
          title: prompt.title,
          icon: prompt.icon,
          isSelected: isSelected,
          onTap: () => controller.selectPrompt(prompt),
          onRemove: isSelected ? controller.removePrompt : null,
        );
      }).toList(),
    ));
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              // Insert action
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3485FF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Insert',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              // Replace action
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF3485FF),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: const BorderSide(
                color: Color(0xFF3485FF),
                width: 1.5,
              ),
            ),
            child: const Text(
              'Replace',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultView() {
    return Obx(() {
      final response = controller.currentResponse.value;
      if (response == null) return const SizedBox.shrink();

      return ResultViewWidget(
        response: response,
        onCopy: controller.copyResponse,
        onRegenerate: controller.regenerate,
      );
    });
  }
}