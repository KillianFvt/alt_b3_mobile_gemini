import 'package:flutter/material.dart';
import '../colors.dart';

class HelloThereText extends StatelessWidget {
  const HelloThereText({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          WidgetSpan(
            child: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: geminiGradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: const Text(
                'Hello there!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                ),
              ),
            ),
          ),
          const TextSpan(text: '\n'),
          const TextSpan(
            text: 'How can I help you?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
            ),
          ),
        ],
      ),
    );
  }
}
