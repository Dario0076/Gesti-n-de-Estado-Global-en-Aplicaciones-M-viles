import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/user.dart';
import '../riverpod/user_providers.dart';

class RiverpodDemoPage extends ConsumerWidget {
  const RiverpodDemoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riverpod Demo'),
        backgroundColor: Colors.purple.shade100,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showRiverpodInfo(context),
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
              color: Colors.purple.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.purple.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Riverpod Pattern',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '• Moderna y type-safe\n'
                  '• No requiere BuildContext\n'
                  '• Testeable por defecto\n'
                  '• Mejor manejo de dependencias',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          
          // Lista de usuarios
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                final userState = ref.watch(userNotifierProvider);
                
                // Cargar usuarios al inicio
                ref.listen(userNotifierProvider, (previous, next) {
                  if (previous?.users.isEmpty == true && next.users.isEmpty) {
                    ref.read(userNotifierProvider.notifier).loadUsers();
                  }
                });

                if (userState.isLoading && userState.users.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: Colors.purple),
                        SizedBox(height: 16),
                        Text('Cargando usuarios con Riverpod...'),
                      ],
                    ),
                  );
                }
                
                if (userState.errorMessage != null) {
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
                          'Error: ${userState.errorMessage}',
                          style: TextStyle(color: Colors.red.shade600),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            ref.read(userNotifierProvider.notifier).clearError();
                            ref.read(userNotifierProvider.notifier).loadUsers();
                          },
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  );
                }
                
                if (userState.users.isNotEmpty) {
                  return Stack(
                    children: [
                      RefreshIndicator(
                        onRefresh: () async {
                          await ref.read(userNotifierProvider.notifier).refreshUsers();
                        },
                        child: ListView.builder(
                          itemCount: userState.users.length,
                          itemBuilder: (context, index) {
                            final user = userState.users[index];
                            return UserTile(
                              user: user,
                              onTap: () => _navigateToUserDetail(context, user, ref),
                            );
                          },
                        ),
                      ),
                      if (userState.isLoading)
                        const Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: LinearProgressIndicator(color: Colors.purple),
                        ),
                    ],
                  );
                }
                
                // Estado inicial - cargar usuarios
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ref.read(userNotifierProvider.notifier).loadUsers();
                });
                
                return const Center(
                  child: Text('Inicializando...'),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Consumer(
        builder: (context, ref, child) {
          final isLoading = ref.watch(isLoadingProvider);
          
          return FloatingActionButton(
            backgroundColor: Colors.purple,
            onPressed: isLoading 
                ? null 
                : () {
                    ref.read(userNotifierProvider.notifier).refreshUsers();
                  },
            child: const Icon(Icons.refresh),
          );
        },
      ),
    );
  }

  void _navigateToUserDetail(BuildContext context, User user, WidgetRef ref) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserDetailRiverpodPage(user: user),
      ),
    );
  }

  void _showRiverpodInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Riverpod Pattern'),
        content: const Text(
          'Riverpod es la evolución de Provider con mejoras significativas:\n\n'
          '• Type-safe por diseño\n'
          '• No requiere BuildContext\n'
          '• Mejor testabilidad\n'
          '• Detección de errores en compile-time\n\n'
          'Ventajas:\n'
          '• Más seguro que Provider\n'
          '• Mejor DX (Developer Experience)\n'
          '• Auto-dispose de recursos\n'
          '• Ideal para apps complejas',
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

class UserDetailRiverpodPage extends ConsumerWidget {
  final User user;

  const UserDetailRiverpodPage({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.name),
        backgroundColor: Colors.purple.shade100,
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final userState = ref.watch(userNotifierProvider);
          
          // Cargar detalles del usuario al inicio
          ref.listen(userNotifierProvider, (previous, next) {
            if (next.selectedUser?.id != user.id) {
              ref.read(userNotifierProvider.notifier).loadUserById(user.id);
            }
          });

          if (userState.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.purple),
                  SizedBox(height: 16),
                  Text('Cargando detalles...'),
                ],
              ),
            );
          }
          
          if (userState.errorMessage != null) {
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
                    'Error: ${userState.errorMessage}',
                    style: TextStyle(color: Colors.red.shade600),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(userNotifierProvider.notifier).clearError();
                      ref.read(userNotifierProvider.notifier).loadUserById(user.id);
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }
          
          if (userState.selectedUser != null) {
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
                          _buildInfoRow('Nombre:', userState.selectedUser!.name),
                          _buildInfoRow('Email:', userState.selectedUser!.email),
                          _buildInfoRow('Teléfono:', userState.selectedUser!.phone),
                          if (userState.selectedUser!.website != null)
                            _buildInfoRow('Website:', userState.selectedUser!.website!),
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
                            'Posts (${userState.posts.length})',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 16),
                          ...userState.posts.map((post) => PostTile(post: post)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          
          // Estado inicial - cargar detalles
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.read(userNotifierProvider.notifier).loadUserById(user.id);
          });
          
          return const Center(
            child: Text('Inicializando...'),
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
          backgroundColor: Colors.purple.shade100,
          child: Text(
            user.name.substring(0, 1).toUpperCase(),
            style: TextStyle(
              color: Colors.purple.shade700,
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
