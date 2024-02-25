import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<List<int>> board = List.generate(3, (_) => List<int>.filled(3, 0));
  int currentPlayer = 1;
  String gameStatus = 'In Progress';
  int gamesPlayed = 0;
  int xWins = 0;
  int oWins = 0;
  int draws = 0;

  void onCellTap(int row, int col) {
    if (board[row][col] == 0 && gameStatus == 'In Progress') {
      setState(() {
        board[row][col] = currentPlayer;

        if (checkWin(row, col)) {
          showWinDialog();
        } else if (checkDraw()) {
          showDrawDialog();
        } else {
          currentPlayer = 3 - currentPlayer;
        }
      });
    }
  }

  bool checkWin(int row, int col) {
    return (board[row][0] == currentPlayer &&
        board[row][1] == currentPlayer &&
        board[row][2] == currentPlayer) ||
        (board[0][col] == currentPlayer &&
            board[1][col] == currentPlayer &&
            board[2][col] == currentPlayer) ||
        (row == col &&
            board[0][0] == currentPlayer &&
            board[1][1] == currentPlayer &&
            board[2][2] == currentPlayer) ||
        (row + col == 2 &&
            board[0][2] == currentPlayer &&
            board[1][1] == currentPlayer &&
            board[2][0] == currentPlayer);
  }

  bool checkDraw() {
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[i][j] == 0) {
          return false;
        }
      }
    }
    return true;
  }

  void resetGame() {
    setState(() {
      board = List.generate(3, (_) => List<int>.filled(3, 0));
      currentPlayer = 1;
      gameStatus = 'In Progress';
      gamesPlayed++;
    });
  }

  void showWinDialog() {
    setState(() {
      gameStatus = 'Game Over';
      currentPlayer == 1 ? xWins++ : oWins++;
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Player ${currentPlayer == 1 ? 'X' : 'O'} wins!'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                resetGame();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void showDrawDialog() {
    setState(() {
      gameStatus = 'Game Over';
      draws++;
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('It\'s a draw!'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                resetGame();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Toe'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            for (int i = 0; i < 3; i++)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  for (int j = 0; j < 3; j++)
                    GestureDetector(
                      onTap: () => onCellTap(i, j),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(),
                        ),
                        child: Center(
                          child: Text(
                            board[i][j] == 1 ? 'X' : (board[i][j] == 2 ? 'O' : ''),
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            SizedBox(height: 20),
            Text('Games Played: $gamesPlayed'),
            Text('X Wins: $xWins'),
            Text('O Wins: $oWins'),
            Text('Draws: $draws'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: resetGame,
              child: Text('Reset Game'),
            ),
          ],
        ),
      ),
    );
  }
}
