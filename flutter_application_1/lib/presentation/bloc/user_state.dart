import 'package:equatable/equatable.dart';
import '../../core/models/user.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {
  const UserInitial();
}

class UserLoading extends UserState {
  const UserLoading();
}

class UserLoaded extends UserState {
  final List<User> users;

  const UserLoaded(this.users);

  @override
  List<Object> get props => [users];
}

class UserDetailLoaded extends UserState {
  final User user;
  final List<Post> posts;

  const UserDetailLoaded({
    required this.user,
    required this.posts,
  });

  @override
  List<Object> get props => [user, posts];
}

class UserError extends UserState {
  final String message;

  const UserError(this.message);

  @override
  List<Object> get props => [message];
}

class UserRefreshing extends UserState {
  final List<User> users;

  const UserRefreshing(this.users);

  @override
  List<Object> get props => [users];
}
