import 'package:flutter/material.dart';

import '../core/db_helper.dart';
import '../widget/edit_quiz.dart';
import '../widget/flashcard.dart';
import 'add_quiz.dart'; // Import the edit quiz screen

class FlashcardsList extends StatefulWidget {
  const FlashcardsList({super.key});

  @override
  State<FlashcardsList> createState() => _FlashcardsListState();
}

class _FlashcardsListState extends State<FlashcardsList> {
  late Future<List<Map<String, dynamic>>> _quizList;
  Map<int, bool> _isAnswerVisible = {}; // Track visibility state of each answer

  @override
  void initState() {
    super.initState();
    _loadQuizData();
  }

  // Load quiz data from the database
  _loadQuizData() {
    setState(() {
      _quizList = DatabaseHelper.instance.queryAllRows();
    });
  }

  // Toggle the visibility of the answer for a specific quiz question
  void _toggleAnswerVisibility(int quizId) {
    setState(() {
      bool currentVisibility = _isAnswerVisible[quizId] ?? false;
      _isAnswerVisible[quizId] = !currentVisibility;
    });
  }

  // Delete quiz item from the database
  void _deleteQuiz(int quizId) async {
    await DatabaseHelper.instance.delete(quizId);
    _loadQuizData(); // Reload the quiz list after deletion
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Quizzard",
          style: TextStyle(
            fontFamily: 'Lato',
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const AddQuiz())).then((_) {
                _loadQuizData(); // Reload data after adding a new quiz question
              });
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _quizList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var quiz = snapshot.data![index];
                int quizId = quiz['_id'] ?? -1;
                bool isAnswerVisible = _isAnswerVisible[quizId] ?? false;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Flashcard(
                    quizId: quizId,
                    question: quiz['question'],
                    answer: quiz['answer'],
                    isAnswerVisible: isAnswerVisible,
                    onTap: () {
                      _toggleAnswerVisibility(quizId); // Toggle answer visibility on tap
                    },
                    onEdit: () async {
                      // Navigate to the Edit Quiz screen
                      var updatedQuiz = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditQuiz(
                            quizId: quizId,
                            question: quiz['question'],
                            answer: quiz['answer'],
                          ),
                        ),
                      );

                      if (updatedQuiz != null) {
                        // Update the quiz in the database after editing
                        await DatabaseHelper.instance.update(updatedQuiz);
                        _loadQuizData(); // Reload the quiz data
                      }
                    },
                    onDelete: () {
                      _deleteQuiz(quizId); // Delete quiz item from database
                    },
                  ),
                );
              },
            );
          }

          return const Center(child: Text('No quizzes available.'));
        },
      ),
    );
  }
}
