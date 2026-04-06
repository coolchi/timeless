import 'dart:ui';
import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry padding;
  final BoxBorder? border;

  const GlassCard({
    Key? key,
    required this.child,
    this.blur = 15.0,
    this.opacity = 0.1,
    this.borderRadius,
    this.padding = const EdgeInsets.all(16.0),
    this.border,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(24.0);

    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(opacity),
            borderRadius: radius,
            border: border ??
                Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1.5,
                ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: -2,
              )
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class AnimatedMeshGradient extends StatefulWidget {
  const AnimatedMeshGradient({Key? key}) : super(key: key);

  @override
  State<AnimatedMeshGradient> createState() => _AnimatedMeshGradientState();
}

class _AnimatedMeshGradientState extends State<AnimatedMeshGradient>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(seconds: 10))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [
                0.0,
                0.5 + (_controller.value * 0.1),
                1.0
              ],
              colors: const [
                Color(0xFF2C0F4A),
                Color(0xFF0F1A3A),
                Color(0xFF1E3A5F),
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: -100 + (_controller.value * 50),
                left: -100,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF6B48BB),
                  ),
                ),
              ),
              Positioned(
                bottom: -150 + (_controller.value * 60),
                right: -100,
                child: Container(
                  width: 400,
                  height: 400,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF4887BB),
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.3 +
                    (_controller.value * -30),
                right: MediaQuery.of(context).size.width * 0.1,
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF1CB5E0),
                  ),
                ),
              ),
              // Main blurring layer to diffuse the shapes into a mesh network look
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
