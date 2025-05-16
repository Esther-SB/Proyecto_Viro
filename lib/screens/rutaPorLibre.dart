import 'package:flutter/material.dart';

class RutaporlibreWidget extends StatelessWidget {
  const RutaporlibreWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Eventos')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Dart ipsum dolor sit amet, consectetur Flutter adipiscing elit. '
          'Widget sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. '
          'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. '
          'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. '
          'Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. '
          'Future await async setState build context. StatelessWidget ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}