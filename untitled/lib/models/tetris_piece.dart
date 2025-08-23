import 'dart:math';

class TetrisPiece {
  static const List<List<List<List<int>>>> pieces = [
    // I piece
    [
      [
        [1, 1, 1, 1],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
      ],
      [
        [0, 0, 1, 0],
        [0, 0, 1, 0],
        [0, 0, 1, 0],
        [0, 0, 1, 0],
      ],
      [
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [1, 1, 1, 1],
        [0, 0, 0, 0],
      ],
      [
        [0, 1, 0, 0],
        [0, 1, 0, 0],
        [0, 1, 0, 0],
        [0, 1, 0, 0],
      ],
    ],
    // O piece
    [
      [
        [1, 1],
        [1, 1],
      ],
      [
        [1, 1],
        [1, 1],
      ],
      [
        [1, 1],
        [1, 1],
      ],
      [
        [1, 1],
        [1, 1],
      ],
    ],
    // T piece
    [
      [
        [0, 1, 0],
        [1, 1, 1],
        [0, 0, 0],
      ],
      [
        [0, 1, 0],
        [0, 1, 1],
        [0, 1, 0],
      ],
      [
        [0, 0, 0],
        [1, 1, 1],
        [0, 1, 0],
      ],
      [
        [0, 1, 0],
        [1, 1, 0],
        [0, 1, 0],
      ],
    ],
    // S piece
    [
      [
        [0, 1, 1],
        [1, 1, 0],
        [0, 0, 0],
      ],
      [
        [0, 1, 0],
        [0, 1, 1],
        [0, 0, 1],
      ],
      [
        [0, 0, 0],
        [0, 1, 1],
        [1, 1, 0],
      ],
      [
        [1, 0, 0],
        [1, 1, 0],
        [0, 1, 0],
      ],
    ],
    // Z piece
    [
      [
        [1, 1, 0],
        [0, 1, 1],
        [0, 0, 0],
      ],
      [
        [0, 0, 1],
        [0, 1, 1],
        [0, 1, 0],
      ],
      [
        [0, 0, 0],
        [1, 1, 0],
        [0, 1, 1],
      ],
      [
        [0, 1, 0],
        [1, 1, 0],
        [1, 0, 0],
      ],
    ],
    // J piece
    [
      [
        [1, 0, 0],
        [1, 1, 1],
        [0, 0, 0],
      ],
      [
        [0, 1, 1],
        [0, 1, 0],
        [0, 1, 0],
      ],
      [
        [0, 0, 0],
        [1, 1, 1],
        [0, 0, 1],
      ],
      [
        [0, 1, 0],
        [0, 1, 0],
        [1, 1, 0],
      ],
    ],
    // L piece
    [
      [
        [0, 0, 1],
        [1, 1, 1],
        [0, 0, 0],
      ],
      [
        [0, 1, 0],
        [0, 1, 0],
        [0, 1, 1],
      ],
      [
        [0, 0, 0],
        [1, 1, 1],
        [1, 0, 0],
      ],
      [
        [1, 1, 0],
        [0, 1, 0],
        [0, 1, 0],
      ],
    ],
  ];

  static const List<String> pieceNames = ['I', 'O', 'T', 'S', 'Z', 'J', 'L'];
  static const List<int> pieceColors = [
    0xFF00FFFF, // Cyan for I
    0xFFFFFF00, // Yellow for O
    0xFF800080, // Purple for T
    0xFF00FF00, // Green for S
    0xFFFF0000, // Red for Z
    0xFF0000FF, // Blue for J
    0xFFFF8000, // Orange for L
  ];

  int type;
  int rotation;
  int x;
  int y;

  TetrisPiece({
    required this.type,
    this.rotation = 0,
    required this.x,
    required this.y,
  });

  List<List<int>> get shape => pieces[type][rotation];
  int get color => pieceColors[type];
  String get name => pieceNames[type];

  TetrisPiece copyWith({
    int? type,
    int? rotation,
    int? x,
    int? y,
  }) {
    return TetrisPiece(
      type: type ?? this.type,
      rotation: rotation ?? this.rotation,
      x: x ?? this.x,
      y: y ?? this.y,
    );
  }

  TetrisPiece rotate() {
    return copyWith(rotation: (rotation + 1) % pieces[type].length);
  }

  TetrisPiece moveLeft() {
    return copyWith(x: x - 1);
  }

  TetrisPiece moveRight() {
    return copyWith(x: x + 1);
  }

  TetrisPiece moveDown() {
    return copyWith(y: y + 1);
  }

  static TetrisPiece random(int boardWidth) {
    final random = Random();
    final type = random.nextInt(pieces.length);
    final x = boardWidth ~/ 2 - 1;
    return TetrisPiece(type: type, x: x, y: 0);
  }
}
