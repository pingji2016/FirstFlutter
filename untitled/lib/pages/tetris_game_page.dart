import 'dart:async';
import 'package:flutter/material.dart';
import '../models/tetris_game.dart';
import '../widgets/tetris_board.dart';
import '../widgets/next_piece_preview.dart';
import '../widgets/game_info.dart';
import '../widgets/game_controls.dart';

class TetrisGamePage extends StatefulWidget {
  const TetrisGamePage({super.key});

  @override
  State<TetrisGamePage> createState() => _TetrisGamePageState();
}

class _TetrisGamePageState extends State<TetrisGamePage> {
  late TetrisGame game;
  double cellSize = 25.0;
  Timer? _stateCheckTimer;
  bool _showingDialog = false;

  @override
  void initState() {
    super.initState();
    game = TetrisGame();
    game.startGame();

    // Start timer to check game state and trigger UI updates
    _stateCheckTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (mounted) {
        setState(() {});
        _handleGameState();
      }
    });
  }

  @override
  void dispose() {
    _stateCheckTimer?.cancel();
    game.dispose();
    super.dispose();
  }

  void _showGameOverDialog() {
    if (_showingDialog) return;
    _showingDialog = true;
    final pageContext = context;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('游戏结束'),
          content: const Text('俄罗斯方块到达顶部了！'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _showingDialog = false;
                _resetGame();
              },
              child: const Text('重新开始'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _showingDialog = false;
                Navigator.of(pageContext).pop();
              },
              child: const Text('退出'),
            ),
          ],
        );
      },
    );
  }

  void _showLevelCompleteDialog() {
    if (_showingDialog) return;
    _showingDialog = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('恭喜！'),
          content: Text('你通过了第${game.level - 1}关！'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _showingDialog = false;
              },
              child: const Text('继续'),
            ),
          ],
        );
      },
    );
  }

  void _showGameWonDialog() {
    if (_showingDialog) return;
    _showingDialog = true;
    final pageContext = context;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('太棒了！'),
          content: const Text('恭喜你完成了所有关卡！'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _showingDialog = false;
                _resetGame();
              },
              child: const Text('重新开始'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _showingDialog = false;
                Navigator.of(pageContext).pop();
              },
              child: const Text('退出'),
            ),
          ],
        );
      },
    );
  }

  void _resetGame() {
    setState(() {
      game.resetGame();
    });
  }

  void _exitGame() {
    Navigator.of(context).pop();
  }

  void _handleGameState() {
    if (game.isGameOver) {
      _showGameOverDialog();
    } else if (game.hasWon) {
      _showGameWonDialog();
    } else if (game.level > 1 && game.score >= game.scoreRequired) {
      _showLevelCompleteDialog();
    }
  }

  /// Calculate cell size based on available screen height
  double _calculateCellSize(double availableHeight) {
    // Estimated fixed heights for non-board elements
    const appBarHeight = 56.0;
    const infoRowHeight = 100.0;
    const controlAreaHeight = 320.0;
    const spacing = 40.0;
    const padding = 32.0;

    final boardAvailable = availableHeight - appBarHeight - infoRowHeight - controlAreaHeight - spacing - padding;
    final cellFromBoard = boardAvailable / 20; // 20 rows
    return cellFromBoard.clamp(14.0, 25.0);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    cellSize = _calculateCellSize(screenSize.height);
    final isSmallScreen = screenSize.width < 400;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text('俄罗斯方块 - 第${game.level}关'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Game info and next piece preview
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GameInfo(
                    score: game.score,
                    level: game.level,
                    linesCleared: game.linesCleared,
                  ),
                  NextPiecePreview(
                    nextPiece: game.nextPiece,
                    cellSize: cellSize,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Game board
              Center(
                child: TetrisBoard(
                  board: game.getBoardWithPiece(),
                  cellSize: cellSize,
                ),
              ),

              const SizedBox(height: 16),

              // Game controls
              GameControls(
                onLeft: () {
                  setState(() {
                    game.moveLeft();
                  });
                },
                onRight: () {
                  setState(() {
                    game.moveRight();
                  });
                },
                onUp: () {
                  setState(() {
                    game.rotate();
                  });
                },
                onDown: () {
                  setState(() {
                    game.hardDrop();
                  });
                },
                onReset: _resetGame,
                onExit: _exitGame,
                isGameOver: game.isGameOver,
                isSmallScreen: isSmallScreen,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
