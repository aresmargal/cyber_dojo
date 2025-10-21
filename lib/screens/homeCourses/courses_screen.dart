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

  int _selectedIndex = 1; // índice del menú inferior (Cursos)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE1A8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF723D46),
        title: const Text(
          "Nuevas misiones disponibles",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: courses.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, 
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.75, 
          ),
          itemBuilder: (context, index) {
            final course = courses[index];
            return GestureDetector(
              onTap: () {
                // TODO: la navegación a la pantalla de detalle del curso
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CourseDetailScreen(course: course),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xB3472D30),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(10),
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
                    // Título
                    Text(
                      course["title"],
                      style: const TextStyle(
                        color: Color(0xFFFFE1A8),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    // Número de lecciones
                    Text(
                      course["lessons"],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Cinturón
                    Text(
                      course["belt"],
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

      // Menú inferior
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF723D46),
        selectedItemColor: const Color(0xFFFFE1A8),
        unselectedItemColor: Colors.white70,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Inicio",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Cursos",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Logros",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Ajustes",
          ),
        ],
      ),
    );
  }
}

class CourseDetailScreen extends StatelessWidget {
  final Map<String, dynamic> course;
  const CourseDetailScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE1A8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF723D46),
        title: Text(
          course["title"],
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          "Pantalla de detalles del curso:\n${course["title"]}",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
