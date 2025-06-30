import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/user.dart';
import '../../core/usecases/usecase.dart';
import '../../domain/usecases/get_users.dart';
import '../di/injection_container.dart';

// Estados para Riverpod
class UserState {
  final List<User> users;
  final User? selectedUser;
  final List<Post> posts;
  final bool isLoading;
  final String? errorMessage;

  const UserState({
    this.users = const [],
    this.selectedUser,
    this.posts = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  UserState copyWith({
    List<User>? users,
    User? selectedUser,
    List<Post>? posts,
    bool? isLoading,
    String? errorMessage,
  }) {
    return UserState(
      users: users ?? this.users,
      selectedUser: selectedUser ?? this.selectedUser,
      posts: posts ?? this.posts,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// Notifier para manejar el estado
class UserNotifier extends StateNotifier<UserState> {
  final GetUsers _getUsers;
  final GetUserById _getUserById;
  final GetPostsByUserId _getPostsByUserId;

  UserNotifier({
    required GetUsers getUsers,
    required GetUserById getUserById,
    required GetPostsByUserId getPostsByUserId,
  })  : _getUsers = getUsers,
        _getUserById = getUserById,
        _getPostsByUserId = getPostsByUserId,
        super(const UserState());

  Future<void> loadUsers() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    
    final result = await _getUsers(const NoParams());
    
    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      ),
      (users) => state = state.copyWith(
        isLoading: false,
        users: users,
        errorMessage: null,
      ),
    );
  }

  Future<void> loadUserById(int userId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    
    final userResult = await _getUserById(userId);
    
    await userResult.fold(
      (failure) async {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
      (user) async {
        state = state.copyWith(selectedUser: user);
        
        final postsResult = await _getPostsByUserId(userId);
        
        postsResult.fold(
          (failure) => state = state.copyWith(
            isLoading: false,
            errorMessage: failure.message,
          ),
          (posts) => state = state.copyWith(
            isLoading: false,
            posts: posts,
            errorMessage: null,
          ),
        );
      },
    );
  }

  Future<void> refreshUsers() async {
    final result = await _getUsers(const NoParams());
    
    result.fold(
      (failure) => state = state.copyWith(errorMessage: failure.message),
      (users) => state = state.copyWith(users: users, errorMessage: null),
    );
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

// Providers
final userNotifierProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier(
    getUsers: sl<GetUsers>(),
    getUserById: sl<GetUserById>(),
    getPostsByUserId: sl<GetPostsByUserId>(),
  );
});

// Providers adicionales para casos específicos
final usersProvider = Provider<List<User>>((ref) {
  return ref.watch(userNotifierProvider).users;
});

final selectedUserProvider = Provider<User?>((ref) {
  return ref.watch(userNotifierProvider).selectedUser;
});

final postsProvider = Provider<List<Post>>((ref) {
  return ref.watch(userNotifierProvider).posts;
});

final isLoadingProvider = Provider<bool>((ref) {
  return ref.watch(userNotifierProvider).isLoading;
});

final errorMessageProvider = Provider<String?>((ref) {
  return ref.watch(userNotifierProvider).errorMessage;
});
