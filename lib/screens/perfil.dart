import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class PerfilWidget extends StatelessWidget {
  const PerfilWidget({super.key});

  static String routeName = 'perfil';
  static String routePath = '/Perfil';

  TextStyle getTitleTextStyle() {
    return GoogleFonts.interTight(
      color: const Color(0xFFFAF9F6),
      fontSize: 26,
      fontWeight: FontWeight.bold,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double screenHeight = MediaQuery.sizeOf(context).height;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFFAF9F6),
        body: SafeArea(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: const AssetImage(
                  'assets/images/Captura_de_pantalla_2025-05-13_a_las_19.11.09.png',
                ),
              ),
            ),
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: screenHeight, // Para que el contenido ocupe al menos toda la pantalla
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 25),
                    _buildHeader(context),
                    const SizedBox(height: 20),
                    _buildProfileImage(),
                    const SizedBox(height: 30),
                    _buildContent(context, screenWidth),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/svg/back-svgrepo-com.svg',
            width: 36,
            height: 36,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text('@tonet_46', style: getTitleTextStyle(), textAlign: TextAlign.center),
          ),
          const SizedBox(width: 10),
          SvgPicture.asset(
            'assets/svg/options-vertical-svgrepo-com.svg',
            width: 24,
            height: 24,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    return Container(
      width: 132,
      height: 132,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Container(
          width: 116,
          height: 116,
          decoration: const BoxDecoration(
            color: Color(0xFFFF7E1B),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.asset(
                  'assets/images/Captura_de_pantalla_2025-05-13_a_las_17.52.51.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildImageTile(
            imagePath: 'assets/images/Captura_de_pantalla_2025-05-13_a_las_20.07.31.png',
            onTap: () => Navigator.pushReplacementNamed(context, '/RutasDone'),
            screenWidth: screenWidth,
          ),
          const SizedBox(height: 20),
          _buildImageTile(
            imagePath: 'assets/images/Captura_de_pantalla_2025-05-13_a_las_20.16.06.png',
            onTap: () => Navigator.pushReplacementNamed(context, '/RegalosDone'),
            screenWidth: screenWidth,
          ),
          const SizedBox(height: 20),
          _buildImageTile(
            imagePath: 'assets/images/Captura_de_pantalla_2025-05-13_a_las_20.22.14.png',
            onTap: () => Navigator.pushReplacementNamed(context, '/Amigos'),
            screenWidth: screenWidth,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildImageTile({
    required String imagePath,
    required VoidCallback onTap,
    required double screenWidth,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: screenWidth * 0.9,
        height: 172.3,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
