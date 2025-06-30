import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../core/models/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  const UserRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<User>>> getUsers() async {
    try {
      final users = await remoteDataSource.getUsers();
      return Right(users);
    } catch (e) {
      return Left(NetworkFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getUserById(int id) async {
    try {
      final user = await remoteDataSource.getUserById(id);
      return Right(user);
    } catch (e) {
      return Left(NetworkFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Post>>> getPostsByUserId(int userId) async {
    try {
      final posts = await remoteDataSource.getPostsByUserId(userId);
      return Right(posts);
    } catch (e) {
      return Left(NetworkFailure(e.toString()));
    }
  }
}
