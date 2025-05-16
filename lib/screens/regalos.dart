import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'allcoupons.dart';

class RegalosWidget extends StatelessWidget {
  const RegalosWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF7E1B),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AllcouponsWidget(),
                      ),
                    );
                  },
                  child: SvgPicture.asset(
                    'assets/svg/back-svgrepo-com_blanco.svg',
                    width: 36,
                    height: 36,
                    colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/images/tienda_regalos.png',
                    width: 360,
                    height: 600,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}