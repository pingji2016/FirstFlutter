import 'package:flutter/material.dart';

class TetrisBoard extends StatelessWidget {
  final List<List<int>> board;
  final double cellSize;

  const TetrisBoard({
    super.key,
    required this.board,
    required this.cellSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Column(
          children: List.generate(board.length, (y) {
            return Row(
              children: List.generate(board[y].length, (x) {
                final cellValue = board[y][x];
                return Container(
                  width: cellSize,
                  height: cellSize,
                  decoration: BoxDecoration(
                    color: cellValue == 0 
                        ? Colors.grey.shade100 
                        : Color(cellValue),
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 0.5,
                    ),
                  ),
                );
              }),
            );
          }),
        ),
      ),
    );
  }
}
