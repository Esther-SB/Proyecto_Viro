import 'package:flutter/material.dart';

class EventosWidget extends StatelessWidget {
  const EventosWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: Text('Eventos')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Está en construcción',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            Image.asset(
              'assets/images/nosignalpng.png',
              width: screenWidth * 0.7, // 70% del ancho de pantalla
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}