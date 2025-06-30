import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/usecases/usecase.dart';
import '../../domain/usecases/get_users.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUsers _getUsers;
  final GetUserById _getUserById;
  final GetPostsByUserId _getPostsByUserId;

  UserBloc({
    required GetUsers getUsers,
    required GetUserById getUserById,
    required GetPostsByUserId getPostsByUserId,
  })  : _getUsers = getUsers,
        _getUserById = getUserById,
        _getPostsByUserId = getPostsByUserId,
        super(const UserInitial()) {
    on<LoadUsers>(_onLoadUsers);
    on<LoadUserById>(_onLoadUserById);
    on<LoadPostsByUserId>(_onLoadPostsByUserId);
    on<RefreshUsers>(_onRefreshUsers);
  }

  Future<void> _onLoadUsers(LoadUsers event, Emitter<UserState> emit) async {
    emit(const UserLoading());
    
    final result = await _getUsers(const NoParams());
    
    result.fold(
      (failure) => emit(UserError(failure.message)),
      (users) => emit(UserLoaded(users)),
    );
  }

  Future<void> _onLoadUserById(LoadUserById event, Emitter<UserState> emit) async {
    emit(const UserLoading());
    
    final userResult = await _getUserById(event.userId);
    
    await userResult.fold(
      (failure) async => emit(UserError(failure.message)),
      (user) async {
        final postsResult = await _getPostsByUserId(event.userId);
        
        postsResult.fold(
          (failure) => emit(UserError(failure.message)),
          (posts) => emit(UserDetailLoaded(user: user, posts: posts)),
        );
      },
    );
  }

  Future<void> _onLoadPostsByUserId(LoadPostsByUserId event, Emitter<UserState> emit) async {
    final postsResult = await _getPostsByUserId(event.userId);
    
    postsResult.fold(
      (failure) => emit(UserError(failure.message)),
      (posts) {
        if (state is UserDetailLoaded) {
          final currentState = state as UserDetailLoaded;
          emit(UserDetailLoaded(user: currentState.user, posts: posts));
        }
      },
    );
  }

  Future<void> _onRefreshUsers(RefreshUsers event, Emitter<UserState> emit) async {
    if (state is UserLoaded) {
      final currentUsers = (state as UserLoaded).users;
      emit(UserRefreshing(currentUsers));
    }
    
    final result = await _getUsers(const NoParams());
    
    result.fold(
      (failure) => emit(UserError(failure.message)),
      (users) => emit(UserLoaded(users)),
    );
  }
}
