import 'package:flutter/foundation.dart';
import '../../core/models/user.dart';
import '../../core/usecases/usecase.dart';
import '../../domain/usecases/get_users.dart';

enum UserStateStatus { initial, loading, loaded, error, refreshing }

class UserProvider with ChangeNotifier {
  final GetUsers _getUsers;
  final GetUserById _getUserById;
  final GetPostsByUserId _getPostsByUserId;

  UserProvider({
    required GetUsers getUsers,
    required GetUserById getUserById,
    required GetPostsByUserId getPostsByUserId,
  })  : _getUsers = getUsers,
        _getUserById = getUserById,
        _getPostsByUserId = getPostsByUserId;

  UserStateStatus _status = UserStateStatus.initial;
  List<User> _users = [];
  User? _selectedUser;
  List<Post> _posts = [];
  String _errorMessage = '';

  // Getters
  UserStateStatus get status => _status;
  List<User> get users => _users;
  User? get selectedUser => _selectedUser;
  List<Post> get posts => _posts;
  String get errorMessage => _errorMessage;

  bool get isLoading => _status == UserStateStatus.loading;
  bool get isRefreshing => _status == UserStateStatus.refreshing;
  bool get hasError => _status == UserStateStatus.error;
  bool get hasData => _users.isNotEmpty;

  Future<void> loadUsers() async {
    _setStatus(UserStateStatus.loading);
    
    final result = await _getUsers(const NoParams());
    
    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _setStatus(UserStateStatus.error);
      },
      (users) {
        _users = users;
        _setStatus(UserStateStatus.loaded);
      },
    );
  }

  Future<void> loadUserById(int userId) async {
    _setStatus(UserStateStatus.loading);
    
    final userResult = await _getUserById(userId);
    
    await userResult.fold(
      (failure) async {
        _errorMessage = failure.message;
        _setStatus(UserStateStatus.error);
      },
      (user) async {
        _selectedUser = user;
        
        final postsResult = await _getPostsByUserId(userId);
        
        postsResult.fold(
          (failure) {
            _errorMessage = failure.message;
            _setStatus(UserStateStatus.error);
          },
          (posts) {
            _posts = posts;
            _setStatus(UserStateStatus.loaded);
          },
        );
      },
    );
  }

  Future<void> refreshUsers() async {
    if (_users.isNotEmpty) {
      _setStatus(UserStateStatus.refreshing);
    }
    
    final result = await _getUsers(const NoParams());
    
    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _setStatus(UserStateStatus.error);
      },
      (users) {
        _users = users;
        _setStatus(UserStateStatus.loaded);
      },
    );
  }

  void clearError() {
    _errorMessage = '';
    if (_users.isNotEmpty) {
      _setStatus(UserStateStatus.loaded);
    } else {
      _setStatus(UserStateStatus.initial);
    }
  }

  void _setStatus(UserStateStatus status) {
    _status = status;
    notifyListeners();
  }
}
