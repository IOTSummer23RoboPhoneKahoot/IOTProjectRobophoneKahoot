import 'package:flutter/material.dart';
import 'CreateQuiz.dart';
import 'GamePage.dart';
import 'PlayerListScreen.dart'; // Import the PlayerListScreen widget
import 'package:web_project/models/quiz.dart';
import 'package:web_project/services/firebase_service.dart';
import 'package:web_project/widgets/quiz_card.dart';

class introPage extends StatefulWidget {
  @override
  _introPageState createState() => _introPageState();
}

class _introPageState extends State<introPage> {
  List<Quiz> quizzes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchQuizzes().then((fetchedQuizzes) {
      setState(() {
        quizzes = fetchedQuizzes;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Robophone Kahoot Game'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateQuizApp()),
              );
            },
            child: Text('Create Quiz'),
          ),
          ElevatedButton(
            onPressed: () {
              // Navigate to the PlayerListScreen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PlayerListScreen()),
              );
            },
            child: Text('Player List'),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: quizzes.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    QuizCard(quiz: quizzes[index]),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                GamePage(quiz: quizzes[index]),
                          ),
                        );
                      },
                      child: Text('Start Game'),
                    ),
                    SizedBox(height: 10.0), // Add some space between cards
                  ],
                );
              },
            ),
    );
  }
}

Widget _buildQuizDetails() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        widget.quiz.quizDetails.nameOfQuiz,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 8.0),
      Text('Number of Questions: ${widget.quiz.quizDetails.numOfQuestions}'),
      Text(
        'Time per Question: ${widget.quiz.quizDetails.timeToAnswerPerQuestion} seconds',
      ),
      SizedBox(height: 16.0),
      ElevatedButton(
        onPressed: _startCountdown,
        child: Text('Start Game'),
      ),
      ElevatedButton(
        // Add this button
        onPressed: _joinPlayers,
        child: Text('Join Players'),
      ),
    ],
  );
}

@override
void initState() {
  super.initState();
  // Fetch player details from the database and populate the players list.
  DatabaseReference playersRef =
      FirebaseDatabase.instance.ref().child('players');

  playersRef.once().then((DatabaseEvent event) {
    DataSnapshot snapshot = event.snapshot;
    if (snapshot.value != null && snapshot.value is Map) {
      Map<String, dynamic> playerData = snapshot.value as Map<String, dynamic>;
      playerData.forEach((key, value) {
        if (value != null && value is Map) {
          try {
            players.add(Player.fromMap(value as Map<String, dynamic>));
            //   username: value['username'],
            //   answers: [], //value['answers'],
            //   learn: 0, //value['learn'],
            //   rate: 0, //value['rate'],
            //   score: 0, // value['score'],
            // ));
          } catch (e) {
            print('Error parsing player: $e');
          }
        }
      });

      setState(() {
        // Refresh the UI with the fetched player data.
      });
    }
  }).catchError((error) {
    print('Error fetching players: $error');
    // Handle the error as needed.
  });
}

Future<List<Player>> fetchPlayerDetailsFromDatabase(String quizID) async {
  final playersRef = FirebaseDatabase.instance
      .ref()
      .child('Robophone/quizzes/$quizID/players');
  try {
    playersRef.onchildAdded.listen((event)
    {
      players
    })
   // DatabaseEvent event = await playersRef.once();
   // DataSnapshot snapshot = event.snapshot;
    //if (snapshot.value != null && snapshot.value is Map) {
      List<Player> players = [];
      Map<String, dynamic> playerData = snapshot.value as Map<String, dynamic>;
      print(playerData);

      playerData.forEach((key, value) {
        print(key);
        if (value != null && value is Map) {
          try {
            players.add(Player(
              //.fromMap(value as Map<String, dynamic>));
              username: value['username'],
              answers: [], //value['answers'],
              learn: 0, //value['learn'],
              rate: 0, //value['rate'],
              score: 0, // value['score'],
            ));
          } catch (e) {
            print('Error parsing player: $e');
          }
        }
      });

      return players;
    }
    return [];
  } catch (e) {
    print('Error fetching players: $e');
    // Handle the error as needed.
    return Future.error('Failed to load players');
  }
}


can you correct this function  ,i want to always listen to db to add players that join to the game:

Future<List<Player>> fetchPlayerDetailsFromDatabase(String quizID) async {
  final playersRef = FirebaseDatabase.instance
      .ref()
      .child('Robophone/quizzes/$quizID/players');
  try {
    playersRef.onChildAdded.listen((event) { 
    DataSnapshot snapshot = event.snapshot;
    if (snapshot.value != null && snapshot.value is Map) {
      List<Player> players = [];
      Map<String, dynamic> playerData = snapshot.value as Map<String, dynamic>;
      print(playerData);

      playerData.forEach((key, value) {
        print(key);
        if (value != null && value is Map) {
          try {
            players.add(Player(
              //.fromMap(value as Map<String, dynamic>));
              username: value['username'],
              answers: [], //value['answers'],
              learn: 0, //value['learn'],
              rate: 0, //value['rate'],
              score: 0, // value['score'],
            ));
          } catch (e) {
            print('Error parsing player: $e');
          }
        }
      });

      return players;
    }
    return [];
  } catch (e) {
    print('Error fetching players: $e');
    // Handle the error as needed.
    return Future.error('Failed to load players');
  }
}  



Stream<List<Player>> listenForPlayerDetailsFromDatabase(String quizID) {
  final playersRef = FirebaseDatabase.instance
      .ref()
      .child('Robophone/quizzes/$quizID/players');

  StreamController<List<Player>> controller = StreamController();

  playersRef.onChildAdded.listen((event) {
    DataSnapshot snapshot = event.snapshot;

    if (snapshot.value != null && snapshot.value is Map) {
      Map<String, dynamic> playerData = snapshot.value as Map<String, dynamic>;

      try {
        controller.sink.add(Player(
          username: playerData['username'],
          answers: [], // Add your logic for answers.
          learn: 0,    // Add your logic for learn.
          rate: 0,     // Add your logic for rate.
          score: 0,    // Add your logic for score.
        ));
      } catch (e) {
        print('Error parsing player: $e');
      }
    }
  });

  playersRef.onChildRemoved.listen((event) {
    // Handle removal of players if needed.
    // You can notify the UI to remove the player from the list.
  });

  return controller.stream;
}





import 'package:flutter/material.dart';
import 'package:web_project/models/player.dart'; // Make sure to import the Player model.
import 'package:firebase_database/firebase_database.dart';
import 'package:web_project/services/firebase_service.dart';

class PlayerListScreen extends StatefulWidget {
  final Quiz quiz;

  PlayerListScreen({required this.quiz});

  @override
  _PlayerListScreenState createState() => _PlayerListScreenState();
}

class _PlayerListScreenState extends State<PlayerListScreen> {
  List<Player> players = [];

  @override
  void initState() {
    super.initState();
    _startListeningForPlayers();
  }

  void _startListeningForPlayers() {
    listenForPlayerDetailsFromDatabase(widget.quiz.quizID).listen((fetchedPlayers) {
      setState(() {
        players = fetchedPlayers;
      });
    }, onError: (error) {
      print('Error fetching players: $error');
      // Handle error here, e.g., show an error message to the user.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Player List'),
      ),
      body: ListView.builder(
        itemCount: players.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(players[index].username),
          );
        },
      ),
    );
  }
}