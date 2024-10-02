import 'package:flutter/material.dart';

class LoadingResponse extends StatefulWidget {
  const LoadingResponse({super.key});

  @override
  State<LoadingResponse> createState() => _LoadingResponseState();
}

class _LoadingResponseState extends State<LoadingResponse> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  )..addListener(() => setState((){}))..repeat(reverse: true);

  late final Animation<double> _animation = Tween<double>(
    begin: 0.0,
    end: 0.75,
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOut,
  ));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildAnimatedBox(),
          _buildAnimatedBox(),
          Row(
            children: [
              Flexible(flex: 1, child: _buildAnimatedBox(width: 1000)),
              const Spacer(flex: 1),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBox({double width = double.infinity}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xAAc4c7c5).withOpacity(_animation.value),
          borderRadius: BorderRadius.circular(8),
        ),
        child: SizedBox(height: 20, width: width),
      ),
    );
  }
}