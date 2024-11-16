class QuizQuestion {
  int? id;
  String question;
  String answer;

  QuizQuestion({this.id, required this.question, required this.answer});

  // Convert a QuizQuestion to a Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'answer': answer,
    };
  }

  // Convert a Map to a QuizQuestion object
  QuizQuestion.fromMap(Map<String, dynamic> map)
      : id = map['_id'],
        question = map['question'],
        answer = map['answer'];
}
