import 'package:flutter/material.dart';

class DojoScreen extends StatelessWidget {
  const DojoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Lista temporal de cursos, TODO: Conectar BBDD
    final List<Map<String, String>> activeCourses = [
      {
        "title": "Fundamentos de Ciberseguridad",
        "lessons": "12/20",
        "belt": "Blanco",
      },
      {"title": "Protege tu Red Wi-Fi", "lessons": "8/15", "belt": "Amarillo"},
      {"title": "Navegación Segura", "lessons": "5/10", "belt": "Naranja"},
      {"title": "Phishing y Contraseñas", "lessons": "9/12", "belt": "Verde"},
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //  Título principal
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

          //  Grid de cursos
          Expanded(
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
                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xB3472D30),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //  Imagen TODO: añadir según BBDD
                      Container(
                        height: 70,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(height: 8),
                      //  Título
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
                      // Progreso y cinturón
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
                );
              },
            ),
          ),

          // Botón inferior
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 20),
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: navegar a la pantalla de cursos disponibles
              },
              icon: const Icon(Icons.explore, color: Color(0xFF472D30)),
              label: const Text(
                "Explorar más misiones",
                style: TextStyle(
                  color: Color(0xFF472D30),
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC9CBA3),
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 24,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
