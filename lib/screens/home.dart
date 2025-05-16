import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'settings_screen.dart';
import '../user_session.dart';
import '../main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static String routeName = 'Home';
  static String routePath = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Colores globales
  static const Color fondoColor = Color(0xFFFAF9F6);
  static const Color colorAzul = Color(0xFF3B9EE6);

  // Dimensiones
  static const double buttonSize = 85;
  static const double iconScale = 0.5;

  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    final session = Supabase.instance.client.auth.currentSession;
    print('Estado de la sesión: ${session != null ? 'Activa' : 'Inactiva'}');
    if (session != null) {
      print('ID del usuario: ${session.user.id}');
      print('Email del usuario: ${session.user.email}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: fondoColor,
        body: SafeArea(
          child: Center(
            child: Container(
              width: screenWidth > 500 ? 500 : screenWidth * 0.95,
              height: 730,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/images/Captura_de_pantalla_2025-05-12_a_las_13.01.48.png',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildButtonStack(
                    width: 200,
                    height: 330,
                    buttons: [
                      _ButtonConfig(
                        alignment: const AlignmentDirectional(-0.52, -0.82),
                        svgPath: 'assets/svg/map-pin-svgrepo-com.svg',
                        route: '/rutaPredefinidas',
                      ),
                      _ButtonConfig(
                        alignment: const AlignmentDirectional(0.1, 0.27),
                        svgPath: 'assets/svg/search-alt-1-svgrepo-com.svg',
                        route: '/mapa_interactivo',
                      ),
                    ],
                  ),
                  _buildButtonStack(
                    width: 300,
                    height: 350,
                    buttons: [
                      _ButtonConfig(
                        alignment: const AlignmentDirectional(-0.16, 0.07),
                        svgPath: 'assets/svg/present-svgrepo-com.svg',
                        route: '/allcoupons',
                      ),
                      _ButtonConfig(
                        alignment: const AlignmentDirectional(0.05, 1.2),
                        svgPath: 'assets/svg/settings-svgrepo-com.svg',
                        route: '/eventos',
                      ),
                      _ButtonConfig(
                        alignment: const AlignmentDirectional(0.3, -0.98),
                        svgPath: 'assets/svg/account-svgrepo-com.svg',
                        route: '/perfil',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonStack({
    required double width,
    required double height,
    required List<_ButtonConfig> buttons,
  }) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: buttons.map(_buildCircleButton).toList(),
      ),
    );
  }

  Widget _buildCircleButton(_ButtonConfig config) {
    return Align(
      alignment: config.alignment,
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: () async {
          if (config.svgPath == 'assets/svg/settings-svgrepo-com.svg') {
            try {
              final session = Supabase.instance.client.auth.currentSession;
              if (session != null) {
                print('Navegando a configuración con ID: ${session.user.id}');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SettingsScreen(userId: session.user.id),
                  ),
                );
              } else {
                print('No hay sesión activa');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Por favor, inicia sesión nuevamente.'),
                    duration: Duration(seconds: 2),
                  ),
                );
                // Redirigir al login si no hay sesión
                Navigator.pushReplacementNamed(context, '/login');
              }
            } catch (e) {
              print('Error al acceder a configuración: $e');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: ${e.toString()}'),
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          } else {
            Navigator.pushNamed(context, config.route);
          }
        },
        child: Container(
          width: buttonSize,
          height: buttonSize,
          decoration: const BoxDecoration(
            color: colorAzul,
            shape: BoxShape.circle,
          ),
          child: Transform.scale(
            scale: iconScale,
            child: SvgPicture.asset(config.svgPath),
          ),
        ),
      ),
    );
  }
}

class _ButtonConfig {
  final AlignmentDirectional alignment;
  final String svgPath;
  final String route;

  const _ButtonConfig({
    required this.alignment,
    required this.svgPath,
    required this.route,
  });
}
