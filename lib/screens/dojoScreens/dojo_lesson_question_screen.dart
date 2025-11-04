import 'package:flutter/material.dart';

class DojoLessonQuestionScreen extends StatefulWidget {
  final String courseTitle;
  final String lessonTitle;
  final String questionText;
  final List<String> options;
  final int correctAnswerIndex;
  final VoidCallback onBack;
  final VoidCallback onNext;

  const DojoLessonQuestionScreen({
    super.key,
    required this.courseTitle,
    required this.lessonTitle,
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
    required this.onBack,
    required this.onNext,
  });

  @override
  State<DojoLessonQuestionScreen> createState() =>
      _DojoLessonQuestionScreenState();
}

class _DojoLessonQuestionScreenState extends State<DojoLessonQuestionScreen> {
  int? _selectedIndex;
  bool _isAnswered = false;
  bool _isCorrect = false;

  void _checkAnswer() {
    if (_selectedIndex == null) return;

    setState(() {
      _isAnswered = true;
      _isCorrect = _selectedIndex == widget.correctAnswerIndex;
    });

    if (!_isCorrect) {
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _isAnswered = false; // reactivar opciones si no es correcta
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color(0xFF472D30)),
                  onPressed: widget.onBack,
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      widget.courseTitle,
                      style: const TextStyle(
                        color: Color(0xFF472D30),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),

            const SizedBox(height: 12),

            Text(
              widget.lessonTitle,
              style: const TextStyle(
                color: Color(0xFF472D30),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 16),

            // Bloque de pregunta
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF472D30),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              child: Text(
                widget.questionText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  height: 1.4,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Opciones
            ...List.generate(widget.options.length, (index) {
              final isSelected = _selectedIndex == index;
              Color optionColor;

              if (_isAnswered) {
                 optionColor = isSelected
                    ? (_isCorrect
                        ? const Color(0xFF472D30) // correcto
                        : Colors.red.shade900.withOpacity(0.8)) // incorrecto
                    : const Color(0x80723D46);
              } else {
                optionColor = isSelected
                    ? const Color(0xB3472D30)
                    : const Color(0x80723D46);
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: GestureDetector(
                  onTap: () {
                    if (!_isAnswered) {
                      setState(() => _selectedIndex = index);
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: optionColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 16,
                    ),
                    child: Text(
                      widget.options[index],
                      style: const TextStyle(
                        color: Color(0xFFFFE1A8),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              );
            }),

            const SizedBox(height: 12),

            // Botón "Corregir"
            Center(
              child: ElevatedButton(
                onPressed: _isAnswered ? null : _checkAnswer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF723D46),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Corregir",
                  style: TextStyle(
                    color: Color(0xFFFFE1A8),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            // Mensaje correcto / incorrecto
            if (_isAnswered) ...[
              const SizedBox(height: 16),
              Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: _isCorrect
                        ? Colors.green.shade700
                        : Colors.red.shade800,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _isCorrect
                        ? "¡Correcto, puedes seguir!"
                        : "Incorrecto, prueba de nuevo.",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],

            const Spacer(),

            //  Botón circular inferior
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: _isCorrect ? widget.onNext : null,
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: const Color(0xFF472D30),
                  padding: const EdgeInsets.all(16),
                ),
                child: const Icon(
                  Icons.arrow_forward,
                  color: Color(0xFFC9CBA3),
                  size: 28,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
