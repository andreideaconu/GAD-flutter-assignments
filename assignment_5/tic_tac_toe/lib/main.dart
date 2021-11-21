import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'tic-tac-toe';

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appTitle,
      home: const MyHomePage(title: appTitle),
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.grey[300]),
          foregroundColor: MaterialStateProperty.all(Colors.black),
        )),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class TicTacToe {
  TicTacToe();

  List<int> board = List<int>.generate(9, (_) => 0);
  int currentPlayer = 1;
  bool hasGameEnded = false;
  String message = '';

  void makeMove(int tileIndex) {
    if (hasGameEnded) {
      return;
    }

    if (board[tileIndex] == 0) {
      board[tileIndex] = currentPlayer;
    } else {
      message = 'Invalid move.';
      return;
    }
    message = '';

    final bool winner = checkWin();
    if (winner) {
      hasGameEnded = true;
      message = 'Player $currentPlayer has won!';
      return;
    }

    final bool draw = checkDraw();
    if (draw) {
      hasGameEnded = true;
      message = "It's a draw!";
      return;
    }

    currentPlayer = currentPlayer == 1 ? 2 : 1;
  }

  bool checkDraw() {
    return !board.contains(0);
  }

  bool checkWin() {
    for (int i = 0; i <= 6; i = i + 3) {
      if (board[i] != 0 && board[i] == board[i + 1] && board[i + 1] == board[i + 2]) {
        return true;
      }
    }
    for (int i = 0; i <= 2; i++) {
      if (board[i] != 0 && board[i] == board[i + 3] && board[i + 3] == board[i + 6]) {
        return true;
      }
    }
    if (board[0] != 0 && board[0] == board[4] && board[4] == board[8]) {
      return true;
    }
    if (board[2] != 0 && board[2] == board[4] && board[4] == board[6]) {
      return true;
    }
    return false;
  }

  void resetGame() {
    board = List<int>.generate(9, (_) => 0);
    currentPlayer = 1;
    hasGameEnded = false;
    message = '';
  }
}

class _MyHomePageState extends State<MyHomePage> {
  TicTacToe game = TicTacToe();
  final List<ColorSwatch<int>?> colors = <ColorSwatch<int>?>[null, Colors.redAccent, Colors.green];

  void makeMove(int tileIndex) {
    setState(() {
      game.makeMove(tileIndex);
    });
  }

  void resetGame() {
    setState(() {
      game.resetGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool hasGameEnded = game.hasGameEnded;
    final String message = game.message;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        backgroundColor: Colors.yellow,
        foregroundColor: Colors.black,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemCount: game.board.length,
            itemBuilder: (BuildContext context, int index) {
              final int boardTile = game.board[index];

              return GestureDetector(
                onTap: () {
                  makeMove(index);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    border: Border.all(width: 0.5),
                    color: colors[boardTile],
                  ),
                ),
              );
            },
          ),
          if (message != '')
            Padding(
              padding: const EdgeInsetsDirectional.only(top: 16.0),
              child: Text(message),
            ),
          if (hasGameEnded)
            ElevatedButton(
              onPressed: resetGame,
              child: const Padding(
                padding: EdgeInsets.all(3.0),
                child: Text('Play again!'),
              ),
            ),
        ],
      ),
    );
  }
}
