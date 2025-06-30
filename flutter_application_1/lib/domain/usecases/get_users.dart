import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../core/models/user.dart';
import '../../core/usecases/usecase.dart';
import '../repositories/user_repository.dart';

class GetUsers implements UseCase<List<User>, NoParams> {
  final UserRepository repository;

  const GetUsers(this.repository);

  @override
  Future<Either<Failure, List<User>>> call(NoParams params) async {
    return await repository.getUsers();
  }
}

class GetUserById implements UseCase<User, int> {
  final UserRepository repository;

  const GetUserById(this.repository);

  @override
  Future<Either<Failure, User>> call(int userId) async {
    return await repository.getUserById(userId);
  }
}

class GetPostsByUserId implements UseCase<List<Post>, int> {
  final UserRepository repository;

  const GetPostsByUserId(this.repository);

  @override
  Future<Either<Failure, List<Post>>> call(int userId) async {
    return await repository.getPostsByUserId(userId);
  }
}
