import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyber_dojo/models/course.dart';
import 'package:cyber_dojo/models/user.dart';
import 'package:cyber_dojo/screens/homeCourses/course_detail_screen.dart';
import 'package:flutter/material.dart';

// Clase de ayuda para el FutureBuilder, ya que contiene dos listas
class CourseData {
  final List<CourseModel> currentCourses;
  final List<CourseModel> newCourses;

  CourseData(this.currentCourses, this.newCourses);
}

class HomeScreen extends StatefulWidget {
  final void Function(String) onCourseSelected;
  final UserModel currentUser;
  final VoidCallback onExploreCourses;
  final VoidCallback onGoToDojo;

  const HomeScreen({
    super.key,
    required this.onCourseSelected,
    required this.currentUser,
    required this.onExploreCourses,
    required this.onGoToDojo,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<CourseData> _coursesFuture;

  void _rechargeCourses() {
    setState(() {
      _coursesFuture = _fetchAndFilterCourses();
    });
  }

  @override
  void initState() {
    super.initState();
    _coursesFuture = _fetchAndFilterCourses();
  }

  // Función asíncrona para obtener y clasificar los cursos
  Future<CourseData> _fetchAndFilterCourses() async {
    try {
      // Obtener la últimna versión del progreso del usuario
    final userDoc = await FirebaseFirestore.instance
        .collection('users') // Usar 'users', como confirmaste
        .doc(widget.currentUser.id)
        .get();

    final userProgress = userDoc.data()?['progreso_cursos'] as Map<String, dynamic>? ?? {};

      // Obtener todos los cursos de Firestore
      final courseSnapshot = await FirebaseFirestore.instance
          .collection('curso')
          .orderBy('titulo')
          .get();

      final allCourses = courseSnapshot.docs
          .map((doc) => CourseModel.fromFirestore(doc))
          .toList();

      List<CourseModel> currentCourses = [];
      List<CourseModel> newCourses = [];

      // Clasificar los cursos
      for (var course in allCourses) {
        final courseId = course.idCurso;

        if (userProgress.containsKey(courseId)) {
          // Si el curso tiene progreso (iniciado o completado), va a currentCourses
          currentCourses.add(course);
        } else {
          // Si no tiene progreso registrado, es un curso nuevo
          newCourses.add(course);
        }
      }

      // Devolver los datos clasificados
      return CourseData(
        currentCourses.take(3).toList(),
        newCourses.take(3).toList(),
      );
    } catch (e) {
      // Devolver listas vacías en caso de error
      return CourseData([], []);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE1A8),

      body: FutureBuilder<CourseData>(
        future: _coursesFuture,
        builder: (context, snapshot) {
          // Estado de Carga
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF723D46)),
            );
          }

          // Estado de Error
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error al cargar las misiones: ${snapshot.error}",
                style: TextStyle(color: Color(0xFF472D30)),
              ),
            );
          }

          // Estado de Datos Listos
          final courseData = snapshot.data ?? CourseData([], []);
          final currentCourses = courseData.currentCourses;
          final newCourses = courseData.newCourses;

          // Contenido principal
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Tu entrenamiento en curso ---
                _buildSectionTitle("Tu entrenamiento en curso", "Ver todos"),
                const SizedBox(height: 10),
                _buildCoursesList(currentCourses, true),

                const SizedBox(height: 15),

                // --- Nuevas misiones ---
                _buildSectionTitle("Nuevas misiones", "Ver todos"),
                const SizedBox(height: 10),
                _buildCoursesList(newCourses, false),

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
                        child: Image.network(
                          'https://raw.githubusercontent.com/aresmargal/cyber_dojo_assets/main/buttons/consejo.png',
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 70,
                              height: 70,
                              color: Colors.white24,
                              child: const Icon(
                                Icons.lightbulb,
                                color: Colors.white,
                                size: 36,
                              ),
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
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Widget reutilizable: título + “ver todos”
  Widget _buildSectionTitle(String title, String action) {
    // Determinar la acción basándose en el título de la sección
    VoidCallback? onTapAction;

    if (title == "Nuevas misiones") {
      onTapAction =
          widget.onExploreCourses;
    } else if (title == "Tu entrenamiento en curso") {
      onTapAction = widget.onGoToDojo;
    }

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
          onPressed: onTapAction,
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
  Widget _buildCoursesList(List<CourseModel> courses, bool isCurrentCourses) {
    final userProgress = widget.currentUser.progresoCursos ?? {};

    return SizedBox(
      height: 192,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          final courseId = course.idCurso;

          // Obtener el mapa de progreso específico para este curso
          final courseProgress = userProgress[courseId];

          // Determinar el estado del curso
          final isCompleted = courseProgress != null
              ? courseProgress['completado'] ?? false
              : false;

          final progressDisplay = isCompleted
              ? "Finalizado"
              : "Nivel: ${course.nivel}"; // Si no está completado, muestra el nivel

          return GestureDetector(
            onTap: () {
              if (isCurrentCourses) {
              // Llama al callback para ir al flujo de Dojo (lecciones)
              widget.onCourseSelected(course.titulo);
            } else {
              // Navega directamente a la pantalla de detalles (sin iniciar el curso)
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CourseDetailScreen(
                    courseId: course.idCurso, 
                    currentUserId: widget.currentUser.id,
                  ),
                ),
              ).then((result){
                if (result == true) _rechargeCourses();
              });
            }
            },
            child: Container(
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
                    course.titulo,
                    style: const TextStyle(
                      color: Color(0xFFFFE1A8),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "${course.numLecciones} lecciones",
                    style: const TextStyle(
                      color: Color(0xFFFFE1A8),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    progressDisplay, // Usamos la variable determinada
                    style: TextStyle(
                      color: isCompleted
                          ? Colors.greenAccent
                          : const Color(
                              0xFFFFE1A8,
                            ), // Color distinto si está finalizado
                      fontSize: 13,
                      fontWeight: isCompleted
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
