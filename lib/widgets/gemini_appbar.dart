import 'package:atl_b3_mobile/colors.dart';
import 'package:flutter/material.dart';

class GeminiAppBar extends StatefulWidget implements PreferredSizeWidget {
  const GeminiAppBar({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<GeminiAppBar> createState() => _GeminiAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _GeminiAppBarState extends State<GeminiAppBar> {

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: geminiGradientColors,
            stops: [
              0.0,
              0.33,
              0.66,
              1.0,
            ],
          ),
        ),
        child: widget.child,
      ),
    );
  }
}
