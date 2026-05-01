import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class RadialMenu extends StatefulWidget {
  const RadialMenu({super.key});

  @override
  State<RadialMenu> createState() => _RadialMenuState();
}

class _RadialMenuState extends State<RadialMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              _controller.reverse().then((_) => Navigator.pop(context));
            },
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                color: Colors.black.withValues(alpha: 0.3),
              ),
            ),
          ),
          _buildMenu(),
        ],
      ),
    );
  }

  Widget _buildMenu() {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _fadeAnimation.value,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  _buildButton(0, icon: Icons.home),
                  _buildButton(1, icon: Icons.camera),
                  _buildButton(2, icon: Icons.music_note),
                  _buildButton(3, icon: Icons.palette),
                  _buildButton(4, icon: Icons.settings),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildButton(int index, {required IconData icon}) {
    final double radius = 100.0;
    final double angle = (2 * pi / 5) * index;
    final double x = cos(angle) * radius;
    final double y = sin(angle) * radius;

    return Transform.translate(
      offset: Offset(x, y),
      child: FloatingActionButton(
        onPressed: () {
          // TODO: Implement button logic
        },
        child: Icon(icon),
      ),
    );
  }
}
