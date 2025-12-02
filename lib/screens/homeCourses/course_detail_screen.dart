import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyber_dojo/models/badge.dart';
import 'package:cyber_dojo/models/course.dart';
import 'package:flutter/material.dart';

class CourseDetailScreen extends StatefulWidget {
  final String courseId;
  final String currentUserId;

  const CourseDetailScreen({
    super.key,
    required this.courseId,
    required this.currentUserId,
  });

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  late Future<Map<String, dynamic>> _courseDataFuture;
  bool _isAdding = false; // Variable para controlar el estado del botón
  bool _isCourseAdded = false; //Variable para saber si el curso ya fue añadido

  @override
  void initState() {
    super.initState();
    _courseDataFuture = _fetchCourseDetails(widget.courseId);
  }

  // Función para obtener detalles del curso y sus medallas
  Future<Map<String, dynamic>> _fetchCourseDetails(String courseId) async {
    // Obtener datos del curso
    final courseDoc = await FirebaseFirestore.instance
        .collection('curso')
        .doc(courseId)
        .get();

    if (!courseDoc.exists) {
      throw Exception("Curso no encontrado.");
    }

    final course = CourseModel.fromFirestore(courseDoc);

    // Obtener datos de las medallas
    List<BadgeModel> badges = [];
    if (course.badgeIds.isNotEmpty) {
      final badgesSnapshot = await FirebaseFirestore.instance
          .collection('badge')
          .where('ID_badge', whereIn: course.badgeIds)
          .get();

      badges = badgesSnapshot.docs
          .map((doc) => BadgeModel.fromFirestore(doc))
          .toList();
    }

    return {'course': course, 'badges': badges};
  }

  // Función para añadir el curso al perfil del usuario
  Future<void> _addCourseToDojo(CourseModel course) async {
    if (_isAdding) return; // Evita clics múltiples

    setState(() {
      _isAdding = true;
    });

    try {
      final userRef = FirebaseFirestore.instance
          .collection('users')
          .doc(widget.currentUserId);

      await userRef.update({
        'progreso_cursos.${widget.courseId}': {
          'completado': false,
          'lecciones_completadas': 0,
          'total_lecciones': course.numLecciones,
        },
      });

      setState(() {
        _isCourseAdded = true;
      });

      // Mostrar SnackBar de éxito
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Misión añadida al dojo con éxito!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context, true);
      }
    } catch (e) {
      // Mostrar SnackBar de error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al añadir misión: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isAdding = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE1A8),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _courseDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF723D46)),
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Curso no disponible.'));
          }

          // Datos cargados exitosamente
          final course = snapshot.data!['course'] as CourseModel;
          final badges = snapshot.data!['badges'] as List<BadgeModel>;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Barra superior con botón atrás + título
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Color(0xFF472D30),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Text(
                          course.titulo,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFF472D30),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Bloque principal del curso
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
                            //Imagen
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                "https://picsum.photos/id/401/100/100",
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        height: 100,
                                        width: 100,
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
                            const SizedBox(width: 16),
                            // Info a la derecha
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Lecciones: ${course.numLecciones}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  "Cinturón: ${course.nivel}",
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
                        Text(
                          course.descripcion,
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Sección de medallas
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Medallas que puedes ganar",
                      style: TextStyle(
                        color: Color(0xFF472D30),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  badges.isEmpty
                      ? const Text(
                          "Este curso no otorga medallas aún",
                          style: TextStyle(color: Color(0xFF472D30)),
                        )
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: 0.9,
                              ),
                          itemCount: badges.length,
                          itemBuilder: (context, index) {
                            final badge = badges[index];
                            return _buildBadgeItem(badge);
                          },
                        ),

                  const SizedBox(height: 30),

                  // Botón “Añadir misión al dojo”
                  ElevatedButton.icon(
                    onPressed: _isCourseAdded || _isAdding
                        ? null
                        : () => _addCourseToDojo(course),
                    icon: Icon(
                      _isCourseAdded
                          ? Icons.check_circle
                          : Icons.add_circle_outline,
                      color: _isCourseAdded
                          ? Colors.white
                          : const Color(0xFF472D30),
                    ),
                    label: Text(
                      _isAdding
                          ? "Añadiendo..."
                          : _isCourseAdded
                          ? "Misión añadida"
                          : "Añadir misión al dojo",
                      style: TextStyle(
                        color: _isCourseAdded
                            ? Colors.white
                            : const Color(0xFF472D30),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isCourseAdded
                          ? const Color(0xFF723D46)
                          : const Color(0xFFC9CBA3),
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 24,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Widget auxiliar para construir cada medalla
  Widget _buildBadgeItem(BadgeModel badge) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xB3472D30),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Imagen de la medalla
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.network(
              badge.urlImagen,
              height: 50,
              width: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(Icons.star, color: Color(0xFF723D46)),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            badge.nombre,
            style: const TextStyle(color: Colors.white, fontSize: 12),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
