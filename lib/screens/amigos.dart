import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class AmigosWidget extends StatefulWidget {
  const AmigosWidget({super.key});

  static String routeName = 'amigos';
  static String routePath = '/amigos';

  @override
  State<AmigosWidget> createState() => _AmigosWidgetState();
}

class _AmigosWidgetState extends State<AmigosWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final textController = TextEditingController();
  final textFocusNode = FocusNode();

  @override
  void dispose() {
    textController.dispose();
    textFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const fondoColor = Color(0xFFFAF9F6);
    const naranja = Color(0xFFFF7E1B);

    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await _showExitDialog(context);
        return shouldPop;
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: fondoColor,
          body: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 25),
                _buildHeader(context, naranja),
                const SizedBox(height: 10),
                _buildSearchBar(naranja),
                const SizedBox(height: 10),
                _buildImageSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _showExitDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('¿Salir de "Amigos"?'),
            content: const Text('¿Deseas volver a la pantalla anterior?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Sí, volver'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Widget _buildHeader(BuildContext context, Color naranja) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: SvgPicture.asset(
              'assets/svg/back-svgrepo-com_naranja.svg',
              width: 36,
              height: 36,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'MIS AMIGOS',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 23,
                fontWeight: FontWeight.w500,
                color: naranja,
              ),
            ),
          ),
          const SizedBox(width: 46),
        ],
      ),
    );
  }

  Widget _buildSearchBar(Color naranja) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: naranja, width: 3),
        ),
        child: Row(
          children: [
            const SizedBox(width: 10),
            SvgPicture.asset(
              'assets/svg/search-svgrepo-com_blanco.svg',
              width: 25,
              height: 25,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: textController,
                focusNode: textFocusNode,
                style: GoogleFonts.inter(fontSize: 16),
                decoration: InputDecoration(
                  hintText: 'BUSCAR AMIGOS...',
                  hintStyle: GoogleFonts.inter(
                    color: naranja,
                    fontSize: 15,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
          ],
        ),
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
            'assets/images/Captura_de_pantalla_2025-05-14_a_las_16.19.05.png',
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
