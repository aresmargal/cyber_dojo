import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyber_dojo/models/course.dart';
import 'package:cyber_dojo/models/user.dart';
import 'package:flutter/material.dart';

class DojoScreen extends StatefulWidget {
  final void Function(String courseId, String courseTitle) onCourseSelected;
  final VoidCallback onExploreCourses;
  final UserModel currentUser;

  const DojoScreen({
    super.key,
    required this.onCourseSelected,
    required this.onExploreCourses,
    required this.currentUser,
  });

  @override
  State<DojoScreen> createState() => _DojoScreenState();
}

class _DojoScreenState extends State<DojoScreen> {
  // Stream para obtener la estructura de progreso del usuario en tiempo real
  Stream<Map<String, dynamic>> _userProgressStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(widget.currentUser.id)
        .snapshots()
        .map((snapshot) {
          // Devuelve solo el mapa progreso_cursos
          return snapshot.data()?['progreso_cursos'] as Map<String, dynamic>? ?? {};
        });
  }

  // Función para obtener los cursos activos del usuario
  Stream<List<Map<String, dynamic>>> _getActiveCoursesStream() async* {
    // Escucha el progreso del usuario
    await for (final userProgress in _userProgressStream()) {
      final activeCourseIds = userProgress.keys.toList();

      if (activeCourseIds.isEmpty) {
        yield []; // Si no hay cursos activos, devuelve la lista vacía
        continue;
      }

      // Buscar los detalles de todos los cursos en paralelo
      final List<Future<DocumentSnapshot<Map<String, dynamic>>>> courseFutures =
          activeCourseIds
              .map(
                (id) => FirebaseFirestore.instance
                    .collection('curso')
                    .doc(id)
                    .get(),
              )
              .toList();

      final List<DocumentSnapshot<Map<String, dynamic>>> courseDocs =
          await Future.wait(courseFutures);

      final List<Map<String, dynamic>> coursesData = [];
      for (var doc in courseDocs) {
        if (doc.exists) {
          final courseModel = CourseModel.fromFirestore(doc);
          final courseId = doc.id;
          final progress = userProgress[courseId];

          // Obtener el estado y el progreso
          final completedLessons =
              progress?['lecciones_completadas'] as int? ?? 0;
          final isCompleted = progress?['completado'] as bool? ?? false;

          // Formatear los datos
          coursesData.add({
            "id": courseId,
            "title": courseModel.titulo,
            "lessons": "$completedLessons/${courseModel.numLecciones}",
            "belt": courseModel.nivel,
            "isCompleted": isCompleted,
          });
        }
      }

      yield coursesData;
    }
  }

  @override
  Widget build(BuildContext context) {
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

          // StreamBuilder para cargar los datos
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _getActiveCoursesStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  print('Error al cargar los cursos: ${snapshot.error}');
                  return const Center(
                    child: Text("Error al cargar los cursos."),
                  );
                }

                // Si no hay datos (cursos activos)
                final activeCourses = snapshot.data ?? [];
                if (activeCourses.isEmpty) {
                  return Center(
                    child: Text(
                      "¡No tienes misiones en curso! \nVe a 'Misiones' para empezar.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF472D30).withOpacity(0.7),
                        fontSize: 16,
                      ),
                    ),
                  );
                }

                return GridView.builder(
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
                    final isCompleted = course['isCompleted'] as bool;

                    final progressDisplay = isCompleted
                        ? "Finalizado"
                        : "${course["lessons"]} lecciones";
                    final progressColor = isCompleted
                        ? Colors.greenAccent
                        : Colors.white70;

                    return GestureDetector(
                      onTap: () => widget.onCourseSelected(
                        course["id"]!,
                        course["title"]!,
                      ),
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
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                "https://picsum.photos/300/70?random=" + index.toString(),
                                height: 70,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        height: 70,
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
                              progressDisplay,
                              style: TextStyle(
                                color: progressColor,
                                fontSize: 12,
                                fontWeight: isCompleted
                                    ? FontWeight.bold
                                    : FontWeight.normal,
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
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          //Botón "explorar más misiones"
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: widget.onExploreCourses,
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
                  Image.network(
                    "https://raw.githubusercontent.com/aresmargal/cyber_dojo_assets/main/buttons/ninjaIcon.png",
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
