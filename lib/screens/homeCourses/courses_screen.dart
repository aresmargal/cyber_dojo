import 'package:cyber_dojo/screens/homeCourses/course_detail_screen.dart';
import 'package:flutter/material.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  final List<Map<String, dynamic>> courses = [
    {
      "title": "Contraseñas Seguras",
      "lessons": "15 lecciones",
      "belt": "Cinturón: Blanco",
    },
    {
      "title": "Phishing y Engaños",
      "lessons": "20 lecciones",
      "belt": "Cinturón: Amarillo",
    },
    {
      "title": "Redes Seguras",
      "lessons": "18 lecciones",
      "belt": "Cinturón: Naranja",
    },
    {
      "title": "Protege tus Datos",
      "lessons": "12 lecciones",
      "belt": "Cinturón: Verde",
    },
    {
      "title": "Ciberataques Comunes",
      "lessons": "22 lecciones",
      "belt": "Cinturón: Azul",
    },
    {
      "title": "Privacidad en Internet",
      "lessons": "10 lecciones",
      "belt": "Cinturón: Marrón",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Título principal
          const SizedBox(height: 8),
          const Text(
            "Nuevas misiones disponibles",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF472D30),
            ),
          ),
          const SizedBox(height: 20),

          // Grid de cursos
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, 
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.8,
            ),
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final course = courses[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const CourseDetailScreen()),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xB3472D30),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Imagen 
                      Container(
                        height: 90,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        course["title"]!,
                        style: const TextStyle(
                          color: Color(0xFFFFE1A8),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        course["lessons"]!,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        course["belt"]!,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}