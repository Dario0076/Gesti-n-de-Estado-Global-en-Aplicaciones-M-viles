import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../core/models/user.dart';

abstract class UserRepository {
  Future<Either<Failure, List<User>>> getUsers();
  Future<Either<Failure, User>> getUserById(int id);
  Future<Either<Failure, List<Post>>> getPostsByUserId(int userId);
}
