import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final double cellSize = 25.0;
  Timer? _stateCheckTimer;

  @override
  void initState() {
    super.initState();
    game = TetrisGame();
    game.startGame();
    
    // Start timer to check game state
    _stateCheckTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (mounted) {
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
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('游戏结束'),
          content: const Text('俄罗斯方块到达顶部了！'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
              child: const Text('重新开始'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('退出'),
            ),
          ],
        );
      },
    );
  }

  void _showLevelCompleteDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('恭喜！'),
          content: Text('你通过了第${game.level - 1}关！'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('继续'),
            ),
          ],
        );
      },
    );
  }

  void _showGameWonDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('太棒了！'),
          content: const Text('恭喜你完成了所有关卡！'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
              child: const Text('重新开始'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text('俄罗斯方块 - 第${game.level}关'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: RawKeyboardListener(
        focusNode: FocusNode(),
        autofocus: true,
        onKey: (event) {
          if (event is RawKeyDownEvent) {
            switch (event.logicalKey) {
              case LogicalKeyboardKey.arrowLeft:
                setState(() {
                  game.moveLeft();
                });
                break;
              case LogicalKeyboardKey.arrowRight:
                setState(() {
                  game.moveRight();
                });
                break;
              case LogicalKeyboardKey.arrowUp:
                setState(() {
                  game.rotate();
                });
                break;
              case LogicalKeyboardKey.arrowDown:
                setState(() {
                  game.hardDrop();
                });
                break;
              case LogicalKeyboardKey.space:
                setState(() {
                  game.pauseGame();
                });
                break;
            }
          }
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
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
                  
                  const SizedBox(height: 20),
                  
                  // Game board
                  Center(
                    child: TetrisBoard(
                      board: game.getBoardWithPiece(),
                      cellSize: cellSize,
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
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
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // Remove didUpdateWidget as we're using timer now
}
