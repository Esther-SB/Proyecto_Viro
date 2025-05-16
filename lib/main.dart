import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Páginas principales
import 'screens/cargando.dart';
import 'screens/pag_password.dart';
import 'screens/login.dart';
import 'screens/home.dart';
import 'screens/register.dart';

// Home - rutas directas
import 'screens/rutaPredefinidas.dart';
import 'screens/rutaPorLibre.dart';
import 'screens/allcoupons.dart';
import 'screens/eventos.dart';
import 'screens/perfil.dart';
import 'screens/mapa_interactivo.dart';

// Allcoupons - categorías
import 'screens/clinica.dart';
import 'screens/regalos.dart';
import 'screens/zapateria.dart';
import 'screens/joyeria.dart';
import 'screens/pasteleria.dart';
import 'screens/ropa.dart';

// Perfil - acciones
import 'screens/RutasDone.dart';
import 'screens/RegalosDone.dart';
import 'screens/amigos.dart';

import '../user_session.dart';

class UserSession {
  static String? userId;
}

final ValueNotifier<String?> userIdNotifier = ValueNotifier<String?>(null);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://iguucmatfbwtozdvbgxs.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlndXVjbWF0ZmJ3dG96ZHZiZ3hzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDcwNDc0MjUsImV4cCI6MjA2MjYyMzQyNX0.8cAlN6O9VzLCkpYbjnl1aOBACz3faw4qUV509Z3zIt4',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/inicio',
      theme: ThemeData(
        fontFamily: GoogleFonts.interTight().fontFamily,
        scaffoldBackgroundColor: const Color(0xFFF1F4F8),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF15448A)),
      ),
      routes: {
        '/inicio': (context) => const InicioWidget(),
        '/cargando': (context) => const CargandoWidget(),
        '/pag_password': (context) => const PagPasswordWidget(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),

        // Home > Accesos
        '/rutaPredefinidas': (context) => const RutapredefinidasWidget(),
        '/rutaPorLibre': (context) => const RutaporlibreWidget(),
        '/allcoupons': (context) => const AllcouponsWidget(),
        '/eventos': (context) => const EventosWidget(),
        '/perfil': (context) => const PerfilWidget(),
        '/mapa_interactivo': (context) => const MapaInteractivo(),

        // Allcoupons > Categorías
        '/clinica': (context) => const ClinicaWidget(),
        '/regalos': (context) => const RegalosWidget(),
        '/zapateria': (context) => const ZapateriaWidget(),
        '/joyeria': (context) => const JoyeriaWidget(),
        '/pasteleria': (context) => const PasteleriaWidget(),
        '/ropa': (context) => const RopaWidget(),

        // Perfil > Secciones
        '/RutasDone': (context) => const RutasDoneWidget(),
        '/RegalosDone': (context) => const RegalosdoneWidget(),
        '/Amigos': (context) => const AmigosWidget(),
      },
    );
  }
}

class InicioWidget extends StatelessWidget {
  const InicioWidget({super.key});

  static String routeName = 'Inicio';
  static String routePath = '/inicio';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Container(
                width: 390.7,
                height: 586.1,
                color: const Color(0xFFF1F4F8),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/images/logo1_transparent.png',
                        width: 342.6,
                        height: 236.5,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Align(
                      alignment: const Alignment(0, 0.52),
                      child: Image.asset(
                        'assets/images/tipografia2_VIRO.png',
                        width: 124,
                        height: 46.1,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/cargando');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF15448A),
                      minimumSize: const Size(260, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: Text(
                      '¿EMPEZAMOS?',
                      style: GoogleFonts.interTight(
                        color: Colors.white,
                        fontSize: 22,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

