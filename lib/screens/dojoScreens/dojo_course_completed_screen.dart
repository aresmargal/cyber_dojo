import 'package:flutter/material.dart';

class DojoCourseCompletedScreen extends StatelessWidget {
  final String courseTitle;
  final String courseDescription;
  final String courseImage;
  final List<String> medals;
  final VoidCallback onBackToCourses;

  const DojoCourseCompletedScreen({
    super.key,
    required this.courseTitle,
    required this.courseDescription,
    required this.courseImage,
    required this.medals,
    required this.onBackToCourses,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Texto superior
          Center(
            child: Text(
              "Felicidades, has completado...",
              style: const TextStyle(
                color: Color(0xFF472D30),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 8),

          Center(
            child: Text(
              courseTitle,
              style: const TextStyle(
                color: Color(0xFF723D46),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Ficha del curso
          Container(
                decoration: BoxDecoration(
                  color: const Color(0xB3472D30),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Imagen cuadrada
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Info a la derecha
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Lecciones: 15",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              "Cinturón: Amarillo",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Aprende las bases esenciales de la ciberseguridad y descubre cómo protegerte en línea. Este curso te convertirá en un verdadero ninja digital.",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),


          const SizedBox(height: 32),

          // Medallas ganadas
          const Text(
            "Medallas que has ganado",
            style: TextStyle(
              color: Color(0xFF472D30),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.9,
            ),
            itemCount: 6, // número de medallas dummy
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: const Color(0xB3472D30),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Medalla ${index + 1}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 32),

          // Botón para volver
          Center(
            child: ElevatedButton(
              onPressed: onBackToCourses,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF723D46),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Volver al Dojo",
                style: TextStyle(
                  color: Color(0xFFFFE1A8),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
