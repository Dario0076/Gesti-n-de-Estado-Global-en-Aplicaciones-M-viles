import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

import 'package:flutter_application_1/core/error/failures.dart';
import 'package:flutter_application_1/core/models/user.dart';
import 'package:flutter_application_1/core/usecases/usecase.dart';
import 'package:flutter_application_1/domain/usecases/get_users.dart';
import 'package:flutter_application_1/presentation/providers/user_provider.dart';

class MockGetUsers extends Mock implements GetUsers {}
class MockGetUserById extends Mock implements GetUserById {}
class MockGetPostsByUserId extends Mock implements GetPostsByUserId {}

void main() {
  late UserProvider userProvider;
  late MockGetUsers mockGetUsers;
  late MockGetUserById mockGetUserById;
  late MockGetPostsByUserId mockGetPostsByUserId;

  setUpAll(() {
    registerFallbackValue(const NoParams());
  });

  setUp(() {
    mockGetUsers = MockGetUsers();
    mockGetUserById = MockGetUserById();
    mockGetPostsByUserId = MockGetPostsByUserId();
    
    userProvider = UserProvider(
      getUsers: mockGetUsers,
      getUserById: mockGetUserById,
      getPostsByUserId: mockGetPostsByUserId,
    );
  });

  const tUser = User(
    id: 1,
    name: 'Test User',
    email: 'test@example.com',
    phone: '123-456-7890',
    website: 'test.com',
  );

  const tUserList = [tUser];

  const tPost = Post(
    id: 1,
    userId: 1,
    title: 'Test Post',
    body: 'Test Body',
  );

  const tPostList = [tPost];

  group('UserProvider', () {
    test('initial state should be correct', () {
      expect(userProvider.status, UserStateStatus.initial);
      expect(userProvider.users, isEmpty);
      expect(userProvider.selectedUser, isNull);
      expect(userProvider.posts, isEmpty);
      expect(userProvider.errorMessage, isEmpty);
      expect(userProvider.isLoading, false);
      expect(userProvider.isRefreshing, false);
      expect(userProvider.hasError, false);
      expect(userProvider.hasData, false);
    });

    group('loadUsers', () {
      test('should change status to loading', () async {
        // arrange
        when(() => mockGetUsers(any()))
            .thenAnswer((_) async => const Right(tUserList));

        // act
        final future = userProvider.loadUsers();
        
        // assert
        expect(userProvider.status, UserStateStatus.loading);
        expect(userProvider.isLoading, true);
        
        await future;
      });

      test('should load users successfully', () async {
        // arrange
        when(() => mockGetUsers(any()))
            .thenAnswer((_) async => const Right(tUserList));

        // act
        await userProvider.loadUsers();

        // assert
        expect(userProvider.status, UserStateStatus.loaded);
        expect(userProvider.users, tUserList);
        expect(userProvider.hasData, true);
        expect(userProvider.isLoading, false);
        verify(() => mockGetUsers(any())).called(1);
      });

      test('should handle error when loading users fails', () async {
        // arrange
        const errorMessage = 'Network Error';
        when(() => mockGetUsers(any()))
            .thenAnswer((_) async => const Left(NetworkFailure(errorMessage)));

        // act
        await userProvider.loadUsers();

        // assert
        expect(userProvider.status, UserStateStatus.error);
        expect(userProvider.errorMessage, errorMessage);
        expect(userProvider.hasError, true);
        expect(userProvider.isLoading, false);
        verify(() => mockGetUsers(any())).called(1);
      });
    });

    group('loadUserById', () {
      test('should load user and posts successfully', () async {
        // arrange
        when(() => mockGetUserById(any()))
            .thenAnswer((_) async => const Right(tUser));
        when(() => mockGetPostsByUserId(any()))
            .thenAnswer((_) async => const Right(tPostList));

        // act
        await userProvider.loadUserById(1);

        // assert
        expect(userProvider.status, UserStateStatus.loaded);
        expect(userProvider.selectedUser, tUser);
        expect(userProvider.posts, tPostList);
        expect(userProvider.isLoading, false);
        verify(() => mockGetUserById(1)).called(1);
        verify(() => mockGetPostsByUserId(1)).called(1);
      });

      test('should handle error when loading user fails', () async {
        // arrange
        const errorMessage = 'User not found';
        when(() => mockGetUserById(any()))
            .thenAnswer((_) async => const Left(NetworkFailure(errorMessage)));

        // act
        await userProvider.loadUserById(1);

        // assert
        expect(userProvider.status, UserStateStatus.error);
        expect(userProvider.errorMessage, errorMessage);
        expect(userProvider.hasError, true);
        expect(userProvider.isLoading, false);
        verify(() => mockGetUserById(1)).called(1);
        verifyNever(() => mockGetPostsByUserId(any()));
      });
    });

    group('refreshUsers', () {
      test('should refresh users successfully', () async {
        // arrange
        when(() => mockGetUsers(any()))
            .thenAnswer((_) async => const Right(tUserList));

        // act
        await userProvider.refreshUsers();
        
        // assert
        expect(userProvider.users, tUserList);
        verify(() => mockGetUsers(any())).called(1);
      });
    });

    group('clearError', () {
      test('should clear error', () {
        // act
        userProvider.clearError();

        // assert
        expect(userProvider.errorMessage, isEmpty);
        expect(userProvider.hasError, false);
      });
    });
  });
}
