import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pag_password.dart';
import 'home.dart';
import 'register.dart';
import '../main.dart';
import '../services/user_service.dart';

Future<void> loginUser(
    BuildContext context, String username, String password) async {
  try {
    // Primero verificamos si el usuario existe en nuestra tabla de usuarios
    final response = await Supabase.instance.client
        .from('usuario')
        .select('id, correo')
        .eq('nombre_usuario', username)
        .maybeSingle();

    if (response == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario no encontrado.')),
      );
      return;
    }

    print('Usuario encontrado en la base de datos: ${response['correo']}');

    // Verificamos si el usuario existe en Supabase Auth
    try {
      final authResponse = await Supabase.instance.client.auth.signInWithPassword(
        email: response['correo'],
        password: password,
      );

      if (authResponse.user != null) {
        print('Inicio de sesión exitoso para: ${authResponse.user!.email}');
        print('ID de usuario: ${authResponse.user!.id}');
        
        // Verificamos que la sesión se haya guardado
        final session = Supabase.instance.client.auth.currentSession;
        if (session != null) {
          print('Sesión guardada correctamente');
          print('Token de sesión: ${session.accessToken}');
          
          // Actualizamos el auth_id en la base de datos
          try {
            final service = UsuarioService();
            await service.actualizarAuthId(response['id'].toString(), authResponse.user!.id);
            print('auth_id actualizado en la base de datos');
          } catch (updateError) {
            print('Error al actualizar auth_id: $updateError');
          }
          
          // Actualizamos el estado global
          UserSession.userId = authResponse.user!.id;
          userIdNotifier.value = authResponse.user!.id;
          
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          print('Error: No se pudo obtener la sesión después del login');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al iniciar sesión. Por favor, intente nuevamente.')),
          );
        }
      }
    } catch (authError) {
      print('Error de autenticación: $authError');
      
      // Si el error es de credenciales inválidas
      if (authError.toString().contains('invalid_credentials')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Credenciales inválidas. Por favor, verifica tu usuario y contraseña.'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${authError.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  } catch (e, stacktrace) {
    print('Error durante el inicio de sesión: $e');
    print('Stacktrace: $stacktrace');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${e.toString()}')),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  bool isPasswordVisible = false;
  bool showPasswordField = false;

  @override
  void initState() {
    super.initState();

    // Si se enfoca el campo de usuario, vuelve login1.png
    usernameFocusNode.addListener(() {
      if (usernameFocusNode.hasFocus) {
        setState(() {
          showPasswordField = false;
        });
      }
    });
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    usernameFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const baseColor = Color(0xFFFAF9F6);
    const blueLight = Color(0xFF3C9EE7);
    const blueDark = Color(0xFF14448A);
    const orange = Color(0xFFFF7E1B);

    return Scaffold(
      backgroundColor: baseColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: blueLight),
          onPressed: () => Navigator.pushReplacementNamed(context, '/inicio'),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Imagen dinámica
                Image.asset(
                  showPasswordField
                      ? 'assets/images/login2.png'
                      : 'assets/images/login1.png',
                  width: 300,
                  height: 300,
                ),
                const SizedBox(height: 32),

                // Campo de usuario
                GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(usernameFocusNode);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: blueLight),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        const Icon(Icons.account_circle_outlined, color: blueLight),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: usernameController,
                            focusNode: usernameFocusNode,
                            decoration: const InputDecoration(
                              hintText: 'Escribe tu nombre de usuario...',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Botón contraseña o campo
                if (!showPasswordField)
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        showPasswordField = true;
                      });
                    },
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: blueLight,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.lock_outline, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'CONTRASEÑA',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: blueLight),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        const Icon(Icons.lock, color: blueLight),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: passwordController,
                            focusNode: passwordFocusNode,
                            obscureText: !isPasswordVisible,
                            decoration: InputDecoration(
                              hintText: 'Escribe tu contraseña...',
                              border: InputBorder.none,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isPasswordVisible = !isPasswordVisible;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 16),

                // Recuperación de contraseña
                Column(
                  children: [
                    const Text(
                      '¿Has olvidado tu contraseña?',
                      style: TextStyle(
                        color: blueLight,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/pag_password');
                      },
                      child: const Text(
                        'CLICK AQUÍ',
                        style: TextStyle(
                          color: blueDark,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Botón ENTRAR
                GestureDetector(
                  onTap: () async {
                    final username = usernameController.text;
                    final password = passwordController.text;

                    await loginUser(context, username, password);
                  },
                  child: Container(
                    width: 180,
                    height: 40,
                    decoration: BoxDecoration(
                      color: orange,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 4,
                          color: Colors.black26,
                          offset: Offset(0, 2),
                        )
                      ],
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Entrar',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Botón de registro
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: Container(
                    width: 180,
                    height: 40,
                    decoration: BoxDecoration(
                      color: blueLight,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 4,
                          color: Colors.black26,
                          offset: Offset(0, 2),
                        )
                      ],
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Registrarse',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
