import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/ai_action/ai_action_controller.dart';
import 'prompt_chip_widget.dart';
import 'result_view_widget.dart';

class PromptBottomSheet extends StatelessWidget {
  const PromptBottomSheet({super.key});

  AIActionController get controller => Get.find<AIActionController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.showBottomSheet.value) return const SizedBox.shrink();

      return DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return Container(
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
                _buildHeader(context),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildPromptSelector(),
                        const SizedBox(height: 16),
                        _buildCustomPromptInput(),
                        const SizedBox(height: 16),
                        _buildResultView(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'AI Actions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: controller.closePromptSheet,
          ),
        ],
      ),
    );
  }

  Widget _buildPromptSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Action',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Obx(() => Wrap(
          spacing: 8,
          runSpacing: 8,
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
        )),
      ],
    );
  }

  Widget _buildCustomPromptInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Or Write Custom Instruction',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller.customPromptController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'e.g., "Summarize this for a presentation"',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: controller.submitCustomPrompt,
            icon: const Icon(Icons.send),
            label: const Text('Submit'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
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