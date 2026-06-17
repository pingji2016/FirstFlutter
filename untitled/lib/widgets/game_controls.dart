import 'package:flutter/material.dart';

class GameControls extends StatelessWidget {
  final VoidCallback onLeft;
  final VoidCallback onRight;
  final VoidCallback onUp;
  final VoidCallback onDown;
  final VoidCallback onReset;
  final VoidCallback onExit;
  final bool isGameOver;
  final bool isSmallScreen;

  const GameControls({
    super.key,
    required this.onLeft,
    required this.onRight,
    required this.onUp,
    required this.onDown,
    required this.onReset,
    required this.onExit,
    this.isGameOver = false,
    this.isSmallScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    final btnSize = isSmallScreen ? 44.0 : 50.0;
    final fontSize = isSmallScreen ? 13.0 : 14.0;

    return Container(
      padding: const EdgeInsets.all(12),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          // Direction pad (D-pad style)
          //        [↑]
          //  [←]  [Rotate]  [→]
          //        [↓]
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Up button row
              _buildControlButton(
                icon: Icons.arrow_upward,
                onPressed: isGameOver ? null : onUp,
                color: Colors.orange,
                size: btnSize,
              ),
              const SizedBox(height: 4),
              // Middle row: Left, Rotate icon, Right
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildControlButton(
                    icon: Icons.arrow_back,
                    onPressed: isGameOver ? null : onLeft,
                    color: Colors.blue,
                    size: btnSize,
                  ),
                  const SizedBox(width: 16),
                  // Rotation indicator in center
                  Container(
                    width: btnSize,
                    height: btnSize,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(btnSize / 2),
                    ),
                    child: const Icon(
                      Icons.rotate_right,
                      color: Colors.grey,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  _buildControlButton(
                    icon: Icons.arrow_forward,
                    onPressed: isGameOver ? null : onRight,
                    color: Colors.blue,
                    size: btnSize,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              // Down button row
              _buildControlButton(
                icon: Icons.arrow_downward,
                onPressed: isGameOver ? null : onDown,
                color: Colors.green,
                size: btnSize,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(
                text: '重新开始',
                onPressed: onReset,
                color: Colors.orange,
                fontSize: fontSize,
              ),
              _buildActionButton(
                text: '退出',
                onPressed: onExit,
                color: Colors.red,
                fontSize: fontSize,
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
    double fontSize = 14,
  }) {
    return Container(
      width: 90,
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
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: fontSize,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
