import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logging/logging.dart';

final _logger = Logger('PagPasswordWidget');

class PagPasswordWidget extends StatefulWidget {
  const PagPasswordWidget({super.key});

  @override
  State<PagPasswordWidget> createState() => _PagPasswordWidgetState();
}

class _PagPasswordWidgetState extends State<PagPasswordWidget> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false;
  bool _hasMinLength = false;
  bool _hasNumber = false;
  bool _isLoading = false;
  bool _isResetEmailSent = false;
  bool _isTokenValid = false;
  String? _token;

  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _checkToken() async {
    final uri = Uri.base;
    final token = uri.queryParameters['token'];
    final type = uri.queryParameters['type'];
    final accessToken = uri.queryParameters['access_token'];

    _logger.info('Verificando parámetros de URL...');
    if ((token != null || accessToken != null) && type == 'recovery') {
      setState(() {
        _token = token ?? accessToken;
        _isTokenValid = true;
      });
    }
  }

  void _validatePassword(String value) {
    setState(() {
      _hasMinLength = value.length >= 6;
      _hasNumber = RegExp(r'\d').hasMatch(value);
    });
  }

  Future<void> _sendResetEmail() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, introduce tu correo electrónico'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await Supabase.instance.client.auth.resetPasswordForEmail(
        email,
        redirectTo: 'https://iguucmatfbwtozdvbgxs.supabase.co/auth/v1/verify',
      );
      if (!mounted) return;
      setState(() => _isResetEmailSent = true);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Se ha enviado un correo con instrucciones.'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 8),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _resetPassword() async {
    if (!_hasMinLength || !_hasNumber) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Asegúrate de cumplir los requisitos de la contraseña.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(password: _passwordController.text),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Contraseña actualizada exitosamente! Serás redirigido al login.'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
<<<<<<< Updated upstream

      Navigator.pushNamed(context, '/login'); // ✅ NO pushReplacement
=======
      
      // Esperar un momento para que el usuario pueda leer el mensaje
      await Future.delayed(const Duration(seconds: 2));
      
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/login');
>>>>>>> Stashed changes
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 12),
                // ✅ BOTÓN ATRÁS
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: SvgPicture.asset(
                        'assets/svg/back-svgrepo-com_blanco.svg',
                        width: 32,
                        height: 32,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF14448A),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Text(
                  _isTokenValid ? 'Restablece tu contraseña' : 'Recupera tu contraseña',
                  style: GoogleFonts.interTight(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF14448A),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _isTokenValid
                      ? 'Introduce tu nueva contraseña'
                      : 'Te enviaremos un correo con instrucciones',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    color: const Color(0xFF14448A),
                  ),
                ),
                const SizedBox(height: 32),
                if (!_isTokenValid && !_isResetEmailSent)
                  _buildEmailInput()
                else if (_isTokenValid)
                  _buildPasswordInput()
                else
                  _buildEmailSentMessage(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              prefixIcon: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SvgPicture.asset(
                  'assets/svg/emailAzul.svg',
                  width: 20,
                  height: 20,
                ),
              ),
              hintText: 'Introduce tu correo electrónico...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: _isLoading ? null : _sendResetEmail,
            child: Container(
              width: 180,
              height: 45,
              decoration: BoxDecoration(
                color: !_isLoading ? const Color(0xFF3C9EE7) : Colors.grey,
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                      'ENVIAR',
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
    );
  }

  Widget _buildPasswordInput() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: TextField(
            controller: _passwordController,
            obscureText: !_passwordVisible,
            onChanged: _validatePassword,
            decoration: InputDecoration(
              prefixIcon: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SvgPicture.asset(
                  'assets/svg/lockAzul.svg',
                  width: 20,
                  height: 20,
                ),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
              ),
              hintText: 'Introduce tu contraseña...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text('Tu contraseña debe contener:',
            style: GoogleFonts.inter(fontSize: 15, color: const Color(0xFF14448A))),
        const SizedBox(height: 12),
        _buildPasswordRequirement(_hasMinLength, 'Al menos 6 caracteres.'),
        _buildPasswordRequirement(_hasNumber, 'Al menos un número.'),
        const SizedBox(height: 36),
        GestureDetector(
          onTap: _isLoading ? null : _resetPassword,
          child: Container(
            width: 180,
            height: 45,
            decoration: BoxDecoration(
              color: (_hasMinLength && _hasNumber && !_isLoading)
                  ? const Color(0xFF3C9EE7)
                  : Colors.grey,
              borderRadius: BorderRadius.circular(20),
            ),
            alignment: Alignment.center,
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
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
    );
  }

  Widget _buildEmailSentMessage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          const Icon(Icons.check_circle_outline, color: Colors.green, size: 64),
          const SizedBox(height: 24),
          Text('¡Correo enviado!',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF14448A),
              )),
          const SizedBox(height: 12),
          Text(
            'Revisa tu correo y sigue las instrucciones para cambiar la contraseña.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 15,
              color: const Color(0xFF14448A),
            ),
          ),
          const SizedBox(height: 32),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: Container(
              width: 180,
              height: 45,
              decoration: BoxDecoration(
                color: const Color(0xFF3C9EE7),
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: Text(
                'VOLVER AL LOGIN',
                style: GoogleFonts.inter(
                  color: const Color(0xFFFAF9F6),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordRequirement(bool fulfilled, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 4),
      child: Row(
        children: [
          Opacity(
            opacity: fulfilled ? 1.0 : 0.3,
            child: SvgPicture.asset(
              'assets/svg/tick-circle-naranja.svg',
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
