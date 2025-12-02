import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyber_dojo/models/course.dart';
import 'package:cyber_dojo/models/lesson.dart';
import 'package:flutter/material.dart';

class DojoCourseScreen extends StatefulWidget {
  final String courseId;
  final VoidCallback onBack;
  final void Function(
    String courseTitle,
    String idLeccion,
    String lessonTitle,
    String courseDescription,
    int numLeccionesTotal,
    List<String> courseMedals,
    List<int> courseBadges,
  )
  onLessonSelected;

  const DojoCourseScreen({
    super.key,
    required this.courseId,
    required this.onBack,
    required this.onLessonSelected,
  });

  @override
  State<DojoCourseScreen> createState() => _DojoCourseScreenState();
}

// Clase auxiliar para devolver Curso y Lecciones juntas
class CourseAndLessonsData {
  final CourseModel course;
  final List<LessonModel> lessons;

  CourseAndLessonsData(this.course, this.lessons);
}

class _DojoCourseScreenState extends State<DojoCourseScreen> {
  late Future<CourseAndLessonsData> _courseDataFuture;

  @override
  void initState() {
    super.initState();
    _courseDataFuture = _fetchCourseAndLessons();
  }

  // Función para obtener datos
  Future<CourseAndLessonsData> _fetchCourseAndLessons() async {
    // Obtener el CourseModel
    final courseDoc = await FirebaseFirestore.instance
        .collection('curso')
        .doc(widget.courseId)
        .get();

    if (!courseDoc.exists) {
      throw Exception("Course not found");
    }

    final course = CourseModel.fromFirestore(courseDoc);

    // Obtener las LessonModel (filtrando por id_curso y ordenando)
    final lessonsSnapshot = await FirebaseFirestore.instance
        .collection('leccion')
        .where('id_curso', isEqualTo: widget.courseId)
        .orderBy('orden_Curso')
        .get();

    final lessons = lessonsSnapshot.docs
        .map((doc) => LessonModel.fromFirestore(doc))
        .toList();

    return CourseAndLessonsData(course, lessons);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CourseAndLessonsData>(
      future: _courseDataFuture,
      builder: (context, snapshot) {
        // Manejo de estado de carga y error
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF723D46)),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              "Error al cargar el curso: ${snapshot.error}",
              style: const TextStyle(color: Color(0xFF472D30)),
            ),
          );
        }

        final data = snapshot.data!;
        final course = data.course;
        final lessons = data.lessons;

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fila superior con botón volver y título
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFF472D30),
                    ),
                    onPressed: widget.onBack,
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        course.titulo,
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
                  children: [
                    Row(
                      children: [
                        // Imagen
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            "https://picsum.photos/id/870/70/70",
                            height: 70,
                            width: 70,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                height: 70,
                                width: 70,
                                color: Colors.grey[300],
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Color(0xFF723D46),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Lecciones: ${course.numLecciones}",
                              style: TextStyle(color: Colors.white70),
                            ),
                            Text(
                              "Cinturón: ${course.nivel}",
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      course.descripcion,
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
                          widget.onLessonSelected(
                            course.titulo,
                            lesson.idLeccion,
                            lesson.titulo,
                            course.descripcion,
                            course.numLecciones,
                            (course.badgeIds)
                                .map((id) => id.toString())
                                .toList(),
                            course.badgeIds,
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Lección ${index + 1}: ${lesson.titulo}",
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
      },
    );
  }
}
