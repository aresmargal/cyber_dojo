import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

//TODO: Conectar con BBDD

class _HomeScreenState extends State<HomeScreen> {
  final String username = "@LydiaNinja";
  final int trainingStreak = 5;

  // Datos de ejemplo
  final List<Map<String, dynamic>> currentCourses = [
    {
      "title": "Fundamentos de la red",
      "lessons": "15/20 lecciones",
      "belt": "Cinturón: Blanco",
    },
    {
      "title": "Defensa básica",
      "lessons": "8/15 lecciones",
      "belt": "Cinturón: Amarillo",
    },
    {
      "title": "Amenazas comunes",
      "lessons": "10/18 lecciones",
      "belt": "Cinturón: Verde",
    },
  ];

  final List<Map<String, dynamic>> newCourses = [
    {
      "title": "Cifrado y contraseñas",
      "lessons": "0/10 lecciones",
      "belt": "Cinturón: Blanco",
    },
    {
      "title": "Seguridad móvil",
      "lessons": "0/12 lecciones",
      "belt": "Cinturón: Blanco",
    },
    {
      "title": "Internet seguro",
      "lessons": "0/9 lecciones",
      "belt": "Cinturón: Blanco",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE1A8),
      

      // Contenido principal
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Tu entrenamiento en curso ---
            _buildSectionTitle("Tu entrenamiento en curso", "Ver todos"),
            const SizedBox(height: 10),
            _buildCoursesList(currentCourses),

            const SizedBox(height: 15),

            // --- Nuevas misiones ---
            _buildSectionTitle("Nuevas misiones", "Ver todos"),
            const SizedBox(height: 10),
            _buildCoursesList(newCourses),

            const SizedBox(height: 15),

            // --- Ciberconsejo del día ---
            const Text(
              "Ciber-consejo ninja del día",
              style: TextStyle(
                color: Color(0xFF723D46),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Container(
  decoration: BoxDecoration(
    color: const Color(0xB3472D30),
    borderRadius: BorderRadius.circular(16),
  ),
  padding: const EdgeInsets.all(16),
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      // Imagen del consejo (segura)
      ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          'assets/images/homeFiles/consejo.png',
          width: 70,
          height: 70,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 70,
              height: 70,
              color: Colors.white24,
              child: const Icon(Icons.lightbulb, color: Colors.white, size: 36),
            );
          },
        ),
      ),
      const SizedBox(width: 16),
      // Texto del consejo
      const Expanded(
        child: Text(
          "Nunca compartas tus contraseñas, ni siquiera con tus amigos. "
          "Usa contraseñas únicas y seguras en cada cuenta.",
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            height: 1.4,
          ),
        ),
      ),
    ],
  ),
)
          ],
        ),
      ),
    );
  }

  // Widget reutilizable: título + “ver todos”
  Widget _buildSectionTitle(String title, String action) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF723D46),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            action,
            style: const TextStyle(
              color: Color(0xFF472D30),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // Widget reutilizable: lista horizontal de cursos
  Widget _buildCoursesList(List<Map<String, dynamic>> courses) {
    return SizedBox(
      height: 184,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return Container(
            width: 140,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: const Color(0xB3472D30), // 70%
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TODO: Imagen del curso (cuadrado temporal)
                Container(
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  course["title"],
                  style: const TextStyle(
                    color: Color(0xFFFFE1A8),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  course["lessons"],
                  style: const TextStyle(
                    color: Color(0xFFFFE1A8),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  course["belt"],
                  style: const TextStyle(
                    color: Color(0xFFFFE1A8),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
