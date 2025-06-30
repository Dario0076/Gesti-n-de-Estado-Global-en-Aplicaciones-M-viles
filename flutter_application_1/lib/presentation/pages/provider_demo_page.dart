import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/user.dart';
import '../providers/user_provider.dart';
import '../di/injection_container.dart';

class ProviderDemoPage extends StatelessWidget {
  const ProviderDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => sl<UserProvider>()..loadUsers(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Provider Demo'),
          backgroundColor: Colors.green.shade100,
          actions: [
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () => _showProviderInfo(context),
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
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Provider Pattern',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '• Simplicidad y facilidad de uso\n'
                    '• ChangeNotifier para notificaciones\n'
                    '• Menos boilerplate que Bloc\n'
                    '• Ideal para proyectos medianos',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            
            // Lista de usuarios
            Expanded(
              child: Consumer<UserProvider>(
                builder: (context, userProvider, child) {
                  if (userProvider.isLoading && !userProvider.hasData) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: Colors.green),
                          SizedBox(height: 16),
                          Text('Cargando usuarios con Provider...'),
                        ],
                      ),
                    );
                  }
                  
                  if (userProvider.hasError) {
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
                            'Error: ${userProvider.errorMessage}',
                            style: TextStyle(color: Colors.red.shade600),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              userProvider.clearError();
                              userProvider.loadUsers();
                            },
                            child: const Text('Reintentar'),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  if (userProvider.hasData) {
                    return Stack(
                      children: [
                        RefreshIndicator(
                          onRefresh: () async {
                            await userProvider.refreshUsers();
                          },
                          child: ListView.builder(
                            itemCount: userProvider.users.length,
                            itemBuilder: (context, index) {
                              final user = userProvider.users[index];
                              return UserTile(
                                user: user,
                                onTap: () => _navigateToUserDetail(context, user),
                              );
                            },
                          ),
                        ),
                        if (userProvider.isRefreshing)
                          const Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: LinearProgressIndicator(color: Colors.green),
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
        floatingActionButton: Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            return FloatingActionButton(
              backgroundColor: Colors.green,
              onPressed: userProvider.isLoading 
                  ? null 
                  : () {
                      userProvider.refreshUsers();
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
        builder: (context) => ChangeNotifierProvider(
          create: (context) => sl<UserProvider>()..loadUserById(user.id),
          child: UserDetailProviderPage(user: user),
        ),
      ),
    );
  }

  void _showProviderInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Provider Pattern'),
        content: const Text(
          'Provider es una implementación del patrón InheritedWidget que facilita:\n\n'
          '• Gestión de estado simple y directa\n'
          '• ChangeNotifier para notificaciones\n'
          '• Consumer para recibir cambios\n'
          '• Menos código repetitivo\n\n'
          'Ventajas:\n'
          '• Fácil de aprender\n'
          '• Menos boilerplate\n'
          '• Buena performance\n'
          '• Ideal para equipos pequeños',
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

class UserDetailProviderPage extends StatelessWidget {
  final User user;

  const UserDetailProviderPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.name),
        backgroundColor: Colors.green.shade100,
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          if (userProvider.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.green),
                  SizedBox(height: 16),
                  Text('Cargando detalles...'),
                ],
              ),
            );
          }
          
          if (userProvider.hasError) {
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
                    'Error: ${userProvider.errorMessage}',
                    style: TextStyle(color: Colors.red.shade600),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      userProvider.clearError();
                      userProvider.loadUserById(user.id);
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }
          
          if (userProvider.selectedUser != null) {
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
                          _buildInfoRow('Nombre:', userProvider.selectedUser!.name),
                          _buildInfoRow('Email:', userProvider.selectedUser!.email),
                          _buildInfoRow('Teléfono:', userProvider.selectedUser!.phone),
                          if (userProvider.selectedUser!.website != null)
                            _buildInfoRow('Website:', userProvider.selectedUser!.website!),
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
                            'Posts (${userProvider.posts.length})',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 16),
                          ...userProvider.posts.map((post) => PostTile(post: post)),
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
          backgroundColor: Colors.green.shade100,
          child: Text(
            user.name.substring(0, 1).toUpperCase(),
            style: TextStyle(
              color: Colors.green.shade700,
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
