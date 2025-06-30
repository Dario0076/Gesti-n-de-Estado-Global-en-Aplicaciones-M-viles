import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class LoadUsers extends UserEvent {
  const LoadUsers();
}

class LoadUserById extends UserEvent {
  final int userId;

  const LoadUserById(this.userId);

  @override
  List<Object> get props => [userId];
}

class LoadPostsByUserId extends UserEvent {
  final int userId;

  const LoadPostsByUserId(this.userId);

  @override
  List<Object> get props => [userId];
}

class RefreshUsers extends UserEvent {
  const RefreshUsers();
}
