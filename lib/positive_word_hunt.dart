import 'package:flutter/material.dart';
import 'dart:math';

class PositiveWordHunt extends StatefulWidget {
  @override
  _PositiveWordHuntState createState() => _PositiveWordHuntState();
}

class _PositiveWordHuntState extends State<PositiveWordHunt> {
  List<String> words = [];
  List<String> wordHints = [];
  List<List<String>> grid = [];

  List<String> foundWords = [];
  List<List<int>> selectedIndices = [];
  bool _showAnswers = false;

  @override
  void initState() {
    super.initState();
    _generateDailyWordHunt();
  }

  void _generateDailyWordHunt() {
    print('Generating daily word hunt...');
    DateTime now = DateTime.now();
    int seed = now.year * 10000 + now.month * 100 + now.day;
    Random random = Random(seed);

    const allWords = [
      'LOVE',
      'JOY',
      'PEACE',
      'HOPE',
      'KIND',
      'SMILE',
      'HAPPY',
      'GRACE',
      'TRUST',
      'FAITH',
    ];
    const allWordHints = [
      'A feeling of affection',
      'A feeling of great pleasure',
      'A state of harmony',
      'A feeling of optimism',
      'Being considerate and gentle',
      'A facial expression of happiness',
      'A feeling of joy',
      'Courteous goodwill',
      'Firm belief in the reliability',
      'Strong belief in God',
    ];

    // Select 3 to 4 random words
    List<int> indices = [];
    int numWords = random.nextInt(2) + 3; // 3 or 4 words
    try {
      print('Selecting random words...');
      while (indices.length < numWords) {
        int index = random.nextInt(allWords.length);
        if (!indices.contains(index)) {
          indices.add(index);
        }
      }
      print('Random words selected: $indices');
    } catch (e) {
      print('Error selecting random words: $e');
    }

    words = indices.map((i) => allWords[i]).toList();
    wordHints = indices.map((i) => allWordHints[i]).toList();

    // Generate a 4x6 grid
    try {
      print('Generating grid...');
      grid = List.generate(4, (_) => List.generate(6, (_) => ''));
      print('Grid generated: ${grid.length}x${grid[0].length}');
    } catch (e) {
      print('Error generating grid: $e');
    }

    // Clear the grid
    for (int i = 0; i < grid.length; i++) {
      for (int j = 0; j < grid[0].length; j++) {
        grid[i][j] = '';
      }
    }

    // Place words in the grid
    try {
      print('Placing words in the grid...');
      for (String word in words) {
        _placeWord(word, random);
      }
      print('Words placed in the grid.');
    } catch (e) {
      print('Error placing words in the grid: $e');
    }

    // Fill the remaining spaces with random letters
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    for (int i = 0; i < grid.length; i++) {
      for (int j = 0; j < grid[i].length; j++) {
        if (grid[i][j] == '') {
          grid[i][j] = letters[random.nextInt(letters.length)];
        }
      }
    }

    setState(() {}); // Trigger a rebuild to display the new grid
  }

