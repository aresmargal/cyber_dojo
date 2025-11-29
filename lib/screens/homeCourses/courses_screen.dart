import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyber_dojo/models/course.dart';
import 'package:cyber_dojo/models/user.dart';
import 'package:cyber_dojo/screens/homeCourses/course_detail_screen.dart';
import 'package:flutter/material.dart';

class CoursesScreen extends StatefulWidget {
  final void Function(String) onCourseSelected;
  final UserModel currentUser;

  const CoursesScreen({
    super.key,
    required this.onCourseSelected,
    required this.currentUser,
  });

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  late Future<List<CourseModel>> _newCoursesFuture;

  @override
  void initState() {
    super.initState();
    _newCoursesFuture = _fetchNewCourses();
  }

  Future<List<CourseModel>> _fetchNewCourses() async {
    try {
      final courseSnapshot = await FirebaseFirestore.instance
          .collection('curso')
          .orderBy('titulo')
          .get();

      final allCourses = courseSnapshot.docs
          .map((doc) => CourseModel.fromFirestore(doc))
          .toList();

      // Obtener el progreso del usuario
      final userProgress = widget.currentUser.progresoCursos ?? {};

      List<CourseModel> newCourses = [];

      // Filtrar: Añadir solo si NO tiene progreso (no iniciado ni completado)
      for (var course in allCourses) {
        if (!userProgress.containsKey(course.idCurso)) {
          newCourses.add(course);
        }
      }

      return newCourses;
    } catch (e) {
      return [];
    }
  }

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

          // --- FutureBuilder para la lista de cursos ---
          FutureBuilder<List<CourseModel>>(
            future: _newCoursesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF723D46)),
                );
              }

              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }

              final courses = snapshot.data ?? [];

              if (courses.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: Text(
                      "Has completado todas las misiones disponibles",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF723D46), fontSize: 16),
                    ),
                  ),
                );
              }

              // Grid de cursos
              return GridView.builder(
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CourseDetailScreen(),
                        ),
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
                            course.titulo,
                            style: const TextStyle(
                              color: Color(0xFFFFE1A8),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${course.numLecciones} lecciones",
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            "Nivel: ${course.nivel}",
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
              );
            },
          ),
        ],
      ),
    );
  }
}
