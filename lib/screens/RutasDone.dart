import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';



class RutasDoneWidget extends StatefulWidget {
  const RutasDoneWidget({super.key});

  static String routeName = 'rutas';
  static String routePath = '/rutas';

  @override
  State<RutasDoneWidget> createState() => _RutasDoneWidget();
}

class _RutasDoneWidget extends State<RutasDoneWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    // Si tienes controladores, límpialos aquí
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const fondoColor = Color(0xFFFAF9F6);
    const colorTexto = Color(0xFFFF7E1B);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: fondoColor,
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 25),
              _buildHeader(context, colorTexto),
              const SizedBox(height: 20),
              _buildImageSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Color colorTexto) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/pagPerfil'),
            child: SvgPicture.asset(
              'assets/svg/back-svgrepo-com_naranja.svg',
              width: 36,
              height: 36,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'RUTAS COMPLETADAS',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 23,
                fontWeight: FontWeight.w500,
                color: colorTexto,
              ),
            ),
          ),
          const SizedBox(width: 46), // Para equilibrar visualmente el ícono de regreso
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            'assets/images/Captura_de_pantalla_2025-05-14_a_las_12.27.41.png',
            fit: BoxFit.contain,
            width: double.infinity,
          ),
        ),
      ),
    );
  }
}
