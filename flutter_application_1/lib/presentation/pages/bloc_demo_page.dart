import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/models/user.dart';
import '../bloc/user_bloc.dart';
import '../bloc/user_event.dart';
import '../bloc/user_state.dart';
import '../di/injection_container.dart';

class BlocDemoPage extends StatelessWidget {
  const BlocDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<UserBloc>()..add(const LoadUsers()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Bloc Pattern Demo'),
          backgroundColor: Colors.blue.shade100,
          actions: [
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () => _showBlocInfo(context),
            ),
          ],
        ),
        body: Column(
          children: [
            // Header informativo
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Arquitectura Bloc',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '• Separación completa de lógica de negocio\n'
                    '• Estados inmutables con Equatable\n'
                    '• Eventos tipados para acciones\n'
                    '• Flujo reactivo con Streams',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            
            // Lista de usuarios
            Expanded(
              child: BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  if (state is UserLoading) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Cargando usuarios con Bloc...'),
                        ],
                      ),
                    );
                  }
                  
                  if (state is UserError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 48,
                            color: Colors.red.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error: ${state.message}',
                            style: TextStyle(color: Colors.red.shade600),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.read<UserBloc>().add(const LoadUsers());
                            },
                            child: const Text('Reintentar'),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  if (state is UserLoaded) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<UserBloc>().add(const RefreshUsers());
                      },
                      child: ListView.builder(
                        itemCount: state.users.length,
                        itemBuilder: (context, index) {
                          final user = state.users[index];
                          return UserTile(
                            user: user,
                            onTap: () => _navigateToUserDetail(context, user),
                          );
                        },
                      ),
                    );
                  }
                  
                  if (state is UserRefreshing) {
                    return Stack(
                      children: [
                        ListView.builder(
                          itemCount: state.users.length,
                          itemBuilder: (context, index) {
                            final user = state.users[index];
                            return UserTile(
                              user: user,
                              onTap: () => _navigateToUserDetail(context, user),
                            );
                          },
                        ),
                        const Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: LinearProgressIndicator(),
                        ),
                      ],
                    );
                  }
                  
                  return const Center(
                    child: Text('Estado inicial'),
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            return FloatingActionButton(
              onPressed: state is UserLoading 
                  ? null 
                  : () {
                      context.read<UserBloc>().add(const RefreshUsers());
                    },
              child: const Icon(Icons.refresh),
            );
          },
        ),
      ),
    );
  }

  void _navigateToUserDetail(BuildContext context, User user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => sl<UserBloc>()..add(LoadUserById(user.id)),
          child: UserDetailPage(user: user),
        ),
      ),
    );
  }

  void _showBlocInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bloc Pattern'),
        content: const Text(
          'El patrón Bloc separa completamente la lógica de negocio de la UI mediante:\n\n'
          '• Events: Acciones que pueden ocurrir\n'
          '• States: Estados de la aplicación\n'
          '• Bloc: Lógica que transforma eventos en estados\n\n'
          'Ventajas:\n'
          '• Testeable\n'
          '• Predecible\n'
          '• Reutilizable\n'
          '• Escalable',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}

class UserDetailPage extends StatelessWidget {
  final User user;

  const UserDetailPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.name),
        backgroundColor: Colors.blue.shade100,
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Cargando detalles...'),
                ],
              ),
            );
          }
          
          if (state is UserError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Colors.red.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    style: TextStyle(color: Colors.red.shade600),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<UserBloc>().add(LoadUserById(user.id));
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }
          
          if (state is UserDetailLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Información del usuario
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Información del Usuario',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 16),
                          _buildInfoRow('Nombre:', state.user.name),
                          _buildInfoRow('Email:', state.user.email),
                          _buildInfoRow('Teléfono:', state.user.phone),
                          if (state.user.website != null)
                            _buildInfoRow('Website:', state.user.website!),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Posts del usuario
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Posts (${state.posts.length})',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 16),
                          ...state.posts.map((post) => PostTile(post: post)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          
          return const Center(
            child: Text('Cargando...'),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

class UserTile extends StatelessWidget {
  final User user;
  final VoidCallback onTap;

  const UserTile({
    super.key,
    required this.user,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: Text(
            user.name.substring(0, 1).toUpperCase(),
            style: TextStyle(
              color: Colors.blue.shade700,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(user.name),
        subtitle: Text(user.email),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class PostTile extends StatelessWidget {
  final Post post;

  const PostTile({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              post.body,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
