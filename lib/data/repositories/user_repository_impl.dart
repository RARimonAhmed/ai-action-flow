// import 'package:dartz/dartz.dart';
// import '../../core/errors/exceptions.dart';
// import '../../core/errors/failures.dart';
// import '../../core/network/network_info.dart';
// import '../../domain/entities/user_entity.dart';
// import '../../domain/repositories/user_repository.dart';
// import '../models/user_model.dart';
// import '../providers/network/api_provider.dart';
// import '../providers/local/storage_provider.dart';
//
// class UserRepositoryImpl implements UserRepository {
//   final ApiProvider apiProvider;
//   final StorageProvider storageProvider;
//   final NetworkInfo networkInfo;
//
//   UserRepositoryImpl({
//     required this.apiProvider,
//     required this.storageProvider,
//     required this.networkInfo,
//   });
//
//   @override
//   Future<Either> login(
//       String email,
//       String password,
//       ) async {
//     if (!await networkInfo.isConnected) {
//       return const Left(NetworkFailure('No internet connection'));
//     }
//
//     try {
//       final response = await apiProvider.post(
//         '/auth/login',
//         data: {'email': email, 'password': password},
//       );
//
//       final user = UserModel.fromJson(response['data']);
//
//       // Save token
//       await storageProvider.write('token', response['token']);
//       await storageProvider.write('user', user.toJson());
//
//       return Right(user);
//     } on ServerException catch (e) {
//       return Left(ServerFailure(e.message));
//     } on NetworkException catch (e) {
//       return Left(NetworkFailure(e.message));
//     } catch (e) {
//       return Left(ServerFailure('Unexpected error occurred'));
//     }
//   }
//
//   @override
//   Future<Either> getUser(String id) async {
//     try {
//       // Try cache first
//       final cached = storageProvider.read<Map>('user');
//       if (cached != null) {
//         return Right(UserModel.fromJson(cached));
//       }
//
//       if (!await networkInfo.isConnected) {
//         return const Left(NetworkFailure('No internet connection'));
//       }
//
//       final response = await apiProvider.get('/users/$id');
//       final user = UserModel.fromJson(response['data']);
//
//       return Right(user);
//     } catch (e) {
//       return const Left(ServerFailure('Failed to get user'));
//     }
//   }
//
//   @override
//   Future<Either> logout() async {
//     try {
//       await storageProvider.clear();
//       return const Right(null);
//     } catch (e) {
//       return const Left(CacheFailure('Failed to logout'));
//     }
//   }
// }
