import 'package:flutter/material.dart';
import '../models/tetris_piece.dart';

class NextPiecePreview extends StatelessWidget {
  final TetrisPiece? nextPiece;
  final double cellSize;

  const NextPiecePreview({
    super.key,
    required this.nextPiece,
    required this.cellSize,
  });

  @override
  Widget build(BuildContext context) {
    if (nextPiece == null) {
      return Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
            'Next',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    // Calculate preview size based on shape dimensions
    final previewCellSize = 16.0;
    final shapeRows = nextPiece!.shape.length;
    final shapeCols = nextPiece!.shape[0].length;
    final previewWidth = shapeCols * previewCellSize + 32; // extra padding
    final previewHeight = shapeRows * previewCellSize + 50; // space for label

    return Container(
      width: previewWidth,
      height: previewHeight,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400, width: 2),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Next',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(shapeRows, (y) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(shapeCols, (x) {
                        final cellValue = nextPiece!.shape[y][x];
                        return Container(
                          width: previewCellSize,
                          height: previewCellSize,
                          decoration: BoxDecoration(
                            color: cellValue == 1
                                ? Color(nextPiece!.color)
                                : Colors.transparent,
                            border: cellValue == 1
                                ? Border.all(
                                    color: Colors.grey.shade300,
                                    width: 0.5,
                                  )
                                : null,
                          ),
                        );
                      }),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
