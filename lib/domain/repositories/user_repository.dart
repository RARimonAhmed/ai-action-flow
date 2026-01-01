import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/user_entity.dart';

abstract class UserRepository {
  Future<Either> login(String email, String password);
  Future<Either> getUser(String id);
  Future<Either> logout();
}