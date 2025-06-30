import 'package:flutter/material.dart';

class ComparisonPage extends StatefulWidget {
  const ComparisonPage({super.key});

  @override
  State<ComparisonPage> createState() => _ComparisonPageState();
}

class _ComparisonPageState extends State<ComparisonPage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comparación Detallada'),
        backgroundColor: Colors.orange.shade100,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Resumen'),
            Tab(text: 'Bloc'),
            Tab(text: 'Provider'),
            Tab(text: 'Riverpod'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSummaryTab(),
          _buildBlocTab(),
          _buildProviderTab(),
          _buildRiverpodTab(),
        ],
      ),
    );
  }

  Widget _buildSummaryTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Comparación de Herramientas de Gestión de Estado',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          
          // Tabla de comparación
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Comparación Rápida',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Table(
                    border: TableBorder.all(color: Colors.grey.shade300),
                    children: [
                      _buildTableRow(['Característica', 'Bloc', 'Provider', 'Riverpod'], isHeader: true),
                      _buildTableRow(['Curva de aprendizaje', 'Alta', 'Baja', 'Media']),
                      _buildTableRow(['Boilerplate', 'Alto', 'Bajo', 'Medio']),
                      _buildTableRow(['Testabilidad', 'Excelente', 'Buena', 'Excelente']),
                      _buildTableRow(['Performance', 'Excelente', 'Buena', 'Excelente']),
                      _buildTableRow(['Type Safety', 'Buena', 'Media', 'Excelente']),
                      _buildTableRow(['Escalabilidad', 'Excelente', 'Buena', 'Excelente']),
                      _buildTableRow(['Tamaño del equipo', 'Grande', 'Pequeño', 'Medio/Grande']),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Recomendaciones
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Recomendaciones de Uso',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildRecommendationCard(
                    'Bloc Pattern',
                    'Para aplicaciones empresariales grandes con equipos experimentados',
                    Colors.blue,
                    [
                      'Aplicaciones complejas con muchas pantallas',
                      'Equipos grandes con experiencia en Flutter',
                      'Cuando la testabilidad es prioritaria',
                      'Proyectos a largo plazo',
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildRecommendationCard(
                    'Provider',
                    'Para proyectos medianos con equipos pequeños',
                    Colors.green,
                    [
                      'Aplicaciones de tamaño medio',
                      'Equipos pequeños o desarrolladores júnior',
                      'Prototipado rápido',
                      'Migración desde setState',
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildRecommendationCard(
                    'Riverpod',
                    'Para aplicaciones modernas que buscan lo mejor de ambos mundos',
                    Colors.purple,
                    [
                      'Aplicaciones nuevas en Flutter',
                      'Cuando se busca type safety',
                      'Equipos que valoran la productividad',
                      'Aplicaciones con estado complejo',
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlocTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPatternHeader('Bloc Pattern', Colors.blue),
          
          _buildSection(
            'Características Principales',
            [
              'Separación completa entre UI y lógica de negocio',
              'Estados inmutables usando Equatable',
              'Eventos tipados para todas las acciones',
              'Stream-based para reactividad',
              'Patrón unidireccional de flujo de datos',
            ],
          ),
          
          _buildSection(
            'Ventajas',
            [
              'Extremadamente testeable',
              'Predecible y debuggeable',
              'Escalable para aplicaciones grandes',
              'Reutilizable entre plataformas',
              'Excelente separación de responsabilidades',
            ],
          ),
          
          _buildSection(
            'Desventajas',
            [
              'Curva de aprendizaje pronunciada',
              'Mucho código boilerplate',
              'Puede ser excesivo para apps simples',
              'Requiere comprensión de Streams',
            ],
          ),
          
          _buildCodeExample(
            'Estructura de Archivos',
            '''
lib/
  presentation/
    bloc/
      user_bloc.dart
      user_event.dart
      user_state.dart
  domain/
    usecases/
      get_users.dart
    repositories/
      user_repository.dart
  data/
    repositories/
      user_repository_impl.dart
    datasources/
      user_remote_data_source.dart
''',
          ),
        ],
      ),
    );
  }

  Widget _buildProviderTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPatternHeader('Provider Pattern', Colors.green),
          
          _buildSection(
            'Características Principales',
            [
              'Basado en InheritedWidget de Flutter',
              'ChangeNotifier para notificaciones de cambios',
              'Consumer para escuchar cambios',
              'Simplicidad y facilidad de uso',
              'Menos código que Bloc',
            ],
          ),
          
          _buildSection(
            'Ventajas',
            [
              'Fácil de aprender y usar',
              'Menos boilerplate',
              'Buena performance',
              'Ideal para equipos pequeños',
              'Transición natural desde setState',
            ],
          ),
          
          _buildSection(
            'Desventajas',
            [
              'Menos estructurado que Bloc',
              'Puede volverse difícil de mantener en apps grandes',
              'Testeo más complejo que Bloc',
              'Acoplamiento con BuildContext',
            ],
          ),
          
          _buildCodeExample(
            'Ejemplo de Uso',
            '''
class UserProvider extends ChangeNotifier {
  List<User> _users = [];
  bool _isLoading = false;
  
  List<User> get users => _users;
  bool get isLoading => _isLoading;
  
  Future<void> loadUsers() async {
    _isLoading = true;
    notifyListeners();
    
    // Lógica de carga
    _users = await userRepository.getUsers();
    _isLoading = false;
    notifyListeners();
  }
}
''',
          ),
        ],
      ),
    );
  }

  Widget _buildRiverpodTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPatternHeader('Riverpod Pattern', Colors.purple),
          
          _buildSection(
            'Características Principales',
            [
              'Evolución moderna de Provider',
              'Type-safe por diseño',
              'No requiere BuildContext',
              'Auto-dispose de recursos',
              'Mejor experiencia de desarrollo',
            ],
          ),
          
          _buildSection(
            'Ventajas',
            [
              'Más seguro que Provider',
              'Detección de errores en compile-time',
              'Excelente testabilidad',
              'Mejor manejo de dependencias',
              'Auto-dispose previene memory leaks',
            ],
          ),
          
          _buildSection(
            'Desventajas',
            [
              'Curva de aprendizaje media',
              'Relativamente nuevo en el ecosistema',
              'Requiere cambio de mentalidad desde Provider',
              'Documentación aún en evolución',
            ],
          ),
          
          _buildCodeExample(
            'Ejemplo de Provider',
            '''
final userNotifierProvider = 
    StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier(
    getUsers: ref.read(getUsersProvider),
  );
});

class UserNotifier extends StateNotifier<UserState> {
  UserNotifier({required this.getUsers}) : super(UserState());
  
  final GetUsers getUsers;
  
  Future<void> loadUsers() async {
    state = state.copyWith(isLoading: true);
    final users = await getUsers();
    state = state.copyWith(users: users, isLoading: false);
  }
}
''',
          ),
        ],
      ),
    );
  }

  Widget _buildPatternHeader(String title, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: color,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildSection(String title, List<String> items) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...items.map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(fontSize: 16)),
                  Expanded(child: Text(item)),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildCodeExample(String title, String code) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                code,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationCard(String title, String description, Color color, List<String> items) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: color,
            ),
          ),
          const SizedBox(height: 12),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• ', style: TextStyle(fontSize: 14, color: color)),
                Expanded(
                  child: Text(
                    item,
                    style: TextStyle(fontSize: 14, color: color),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  TableRow _buildTableRow(List<String> cells, {bool isHeader = false}) {
    return TableRow(
      children: cells.map((cell) => Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          cell,
          style: TextStyle(
            fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
            fontSize: isHeader ? 14 : 12,
          ),
          textAlign: TextAlign.center,
        ),
      )).toList(),
    );
  }
}
