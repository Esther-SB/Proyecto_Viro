import 'dart:async';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:math';

class CargandoWidget extends StatefulWidget {
  const CargandoWidget({super.key});

  static String routeName = 'Cargando';
  static String routePath = '/cargando';

  @override
  State<CargandoWidget> createState() => _CargandoWidgetState();
}

class _CargandoWidgetState extends State<CargandoWidget> {
  double progress = 0.0;
  int frameIndex = 0;
  Timer? _timer;
  
  var random = Random();


  final List<String> frames = [
    'assets/images/quieto.png',
    'assets/images/CaminandoA.png',
  ];

  @override
void initState() {
  super.initState();

  _timer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
    setState(() {
      frameIndex = (frameIndex + 1) % frames.length;
      progress += random.nextDouble() * 0.09; // Incrementa el progreso aleatoriamente
    });

    if (progress >= 1.0) {
      _timer?.cancel();
      Navigator.pushReplacementNamed(context, '/login');
    }
  });
}


  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF14448A),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Imagen sin fondo blanco y más pequeña
              SizedBox(
                width: 200,
                height: 200,
                child: Image.asset(
                  frames[frameIndex],
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 60, width:100,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: SizedBox(
                  width: 350, // Cambia el ancho de la barra aquí
                  child: LinearPercentIndicator(
                    percent: progress.clamp(0.0, 1.0),
                    lineHeight: 20, // Cambia la altura de la barra aquí
                    animation: true,
                    animateFromLastPercent: true,
                    progressColor: const Color(0xFFFF7E1B),
                    backgroundColor: const Color(0xFFA1C4F9),
                    barRadius: const Radius.circular(40),
                    padding: EdgeInsets.zero,
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