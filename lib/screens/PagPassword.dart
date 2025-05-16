import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class PagPasswordWidget extends StatefulWidget {
  const PagPasswordWidget({super.key});

  @override
  State<PagPasswordWidget> createState() => _PagPasswordWidgetState();
}

class _PagPasswordWidgetState extends State<PagPasswordWidget> {
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false;
  bool _hasMinLength = false;
  bool _hasNumber = false;

  @override
  void dispose() {
    _passwordController.dispose(); // Libera el controlador cuando el widget se destruye
    super.dispose();
  }

  // Esta función valida las condiciones de la contraseña
  void _validatePassword(String value) {
    setState(() {
      // Verifica que la contraseña tenga al menos 6 caracteres
      _hasMinLength = value.length >= 6;

      // Verifica si la contraseña contiene al menos un número
      _hasNumber = RegExp(r'\d').hasMatch(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Asegura que el teclado no cubra el TextField
      backgroundColor: const Color(0xFFFAF9F6),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 24),
                Text(
                  'Restablece tu contraseña',
                  style: GoogleFonts.interTight(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF14448A),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Por favor introduzca su nueva contraseña',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    color: const Color(0xFF14448A),
                  ),
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: !_passwordVisible,
                    onChanged: _validatePassword, // Llamamos a la validación
                    autofocus: true, // Aseguramos que el TextField reciba foco automáticamente
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SvgPicture.asset(
                          'assets/svg/lockAzul.svg', // Este ícono no está afectado por las condiciones
                          width: 20,
                          height: 20,
                        ),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                      hintText: 'Introduce tu contraseña...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Color(0xFF3C9EE7)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Tu contraseña debe contener:',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    color: const Color(0xFF14448A),
                  ),
                ),
                const SizedBox(height: 12),
                // Primer icono (verifica si la longitud es suficiente)
                _buildPasswordRequirement(
                  fulfilled: _hasMinLength,
                  text: 'Al menos 6 caracteres.',
                  iconOpacity: _hasMinLength ? 1.0 : 0.3,  // Control de opacidad
                ),
                // Segundo icono (verifica si contiene al menos un número)
                _buildPasswordRequirement(
                  fulfilled: _hasNumber,
                  text: 'Al menos un número.',
                  iconOpacity: _hasNumber ? 1.0 : 0.3,  // Control de opacidad
                ),
                const SizedBox(height: 36),
                GestureDetector(
                  onTap: () {
                    if (_hasMinLength && _hasNumber) {
                      Navigator.pushReplacementNamed(context, '/home'); // Asegúrate de tener esta ruta configurada en tu MaterialApp
                    } else {
                      // Muestra un mensaje si las condiciones no se cumplen
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Por favor, asegúrate de cumplir con los requisitos de la contraseña.'),
                        ),
                      );
                    }
                  },
                  child: Container(
                    width: 180,
                    height: 45,
                    decoration: BoxDecoration(
                      color: (_hasMinLength && _hasNumber)
                          ? const Color(0xFF3C9EE7) // Color activo si las condiciones se cumplen
                          : const Color(0xFFB0C4DE), // Color desactivado si no se cumplen
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'HECHO',
                      style: GoogleFonts.inter(
                        color: const Color(0xFFFAF9F6),
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
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

  Widget _buildPasswordRequirement({required bool fulfilled, required String text, required double iconOpacity}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 4),
      child: Row(
        children: [
          Opacity(
            opacity: iconOpacity,  // Controlamos la opacidad del ícono
            child: SvgPicture.asset(
              'assets/images/tick-circle-naranja.svg', // Verifica si la ruta es correcta
              width: 24,
              height: 24,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: GoogleFonts.inter(
              color: const Color(0xFF14448A),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
