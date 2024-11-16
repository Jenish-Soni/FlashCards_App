import 'package:flutter/material.dart';

class Flashcard extends StatelessWidget {
  final int quizId;
  final String question;
  final String answer;
  final bool isAnswerVisible;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const Flashcard({
    super.key,
    required this.quizId,
    required this.question,
    required this.answer,
    required this.isAnswerVisible,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          // Front of the card (question)
          _buildCardSide(
            key: const ValueKey('front'),
            content: question,
            isFront: true,
            isVisible: !isAnswerVisible,
          ),
          // Back of the card (answer)
          _buildCardSide(
            key: const ValueKey('back'),
            content: answer,
            isFront: false,
            isVisible: isAnswerVisible,
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: onDelete,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardSide({
    required Key key,
    required String content,
    required bool isFront,
    required bool isVisible,
  }) {
    return Visibility(
      visible: isVisible,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 600),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              key: key,
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                color: Colors.blue.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  content,
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 20,
                    fontWeight: isFront ? FontWeight.normal : FontWeight.bold,
                    color: isFront ? Colors.black : Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
