import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/entities/ai_response_entity.dart';

class ResultViewWidget extends StatelessWidget {
  final AIResponseEntity response;
  final VoidCallback onCopy;
  final VoidCallback? onRegenerate;

  const ResultViewWidget({
    super.key,
    required this.response,
    required this.onCopy,
    this.onRegenerate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 400),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Status indicator
          if (response.status == ResponseStatus.loading)
            _buildLoadingIndicator()
          else if (response.status == ResponseStatus.error)
            _buildErrorView(context)
          else
            _buildSuccessView(context),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            'Generating response...',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red.shade700),
              const SizedBox(width: 8),
              Text(
                'Error',
                style: TextStyle(
                  color: Colors.red.shade700,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            response.errorMessage ?? 'An error occurred',
            style: TextStyle(
              color: Colors.red.shade900,
              fontSize: 14,
            ),
          ),
          if (onRegenerate != null) ...[
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: onRegenerate,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSuccessView(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (onRegenerate != null)
                IconButton(
                  onPressed: onRegenerate,
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Regenerate',
                ),
              IconButton(
                onPressed: () {
                  Clipboard.setData(
                    ClipboardData(text: response.generatedText),
                  );
                  onCopy();
                },
                icon: const Icon(Icons.copy),
                tooltip: 'Copy',
              ),
            ],
          ),

          // Generated text
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: SelectableText(
                response.generatedText,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.5,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}