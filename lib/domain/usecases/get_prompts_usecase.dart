import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/ai_prompt_entity.dart';
import '../repositories/ai_repository.dart';

class GetPromptsUseCase {
  final AIRepository repository;

  GetPromptsUseCase(this.repository);

  Future<Either>> call() async {
    return await repository.getAvailablePrompts();
  }
}