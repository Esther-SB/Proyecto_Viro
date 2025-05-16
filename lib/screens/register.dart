import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nombreController = TextEditingController();
  final nombreUsuarioController = TextEditingController();
  final apellidosController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final telefonoController = TextEditingController();

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  @override
  void dispose() {
    nombreController.dispose();
    nombreUsuarioController.dispose();
    apellidosController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    telefonoController.dispose();
    super.dispose();
  }

  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool isValidPhone(String phone) {
    return RegExp(r'^[0-9]{9}$').hasMatch(phone);
  }

  bool isValidName(String name) {
    return name.length >= 2 && RegExp(r'^[a-zA-ZÀ-ÿ\s]{2,}$').hasMatch(name);
  }

  bool isValidUsername(String username) {
    return username.length >= 3 && RegExp(r'^[a-zA-Z0-9_]{3,}$').hasMatch(username);
  }

  Future<void> registerUser(BuildContext context) async {
    try {
      final email = emailController.text;
      final password = passwordController.text;
      final confirmPassword = confirmPasswordController.text;
      final nombre = nombreController.text;
      final nombreUsuario = nombreUsuarioController.text;
      final apellidos = apellidosController.text;
      final telefono = telefonoController.text;

      // Validaciones básicas
      if (email.isEmpty || password.isEmpty || nombre.isEmpty || 
          nombreUsuario.isEmpty || apellidos.isEmpty || telefono.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, complete todos los campos')),
        );
        return;
      }

      // Validación de email
      if (!isValidEmail(email)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, introduce un email válido')),
        );
        return;
      }

      // Validación de nombre de usuario
      if (!isValidUsername(nombreUsuario)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('El nombre de usuario debe tener al menos 3 caracteres y solo puede contener letras, números y guiones bajos')),
        );
        return;
      }

      // Validación de nombre
      if (!isValidName(nombre)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('El nombre debe contener al menos 2 caracteres y solo letras')),
        );
        return;
      }

      // Validación de apellidos
      if (!isValidName(apellidos)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Los apellidos deben contener al menos 2 caracteres y solo letras')),
        );
        return;
      }

      // Validación de teléfono
      if (!isValidPhone(telefono)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('El teléfono debe contener 9 dígitos')),
        );
        return;
      }

      // Validación de contraseña
      if (password.length < 6) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('La contraseña debe tener al menos 6 caracteres')),
        );
        return;
      }

      if (password != confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Las contraseñas no coinciden')),
        );
        return;
      }

      // Verificar si el correo ya existe
      final existingUser = await Supabase.instance.client
          .from('usuario')
          .select()
          .eq('correo', email)
          .maybeSingle();

      if (existingUser != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Este correo ya está registrado')),
        );
        return;
      }

      // Verificar si el nombre de usuario ya existe
      final existingUsername = await Supabase.instance.client
          .from('usuario')
          .select()
          .eq('nombre_usuario', nombreUsuario)
          .maybeSingle();

      if (existingUsername != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Este nombre de usuario ya está en uso')),
        );
        return;
      }

      // Insertar el nuevo usuario con la estructura correcta de la tabla
      final response = await Supabase.instance.client.from('usuario').insert({
        'nombre_usuario': nombreUsuario,
        'nombre': nombre,
        'apellidos': apellidos,
        'correo': email,
        'contraseña': password,
        'telefono': telefono,
      }).select();

      if (response != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registro exitoso')),
        );
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      print('Error en el registro: $e');
      
      // Manejar el error específico de correo duplicado
      if (e.toString().contains('usuario_correo_key')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Este correo electrónico ya está registrado. Por favor, usa otro.'),
            backgroundColor: Colors.red,
          ),
        );
      } else if (e.toString().contains('usuario_nombre_usuario_key')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Este nombre de usuario ya está en uso. Por favor, elige otro.'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error en el registro: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
        title: Column(
          children: [
            const Text(
              'Registro',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              DateTime.now().toString().split(' ')[0],
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ],
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/login1.png',
                  width: 200,
                  height: 200,
                ),
                const SizedBox(height: 32),

                // Campo de nombre de usuario
                _buildTextField(
                  controller: nombreUsuarioController,
                  icon: Icons.account_circle_outlined,
                  hintText: 'Nombre de usuario',
                ),
                const SizedBox(height: 16),

                // Campo de nombre
                _buildTextField(
                  controller: nombreController,
                  icon: Icons.person_outline,
                  hintText: 'Nombre',
                ),
                const SizedBox(height: 16),

                // Campo de apellidos
                _buildTextField(
                  controller: apellidosController,
                  icon: Icons.person_outline,
                  hintText: 'Apellidos',
                ),
                const SizedBox(height: 16),

                // Campo de email
                _buildTextField(
                  controller: emailController,
                  icon: Icons.email_outlined,
                  hintText: 'Email',
                ),
                const SizedBox(height: 16),

                // Campo de teléfono
                _buildTextField(
                  controller: telefonoController,
                  icon: Icons.phone_outlined,
                  hintText: 'Teléfono',
                ),
                const SizedBox(height: 16),

                // Campo de contraseña
                _buildPasswordField(
                  controller: passwordController,
                  isPasswordVisible: isPasswordVisible,
                  onToggleVisibility: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Campo de confirmar contraseña
                _buildPasswordField(
                  controller: confirmPasswordController,
                  isPasswordVisible: isConfirmPasswordVisible,
                  onToggleVisibility: () {
                    setState(() {
                      isConfirmPasswordVisible = !isConfirmPasswordVisible;
                    });
                  },
                  hintText: 'Confirmar contraseña',
                ),
                const SizedBox(height: 32),

                // Botón de registro
                GestureDetector(
                  onTap: () => registerUser(context),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String hintText,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF3C9EE7)),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF3C9EE7)),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required bool isPasswordVisible,
    required VoidCallback onToggleVisibility,
    String hintText = 'Contraseña',
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF3C9EE7)),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          const Icon(Icons.lock, color: Color(0xFF3C9EE7)),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: !isPasswordVisible,
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
                suffixIcon: IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: onToggleVisibility,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 