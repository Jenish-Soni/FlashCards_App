class QuizQuestion {
  int? id;
  String question;
  String answer;

  QuizQuestion({this.id, required this.question, required this.answer});

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'answer': answer,
    };
  }
  QuizQuestion.fromMap(Map<String, dynamic> map)
      : id = map['_id'],
        question = map['question'],
        answer = map['answer'];
}
