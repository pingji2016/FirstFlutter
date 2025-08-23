import 'dart:async';
import 'tetris_piece.dart';

class TetrisGame {
  static const int boardWidth = 10;
  static const int boardHeight = 20;
  
  List<List<int>> board = [];
  TetrisPiece? currentPiece;
  TetrisPiece? nextPiece;
  Timer? gameTimer;
  
  int score = 0;
  int level = 1;
  int linesCleared = 0;
  bool isGameOver = false;
  bool isPaused = false;
  
  // Game speed (milliseconds between drops)
  int get dropSpeed {
    if (level == 1) return 800;
    if (level == 2) return 600;
    return 400;
  }
  
  // Score required to pass each level
  int get scoreRequired {
    if (level == 1) return 100;
    if (level == 2) return 120;
    return 200;
  }
  
  TetrisGame() {
    _initializeBoard();
    _spawnNewPiece();
  }
  
  void _initializeBoard() {
    board = List.generate(
      boardHeight,
      (y) => List.generate(boardWidth, (x) => 0),
    );
  }
  
  void _spawnNewPiece() {
    if (nextPiece == null) {
      nextPiece = TetrisPiece.random(boardWidth);
    }
    
    currentPiece = nextPiece;
    nextPiece = TetrisPiece.random(boardWidth);
    
    // Check if game is over
    if (!_isValidPosition(currentPiece!)) {
      isGameOver = true;
      stopGame();
    }
  }
  
  void startGame() {
    if (gameTimer != null) return;
    
    gameTimer = Timer.periodic(Duration(milliseconds: dropSpeed), (timer) {
      if (!isPaused && !isGameOver) {
        _dropPiece();
      }
    });
  }
  
  void stopGame() {
    gameTimer?.cancel();
    gameTimer = null;
  }
  
  void pauseGame() {
    isPaused = !isPaused;
  }
  
  void resetGame() {
    stopGame();
    score = 0;
    level = 1;
    linesCleared = 0;
    isGameOver = false;
    isPaused = false;
    _initializeBoard();
    _spawnNewPiece();
    startGame();
  }
  
  void _dropPiece() {
    if (currentPiece == null) return;
    
    final newPiece = currentPiece!.moveDown();
    
    if (_isValidPosition(newPiece)) {
      currentPiece = newPiece;
    } else {
      _placePiece();
      _clearLines();
      _spawnNewPiece();
    }
  }
  
  void moveLeft() {
    if (currentPiece == null || isGameOver || isPaused) return;
    
    final newPiece = currentPiece!.moveLeft();
    if (_isValidPosition(newPiece)) {
      currentPiece = newPiece;
    }
  }
  
  void moveRight() {
    if (currentPiece == null || isGameOver || isPaused) return;
    
    final newPiece = currentPiece!.moveRight();
    if (_isValidPosition(newPiece)) {
      currentPiece = newPiece;
    }
  }
  
  void rotate() {
    if (currentPiece == null || isGameOver || isPaused) return;
    
    final newPiece = currentPiece!.rotate();
    if (_isValidPosition(newPiece)) {
      currentPiece = newPiece;
    }
  }
  
  void hardDrop() {
    if (currentPiece == null || isGameOver || isPaused) return;
    
    while (_isValidPosition(currentPiece!.moveDown())) {
      currentPiece = currentPiece!.moveDown();
    }
    _dropPiece();
  }
  
  bool _isValidPosition(TetrisPiece piece) {
    for (int y = 0; y < piece.shape.length; y++) {
      for (int x = 0; x < piece.shape[y].length; x++) {
        if (piece.shape[y][x] == 1) {
          final boardX = piece.x + x;
          final boardY = piece.y + y;
          
          if (boardX < 0 || boardX >= boardWidth || 
              boardY < 0 || boardY >= boardHeight) {
            return false;
          }
          
          if (board[boardY][boardX] != 0) {
            return false;
          }
        }
      }
    }
    return true;
  }
  
  void _placePiece() {
    if (currentPiece == null) return;
    
    for (int y = 0; y < currentPiece!.shape.length; y++) {
      for (int x = 0; x < currentPiece!.shape[y].length; x++) {
        if (currentPiece!.shape[y][x] == 1) {
          final boardX = currentPiece!.x + x;
          final boardY = currentPiece!.y + y;
          
          if (boardY >= 0 && boardY < boardHeight && 
              boardX >= 0 && boardX < boardWidth) {
            board[boardY][boardX] = currentPiece!.color;
          }
        }
      }
    }
  }
  
  void _clearLines() {
    int linesToClear = 0;
    
    for (int y = boardHeight - 1; y >= 0; y--) {
      if (board[y].every((cell) => cell != 0)) {
        board.removeAt(y);
        board.insert(0, List.generate(boardWidth, (x) => 0));
        linesToClear++;
        y++; // Re-check the same row
      }
    }
    
    if (linesToClear > 0) {
      linesCleared += linesToClear;
      score += linesToClear * 10;
      
      // Check if level should increase
      if (score >= scoreRequired && level < 2) {
        level++;
        // Increase game speed
        if (gameTimer != null) {
          gameTimer!.cancel();
          gameTimer = Timer.periodic(Duration(milliseconds: dropSpeed), (timer) {
            if (!isPaused && !isGameOver) {
              _dropPiece();
            }
          });
        }
      }
      
      // Check if game is won (completed level 2)
      if (level == 2 && score >= scoreRequired) {
        // Game won - stop the game
        stopGame();
      }
    }
  }
  
  List<List<int>> getBoardWithPiece() {
    final result = List.generate(
      boardHeight,
      (y) => List.generate(boardWidth, (x) => board[y][x]),
    );
    
    if (currentPiece != null) {
      for (int y = 0; y < currentPiece!.shape.length; y++) {
        for (int x = 0; x < currentPiece!.shape[y].length; x++) {
          if (currentPiece!.shape[y][x] == 1) {
            final boardX = currentPiece!.x + x;
            final boardY = currentPiece!.y + y;
            
            if (boardY >= 0 && boardY < boardHeight && 
                boardX >= 0 && boardX < boardWidth) {
              result[boardY][boardX] = currentPiece!.color;
            }
          }
        }
      }
    }
    
    return result;
  }
  
  bool get hasWon => level == 2 && score >= scoreRequired;
  
  void dispose() {
    stopGame();
  }
}
