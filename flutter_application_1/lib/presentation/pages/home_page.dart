import 'package:flutter/material.dart';
import 'bloc_demo_page.dart';
import 'provider_demo_page.dart';
import 'riverpod_demo_page.dart';
import 'comparison_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Estado - Comparación'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Evaluación de Herramientas de Gestión de Estado',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            
            // Tarjeta de información
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Herramientas Implementadas:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const BulletPoint(text: 'Bloc Pattern - Separación completa de lógica'),
                    const BulletPoint(text: 'Provider - Simplicidad y facilidad de uso'),
                    const BulletPoint(text: 'Riverpod - Moderna y type-safe'),
                    const SizedBox(height: 16),
                    const Text(
                      'Características de la implementación:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const BulletPoint(text: 'Arquitectura limpia con separación de capas'),
                    const BulletPoint(text: 'Manejo de errores robusto'),
                    const BulletPoint(text: 'Casos de uso bien definidos'),
                    const BulletPoint(text: 'Inyección de dependencias'),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Botones de navegación
            ElevatedButton.icon(
              onPressed: () => _navigateToDemo(context, const BlocDemoPage()),
              icon: const Icon(Icons.architecture),
              label: const Text('Demo - Bloc Pattern'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
            
            const SizedBox(height: 16),
            
            ElevatedButton.icon(
              onPressed: () => _navigateToDemo(context, const ProviderDemoPage()),
              icon: const Icon(Icons.layers),
              label: const Text('Demo - Provider'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
            
            const SizedBox(height: 16),
            
            ElevatedButton.icon(
              onPressed: () => _navigateToDemo(context, const RiverpodDemoPage()),
              icon: const Icon(Icons.stream),
              label: const Text('Demo - Riverpod'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
            
            const SizedBox(height: 32),
            
            OutlinedButton.icon(
              onPressed: () => _navigateToDemo(context, const ComparisonPage()),
              icon: const Icon(Icons.compare),
              label: const Text('Comparación Detallada'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToDemo(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}

class BulletPoint extends StatelessWidget {
  final String text;

  const BulletPoint({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
