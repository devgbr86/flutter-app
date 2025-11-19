import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'pages/home/home_page.dart';
import 'pages/dashboard/dashboard_page.dart';
import 'pages/cadastro/cadastro_page.dart';
import 'pages/buscar/buscar_page.dart';
import 'pages/historico/historico_page.dart';
import 'pages/listagem/listagem_page.dart';
import 'pages/config/config_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App Motoboy',
      theme: AppTheme.lightTheme,

      // Rota inicial
      initialRoute: '/',

      // Rotas do app
      routes: {
        '/': (context) => const HomePage(),
        '/dashboard': (context) => const DashboardPage(),
        '/cadastro': (context) => const CadastroPage(),
        '/buscar': (context) => const BuscarPage(),
        '/historico': (context) => const HistoricoPage(),
        '/listagem': (context) => const ListagemPage(),
        '/config': (context) => const ConfigPage(),
      },

      // Rota para páginas que não existem (fallback)
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: Text('Página ${settings.name}'),
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.construction,
                    size: 80,
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Página em Construção',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'A página "${settings.name}" ainda não foi criada.',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      'Voltar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
