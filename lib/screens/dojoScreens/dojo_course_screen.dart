import 'package:flutter/material.dart';

class DojoCourseScreen extends StatelessWidget {
  final String courseTitle;
  final VoidCallback onBack;
  final void Function(Map<String, String> lesson) onLessonSelected;

  const DojoCourseScreen({
    super.key,
    required this.courseTitle,
    required this.onBack,
    required this.onLessonSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Lista temporal de lecciones
    final List<Map<String, String>> lessons = [
      {"title": "Introducción a la ciberseguridad"},
      {"title": "Contraseñas seguras"},
      {"title": "Phishing y correos falsos"},
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fila superior con botón volver y título
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

          // Bloque de información del curso
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xB3472D30),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Row(
                  children: [
                    SizedBox(
                      height: 70,
                      width: 70,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Lecciones: 3",
                            style: TextStyle(color: Colors.white70)),
                        Text("Cinturón: Blanco",
                            style: TextStyle(color: Colors.white70)),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  "Aprende las bases de la ciberseguridad y cómo proteger tus datos.",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Lista lecciones
          Expanded(
            child: ListView.builder(
              itemCount: lessons.length,
              itemBuilder: (context, index) {
                final lesson = lessons[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xB3472D30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
                    ),
                    onPressed: () {
                      onLessonSelected({
                        "title": lesson["title"]!,
                        "text":
                            "Aquí irá el contenido de la lección '${lesson["title"]}'.",
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Lección ${index + 1}: ${lesson["title"]}",
                          style: const TextStyle(
                            color: Color(0xFFFFE1A8),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Color(0xFFFFE1A8),
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
