import 'package:ai_action_flow/domain/entities/ai_prompt_entity.dart';

class PromptConstants {
  static const List<AIPromptEntity> defaultPrompts = [
    AIPromptEntity(
      id: 'improve_writing',
      title: 'Improve Writing',
      instruction: 'Improve the writing quality, grammar, and clarity of the following text while maintaining its original meaning',
      type: PromptType.improveWriting,
      icon: '✨',
    ),
    AIPromptEntity(
      id: 'summarize',
      title: 'Summarize',
      instruction: 'Provide a concise summary of the following text, capturing the main points',
      type: PromptType.summarize,
      icon: '📝',
    ),
    AIPromptEntity(
      id: 'rewrite',
      title: 'Rewrite',
      instruction: 'Rewrite the following text in a different way while preserving the original meaning',
      type: PromptType.rewrite,
      icon: '🔄',
    ),
    AIPromptEntity(
      id: 'simplify',
      title: 'Simplify',
      instruction: 'Simplify the following text to make it easier to understand',
      type: PromptType.simplify,
      icon: '💡',
    ),
    AIPromptEntity(
      id: 'plagiarism_check',
      title: 'Plagiarism Check',
      instruction: 'Analyze the following text for potential plagiarism or unoriginal content',
      type: PromptType.plagiarismCheck,
      icon: '🔍',
    ),
  ];
}