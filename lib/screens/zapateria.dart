import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'allcoupons.dart';

class ZapateriaWidget extends StatelessWidget {
  const ZapateriaWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFF3B9EE6),
        body: SafeArea(
          child: Column(
            children: [
              // AppBar personalizada
              Container(
                height: 56.2,
                padding: const EdgeInsets.only(left: 16),
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AllcouponsWidget(),
                      ),
                    );
                  },
                  child: SvgPicture.asset(
                    'assets/images/back-svgrepo-com.svg',
                    width: 36,
                    height: 36,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/images/zapateria.png',
                      width: 355.6,
                      height: 700.75,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
