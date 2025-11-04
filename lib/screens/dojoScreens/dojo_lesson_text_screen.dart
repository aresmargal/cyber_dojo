import 'package:flutter/material.dart';

class DojoLessonTextScreen extends StatelessWidget {
  final String courseTitle;
  final String lessonTitle;
  final String lessonText;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const DojoLessonTextScreen({
    super.key,
    required this.courseTitle,
    required this.lessonTitle,
    required this.lessonText,
    required this.onNext,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //  Fila superior, botón y título
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF472D30)),
                onPressed: onBack,
              ),
              Expanded(
                child: Center(
                  child: Text(
                    courseTitle,
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

          // Nombre de la lección
          Text(
            lessonTitle,
            style: const TextStyle(
              color: Color(0xFF472D30),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 16),

          //  Bloque principal
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xB3472D30),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Imagen superior
                    Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      // image.png
                    ),
                    const SizedBox(height: 12),

                    // Texto de la lección
                    Text(
                      lessonText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Botón circular
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: onNext,
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
    );
  }
}
