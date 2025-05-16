import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home.dart';

class SettingsScreen extends StatefulWidget {
  final String userId;
  const SettingsScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late Usuario _usuario;
  bool _loading = true;
  bool _saving = false;
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  final UsuarioService _usuarioService = UsuarioService();

  // Controladores
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidosController = TextEditingController();
  final TextEditingController _nombreUsuarioController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _dniController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();
  final TextEditingController _confirmarContrasenaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final usuario = await _usuarioService.getUsuarioPorAuthId(widget.userId);
    if (usuario != null) {
      setState(() {
        _usuario = usuario;
        _nombreController.text = usuario.nombre;
        _apellidosController.text = usuario.apellidos;
        _nombreUsuarioController.text = usuario.nombreUsuario;
        _telefonoController.text = usuario.telefono;
        _correoController.text = usuario.correo;
        _dniController.text = usuario.dni;
        _contrasenaController.text = usuario.contrasena;
        _confirmarContrasenaController.text = usuario.contrasena;
        _loading = false;
      });
    } else {
      setState(() {
        _loading = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se encontró el usuario.')),
        );
        Navigator.pop(context);
      });
    }
  }

  Future<bool> _verificarNombreUsuario(String nombreUsuario) async {
    if (nombreUsuario == _usuario.nombreUsuario) return true;
    
    try {
      final response = await Supabase.instance.client
          .from('usuario')
          .select('id')
          .eq('nombre_usuario', nombreUsuario)
          .maybeSingle();
      
      return response == null;
    } catch (e) {
      print('Error al verificar nombre de usuario: $e');
      return false;
    }
  }

  Future<void> _saveUser() async {
    if (!_formKey.currentState!.validate()) return;
    
    // Verificar si el nombre de usuario ya existe
    if (_nombreUsuarioController.text != _usuario.nombreUsuario) {
      final nombreUsuarioDisponible = await _verificarNombreUsuario(_nombreUsuarioController.text);
      if (!nombreUsuarioDisponible) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.orange[700], size: 28),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Nombre de usuario no disponible',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'El nombre de usuario "${_nombreUsuarioController.text}" ya está en uso.',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: const Color(0xFF666666),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Por favor, elige otro nombre de usuario.',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: const Color(0xFF666666),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _nombreUsuarioController.clear();
                    _nombreUsuarioController.text = _usuario.nombreUsuario;
                  },
                  child: Text(
                    'Entendido',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF3C9EE7),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            );
          },
        );
        return;
      }
    }

    setState(() => _saving = true);
    
    try {
      // Si se cambió la contraseña, actualizar en Supabase Auth primero
      if (_contrasenaController.text != _usuario.contrasena) {
        try {
          // Verificar que la nueva contraseña sea diferente
          if (_contrasenaController.text == _usuario.contrasena) {
            throw Exception('La nueva contraseña debe ser diferente a la actual');
          }

          final response = await Supabase.instance.client.auth.updateUser(
            UserAttributes(
              password: _contrasenaController.text,
            ),
          );
          
          if (response.user == null) {
            throw Exception('No se pudo actualizar la contraseña');
          }
          
          print('Contraseña actualizada en Supabase Auth');
        } catch (authError) {
          print('Error al actualizar contraseña en Supabase Auth: $authError');
          String mensajeError = 'No se pudo actualizar la contraseña.';
          String mensajeDetalle = 'Asegúrate de que la contraseña tenga al menos 6 caracteres.';

          if (authError.toString().contains('same_password')) {
            mensajeError = 'La nueva contraseña debe ser diferente a la actual.';
            mensajeDetalle = 'Por favor, elige una contraseña diferente.';
          }

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red[700], size: 28),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Error al actualizar contraseña',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mensajeError,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: const Color(0xFF666666),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      mensajeDetalle,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: const Color(0xFF666666),
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Entendido',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF3C9EE7),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
          setState(() => _saving = false);
          return;
        }
      }

      // Actualizar el resto de los datos del usuario
      final updated = _usuario.copyWith(
        nombre: _nombreController.text,
        apellidos: _apellidosController.text,
        nombreUsuario: _nombreUsuarioController.text,
        telefono: _telefonoController.text,
        correo: _correoController.text,
        dni: _dniController.text,
      );
      
      // Actualizar en la tabla de usuarios
      await _usuarioService.actualizarUsuario(updated);
      
      setState(() => _saving = false);
      
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                Icon(Icons.check_circle_outline, color: Colors.green[700], size: 28),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '¡Éxito!',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            content: Text(
              'Tus datos han sido actualizados correctamente.',
              style: GoogleFonts.inter(
                fontSize: 16,
                color: const Color(0xFF666666),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Entendido',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF3C9EE7),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Error al actualizar usuario: $e');
      setState(() => _saving = false);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red[700], size: 28),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Error al actualizar',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'No se pudieron actualizar tus datos.',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: const Color(0xFF666666),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Por favor, verifica que todos los campos sean correctos e inténtalo nuevamente.',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: const Color(0xFF666666),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Entendido',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF3C9EE7),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Header con esquinas redondeadas
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const SizedBox(width: 36),
                                Text(
                                  'Ajustes',
                                  style: GoogleFonts.inter(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF222222),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close_rounded, color: Color(0xFFBDBDBD), size: 28),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 45,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundImage: AssetImage('assets/images/login1.png'),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _nombreUsuarioController,
                              decoration: InputDecoration(
                                labelText: 'Nombre de usuario',
                                labelStyle: GoogleFonts.inter(color: const Color(0xFF3C9EE7)),
                                border: InputBorder.none,
                                filled: true,
                                fillColor: const Color(0xFFF5F5F5),
                                prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF3C9EE7)),
                              ),
                              style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600),
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'Campo obligatorio';
                                }
                                if (v.length < 3) {
                                  return 'El nombre de usuario debe tener al menos 3 caracteres';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      _buildEditableField('Nombre', _nombreController, icon: Icons.person),
                      _buildEditableField('Apellidos', _apellidosController, icon: Icons.person_outline),
                      _buildEditableField('Teléfono', _telefonoController, keyboard: TextInputType.phone, icon: Icons.phone),
                      _buildEditableField('Correo', _correoController, keyboard: TextInputType.emailAddress, icon: Icons.email),
                      _buildEditableField('DNI', _dniController, icon: Icons.badge, isOptional: true),
                      _buildPasswordField(),
                      _buildConfirmPasswordField(),
                      const SizedBox(height: 24),
                      _saving
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF7E1B),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 3,
                              ),
                              onPressed: _saveUser,
                              child: Text('Guardar cambios', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 16)),
                            ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller, {
    TextInputType keyboard = TextInputType.text,
    IconData? icon,
    bool isOptional = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: label + (isOptional ? ' (Opcional)' : ''),
          labelStyle: GoogleFonts.inter(color: const Color(0xFF3C9EE7)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF3C9EE7)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF3C9EE7)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFFF7E1B), width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: icon != null ? Icon(icon, color: const Color(0xFF3C9EE7)) : null,
        ),
        validator: isOptional ? null : (v) => v == null || v.isEmpty ? 'Campo obligatorio' : null,
      ),
    );
  }

  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: TextFormField(
        controller: _contrasenaController,
        obscureText: !_showPassword,
        decoration: InputDecoration(
          labelText: 'Contraseña',
          labelStyle: GoogleFonts.inter(color: const Color(0xFF3C9EE7)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF3C9EE7)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF3C9EE7)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFFF7E1B), width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF3C9EE7)),
          suffixIcon: IconButton(
            icon: Icon(
              _showPassword ? Icons.visibility_off : Icons.visibility,
              color: const Color(0xFF3C9EE7),
            ),
            onPressed: () {
              setState(() {
                _showPassword = !_showPassword;
              });
            },
          ),
          helperText: 'La contraseña debe tener al menos 6 caracteres',
          helperStyle: GoogleFonts.inter(color: const Color(0xFF666666)),
        ),
        validator: (v) {
          if (v == null || v.isEmpty) {
            return 'Campo obligatorio';
          }
          if (v.length < 6) {
            return 'La contraseña debe tener al menos 6 caracteres';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildConfirmPasswordField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: TextFormField(
        controller: _confirmarContrasenaController,
        obscureText: !_showConfirmPassword,
        decoration: InputDecoration(
          labelText: 'Confirmar contraseña',
          labelStyle: GoogleFonts.inter(color: const Color(0xFF3C9EE7)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF3C9EE7)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF3C9EE7)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFFF7E1B), width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF3C9EE7)),
          suffixIcon: IconButton(
            icon: Icon(
              _showConfirmPassword ? Icons.visibility_off : Icons.visibility,
              color: const Color(0xFF3C9EE7),
            ),
            onPressed: () {
              setState(() {
                _showConfirmPassword = !_showConfirmPassword;
              });
            },
          ),
        ),
        validator: (v) {
          if (v == null || v.isEmpty) {
            return 'Campo obligatorio';
          }
          if (v != _contrasenaController.text) {
            return 'Las contraseñas no coinciden';
          }
          return null;
        },
      ),
    );
  }
} 