  void _placeWord(String word, Random random) {
    bool placed = false;
    int attempts = 0;
    while (!placed && attempts < 100) {
      attempts++;
      bool horizontal = random.nextBool();

      if (horizontal) {
        int row = random.nextInt(grid.length);
        int col = random.nextInt(grid[0].length - word.length + 1); // Ensure word fits horizontally

        bool canPlace = true;
        for (int i = 0; i < word.length; i++) {
          if (grid[row][col + i] != '' && grid[row][col + i] != word[i]) {
            canPlace = false;
            break;
          }
        }

        if (canPlace) {
          for (int i = 0; i < word.length; i++) {
            grid[row][col + i] = word[i];
          }
          placed = true;
        }
      } else {
        int row = random.nextInt(grid.length - word.length + 1); // Ensure word fits vertically
        int col = random.nextInt(grid[0].length);

        bool canPlace = true;
        for (int i = 0; i < word.length; i++) {
          if (grid[row + i][col] != '' && grid[row + i][col] != word[i]) {
            canPlace = false;
            break;
          }
        }

        if (canPlace) {
          for (int i = 0; i < word.length; i++) {
            grid[row + i][col] = word[i];
          }
          placed = true;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/Onboarding 14.png'),
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
        ),
        child: ClipRRect(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 10.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: grid[0].length,
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                ),
                itemCount: grid.length * grid[0].length,
                itemBuilder: (context, index) {
                  int row = index ~/ grid[0].length;
                  int col = index % grid[0].length;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (selectedIndices.any(
                          (e) => e[0] == row && e[1] == col,
                        )) {
                          selectedIndices.removeWhere(
                            (e) => e[0] == row && e[1] == col,
                          );
                        } else {
                          selectedIndices.add([row, col]);
                        }
                        _checkWord();
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            selectedIndices.any((e) => e[0] == row && e[1] == col)
                            ? Colors.blue[200]
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Center(
                        child: Text(
                          grid[row][col],
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: _showAnswers && _isWordLocation(row, col)
                                ? Colors.red
                                : selectedIndices.any(
                                    (e) => e[0] == row && e[1] == col,
                                  )
                                    ? Colors.green
                                    : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Center(
              child: Container(
                height: 100,
                child: ListView.builder(
                  itemCount: words.length,
                  itemBuilder: (context, index) {
                    return Text(
                      foundWords.contains(words[index])
                          ? '${words[index]} (Hint: ${wordHints[index]})'
                          : 'Hint: ${wordHints[index]}',
                      style: TextStyle(
                        fontSize: 20,
                        color: foundWords.contains(words[index])
                            ? Colors.green
                            : Colors.black,
                      ),
                    );
                  },
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _showAnswers = !_showAnswers;
                });
              },
              child: Text(_showAnswers ? 'Hide Answers' : 'Show Answers'),
            ),
          ],
        ),
      ),
      ),
    );
  }

  void _checkWord() {
    String selectedWord = '';
    selectedIndices.sort((a, b) {
      if (a[0] != b[0]) {
        return a[0].compareTo(b[0]);
      }
      return a[1].compareTo(b[1]);
    });
    for (var index in selectedIndices) {
      selectedWord += grid[index[0]][index[1]];
    }

    if (words.contains(selectedWord) && !foundWords.contains(selectedWord)) {
      setState(() {
        foundWords.add(selectedWord);
        selectedIndices.clear();
      });

      if (foundWords.length == words.length) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Congratulations!'),
            content: Text('You have found all the words.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    foundWords.clear();
                  });
                },
                child: Text('Play Again'),
              ),
            ],
          ),
        );
      }
    }
  }

  bool _isWordLocation(int row, int col) {
    for (String word in words) {
      bool horizontal = false;
      int wordRow = -1;
      int wordCol = -1;

      // Check horizontal placement
      for (int r = 0; r < grid.length; r++) {
        for (int c = 0; c <= grid[0].length - word.length; c++) {
          bool match = true;
          for (int i = 0; i < word.length; i++) {
            if (grid[r][c + i] != word[i]) {
              match = false;
              break;
            }
          }
          if (match) {
            horizontal = true;
            wordRow = r;
            wordCol = c;
            break;
          }
        }
        if (wordRow != -1) break;
      }

      // Check vertical placement
      if (wordRow == -1) {
        for (int c = 0; c < grid[0].length; c++) {
          for (int r = 0; r <= grid.length - word.length; r++) {
            bool match = true;
            for (int i = 0; i < word.length; i++) {
              if (grid[r + i][c] != word[i]) {
                match = false;
                break;
              }
            }
            if (match) {
              horizontal = false;
              wordRow = r;
              wordCol = c;
              break;
            }
          }
          if (wordRow != -1) break;
        }
      }

      if (wordRow != -1) {
        if (horizontal && row == wordRow && col >= wordCol && col < wordCol + word.length) {
          return true;
        } else if (!horizontal && col == wordCol && row >= wordRow && row < wordRow + word.length) {
          return true;
        }
      }
    }
    return false;
  }
}
