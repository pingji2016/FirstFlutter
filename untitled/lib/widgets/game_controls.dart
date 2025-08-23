import 'package:flutter/material.dart';

class GameControls extends StatelessWidget {
  final VoidCallback onLeft;
  final VoidCallback onRight;
  final VoidCallback onUp;
  final VoidCallback onDown;
  final VoidCallback onReset;
  final VoidCallback onExit;
  final bool isGameOver;

  const GameControls({
    super.key,
    required this.onLeft,
    required this.onRight,
    required this.onUp,
    required this.onDown,
    required this.onReset,
    required this.onExit,
    this.isGameOver = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Direction controls (left side)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Left side controls
              Column(
                children: [
                  const SizedBox(height: 40), // Space for up button
                  Row(
                    children: [
                      _buildControlButton(
                        icon: Icons.arrow_back,
                        onPressed: isGameOver ? null : onLeft,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 20),
                      _buildControlButton(
                        icon: Icons.arrow_forward,
                        onPressed: isGameOver ? null : onRight,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildControlButton(
                    icon: Icons.arrow_downward,
                    onPressed: isGameOver ? null : onDown,
                    color: Colors.green,
                  ),
                ],
              ),
              
              const SizedBox(width: 40),
              
              // Up button (rotate)
              _buildControlButton(
                icon: Icons.rotate_right,
                onPressed: isGameOver ? null : onUp,
                color: Colors.orange,
                size: 60,
              ),
            ],
          ),
          
          const SizedBox(height: 30),
          
          // Action buttons (right side)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(
                text: 'Reset',
                onPressed: onReset,
                color: Colors.orange,
              ),
              _buildActionButton(
                text: 'Exit',
                onPressed: onExit,
                color: Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required Color color,
    double size = 50,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(size / 2),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(size / 2),
          onTap: onPressed,
          child: Icon(
            icon,
            color: Colors.white,
            size: size * 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return Container(
      width: 80,
      height: 40,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onPressed,
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
