import 'package:flutter/material.dart';
import '../core/db_helper.dart';

class EditQuiz extends StatefulWidget {
  final int quizId;
  final String question;
  final String answer;

  const EditQuiz({
    super.key,
    required this.quizId,
    required this.question,
    required this.answer,
  });

  @override
  State<EditQuiz> createState() => _EditQuizState();
}

class _EditQuizState extends State<EditQuiz> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController questionController = TextEditingController();
  final TextEditingController answerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    questionController.text = widget.question;
    answerController.text = widget.answer;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Quiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: questionController,
                decoration: const InputDecoration(
                  labelText: 'Question',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the question';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: answerController,
                decoration: const InputDecoration(
                  labelText: 'Answer',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the answer';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Update the quiz item in the database
                    final updatedQuiz = {
                      '_id': widget.quizId,
                      'question': questionController.text,
                      'answer': answerController.text,
                    };

                    DatabaseHelper.instance.update(updatedQuiz);

                    Navigator.pop(context, updatedQuiz); // Return the updated quiz
                  }
                },
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
