import 'package:flutter/material.dart';

class GlowingCircle extends StatelessWidget {
  final bool isActive;

  const GlowingCircle({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      height: isActive ? 80 : 60,
      width: isActive ? 80 : 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? Colors.blue.withOpacity(0.7) : Colors.blueGrey,
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ]
            : null,
      ),
      child: const Center(
        child: Icon(Icons.mic, color: Colors.white),
      ),
    );
  }
}
