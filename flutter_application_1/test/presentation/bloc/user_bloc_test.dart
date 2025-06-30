import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_application_1/core/error/failures.dart';
import 'package:flutter_application_1/core/models/user.dart';
import 'package:flutter_application_1/core/usecases/usecase.dart';
import 'package:flutter_application_1/domain/usecases/get_users.dart';
import 'package:flutter_application_1/presentation/bloc/user_bloc.dart';
import 'package:flutter_application_1/presentation/bloc/user_event.dart';
import 'package:flutter_application_1/presentation/bloc/user_state.dart';

class MockGetUsers extends Mock implements GetUsers {}
class MockGetUserById extends Mock implements GetUserById {}
class MockGetPostsByUserId extends Mock implements GetPostsByUserId {}

void main() {
  late UserBloc userBloc;
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
    
    userBloc = UserBloc(
      getUsers: mockGetUsers,
      getUserById: mockGetUserById,
      getPostsByUserId: mockGetPostsByUserId,
    );
  });

  tearDown(() {
    userBloc.close();
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

  group('UserBloc', () {
    test('initial state should be UserInitial', () {
      expect(userBloc.state, equals(const UserInitial()));
    });

    group('LoadUsers', () {
      blocTest<UserBloc, UserState>(
        'should emit [UserLoading, UserLoaded] when data is gotten successfully',
        build: () {
          when(() => mockGetUsers(any()))
              .thenAnswer((_) async => const Right(tUserList));
          return userBloc;
        },
        act: (bloc) => bloc.add(const LoadUsers()),
        expect: () => [
          const UserLoading(),
          const UserLoaded(tUserList),
        ],
        verify: (_) {
          verify(() => mockGetUsers(const NoParams()));
        },
      );

      blocTest<UserBloc, UserState>(
        'should emit [UserLoading, UserError] when getting data fails',
        build: () {
          when(() => mockGetUsers(any()))
              .thenAnswer((_) async => const Left(NetworkFailure('Network Error')));
          return userBloc;
        },
        act: (bloc) => bloc.add(const LoadUsers()),
        expect: () => [
          const UserLoading(),
          const UserError('Network Error'),
        ],
        verify: (_) {
          verify(() => mockGetUsers(const NoParams()));
        },
      );
    });

    group('LoadUserById', () {
      blocTest<UserBloc, UserState>(
        'should emit [UserLoading, UserDetailLoaded] when data is gotten successfully',
        build: () {
          when(() => mockGetUserById(any()))
              .thenAnswer((_) async => const Right(tUser));
          when(() => mockGetPostsByUserId(any()))
              .thenAnswer((_) async => const Right(tPostList));
          return userBloc;
        },
        act: (bloc) => bloc.add(const LoadUserById(1)),
        expect: () => [
          const UserLoading(),
          const UserDetailLoaded(user: tUser, posts: tPostList),
        ],
        verify: (_) {
          verify(() => mockGetUserById(1));
          verify(() => mockGetPostsByUserId(1));
        },
      );

      blocTest<UserBloc, UserState>(
        'should emit [UserLoading, UserError] when getting user fails',
        build: () {
          when(() => mockGetUserById(any()))
              .thenAnswer((_) async => const Left(NetworkFailure('User Not Found')));
          return userBloc;
        },
        act: (bloc) => bloc.add(const LoadUserById(1)),
        expect: () => [
          const UserLoading(),
          const UserError('User Not Found'),
        ],
        verify: (_) {
          verify(() => mockGetUserById(1));
          verifyNever(() => mockGetPostsByUserId(any()));
        },
      );
    });

    group('RefreshUsers', () {
      blocTest<UserBloc, UserState>(
        'should emit [UserRefreshing, UserLoaded] when refresh is successful',
        build: () {
          when(() => mockGetUsers(any()))
              .thenAnswer((_) async => const Right(tUserList));
          return userBloc;
        },
        seed: () => const UserLoaded(tUserList),
        act: (bloc) => bloc.add(const RefreshUsers()),
        expect: () => [
          const UserRefreshing(tUserList),
          const UserLoaded(tUserList),
        ],
        verify: (_) {
          verify(() => mockGetUsers(const NoParams()));
        },
      );
    });
  });
}
