import 'package:cyber_dojo/screens/homeCourses/courses_screen.dart';
import 'package:cyber_dojo/screens/main_screen.dart';
import 'package:flutter/material.dart';

class DojoScreen extends StatelessWidget {
  final void Function(String) onCourseSelected;
  final VoidCallback onExploreCourses;

  const DojoScreen({super.key, required this.onCourseSelected, required this.onExploreCourses});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> activeCourses = [
      {"title": "Fundamentos de Ciberseguridad", "lessons": "12/20","belt": "Blanco",},
      {"title": "Protege tu Red Wi-Fi", "lessons": "8/15", "belt": "Amarillo"},
      {"title": "Navegación Segura", "lessons": "5/10", "belt": "Naranja"},
      {"title": "Phishing y Contraseñas", "lessons": "9/12", "belt": "Verde"},
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text(
              "Tu entrenamiento en curso",
              style: TextStyle(
                color: Color(0xFF472D30),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Flexible(
            fit: FlexFit.loose,
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.8,
              ),
              itemCount: activeCourses.length,
              itemBuilder: (context, index) {
                final course = activeCourses[index];
                return GestureDetector(
                  onTap: () => onCourseSelected(course["title"]!),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xB3472D30),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 70,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
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
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "${course["lessons"]} lecciones",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          "Cinturón: ${course["belt"]}",
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
          ),

          const SizedBox(height: 16),

          //Botón "explorar más misiones"
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onExploreCourses,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF472D30),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: const Offset(0, 3),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/buttonsIcons/ninjaIcon.png", 
                    height: 26,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Explorar más misiones",
                    style: TextStyle(
                      color: Color(0xFFFFE1A8),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
