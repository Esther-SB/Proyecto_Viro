import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'allcoupons.dart'; 

class PasteleriaWidget extends StatelessWidget {
  const PasteleriaWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF7E1B),
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: const AlignmentDirectional(-0.3, 1),
              child: Container(
                width: 408.3,
                height: 56.2,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Align(
                  alignment: const AlignmentDirectional(-0.9, 0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AllcouponsWidget(),
                        ),
                      );
                    },
                    child: Container(
                      width: 37.98,
                      height: 37.98,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(
                        'assets/images/back-svgrepo-com_blanco.svg',
                        width: 165.1,
                        height: 151.5,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/pasteleria.png',
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
    );
  }
}
