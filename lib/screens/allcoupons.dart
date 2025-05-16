import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class AllcouponsWidget extends StatefulWidget {
  const AllcouponsWidget({super.key});

  @override
  State<AllcouponsWidget> createState() => _AllcouponsWidgetState();
}

class _AllcouponsWidgetState extends State<AllcouponsWidget> {
  static const fondoColor = Color(0xFFFAF9F6);

  final List<_CouponItem> items = const [
    _CouponItem('assets/images/ClinicaDental.png', '/clinica'),
    _CouponItem('assets/images/TiendaRegalos_Pasarela.png', '/regalos'),
    _CouponItem('assets/images/Zapateria.png', '/zapateria'),
    _CouponItem('assets/images/Joyeria_Tolmo.png', '/joyeria'),
    _CouponItem('assets/images/Pasteleria_Deleire.png', '/pasteleria'),
    _CouponItem('assets/images/Tienda_Ropa.png', '/ropa'),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _showExitDialog(context),
      child: Scaffold(
        backgroundColor: fondoColor,
        body: SafeArea(
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/fondoDegradacion_naranja.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 16),
                _buildBackButton(context),
                const SizedBox(height: 16),
                Text(
                  'MIS REGALOS',
                  style: GoogleFonts.inter(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFFF9000),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: items
                          .map((item) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: _buildCouponTile(
                                  context,
                                  imagePath: item.imagePath,
                                  routeName: item.routeName,
                                ),
                              ))
                          .toList(),
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

  Future<bool> _showExitDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('¿Salir de la sección?'),
            content: const Text('¿Quieres volver a la pantalla anterior?'),
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

  Widget _buildBackButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: SvgPicture.asset(
            'assets/svg/back-svgrepo-com_naranja.svg',
            width: 36,
            height: 36,
            colorFilter: const ColorFilter.mode(Color(0xFFFF7E1B), BlendMode.srcIn),
          ),
        ),
      ),
    );
  }

  Widget _buildCouponTile(
    BuildContext context, {
    required String imagePath,
    required String routeName,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => Navigator.pushNamed(context, routeName),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          imagePath,
          width: double.infinity,
          height: 160,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _CouponItem {
  final String imagePath;
  final String routeName;

  const _CouponItem(this.imagePath, this.routeName);
}
