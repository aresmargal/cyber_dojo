import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyber_dojo/models/badge.dart';
import 'package:flutter/material.dart';

class DojoCourseCompletedScreen extends StatefulWidget {
  final String courseTitle;
  final String courseDescription;
  final String courseImage;
  final List<String> medals;
  final VoidCallback onBackToCourses;
  final int numLecciones;

  const DojoCourseCompletedScreen({
    super.key,
    required this.courseTitle,
    required this.courseDescription,
    required this.courseImage,
    required this.medals,
    required this.onBackToCourses,
    required this.numLecciones,
  });

  @override
  State<DojoCourseCompletedScreen> createState() =>
      _DojoCourseCompletedScreenState();
}

class _DojoCourseCompletedScreenState extends State<DojoCourseCompletedScreen> {
  List<BadgeModel> _badges = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadBadges();
  }

  Future<void> _loadBadges() async {
    try {
      if (widget.medals.isEmpty) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Convertir los IDs de String a int
      final badgeIntIds = widget.medals
          .map((id) => int.tryParse(id))
          .where((id) => id != null)
          .cast<int>()
          .toList();

      if (badgeIntIds.isEmpty) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Cargar todas las badges de la colección
      final badgesSnapshot = await FirebaseFirestore.instance
          .collection('badge')
          .get();

      // Filtrar solo las badges que coincidan con los IDs
      final badges = badgesSnapshot.docs
          .map((doc) => BadgeModel.fromFirestore(doc))
          .where((badge) => badgeIntIds.contains(badge.id))
          .toList();

      setState(() {
        _badges = badges;
        _isLoading = false;
      });
    } catch (e) {
      print('Error al cargar badges: $e');
      setState(() {
        _error = 'Error al cargar las medallas';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Texto superior
          Center(
            child: Text(
              "Felicidades, has completado...",
              style: const TextStyle(
                color: Color(0xFF472D30),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 8),

          Center(
            child: Text(
              widget.courseTitle,
              style: const TextStyle(
                color: Color(0xFF723D46),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Ficha del curso
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
                    // Imagen cuadrada
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: widget.courseImage.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                widget.courseImage,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(
                                    child: Icon(
                                      Icons.school,
                                      size: 50,
                                      color: Color(0xFF723D46),
                                    ),
                                  );
                                },
                              ),
                            )
                          : const Center(
                              child: Icon(
                                Icons.school,
                                size: 50,
                                color: Color(0xFF723D46),
                              ),
                            ),
                    ),
                    const SizedBox(width: 16),
                    // Info a la derecha
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Lecciones: ${widget.numLecciones}",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        Text(
                          "Cinturón: ",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  widget.courseDescription,
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Medallas ganadas
          const Text(
            "Medallas que has ganado",
            style: TextStyle(
              color: Color(0xFF472D30),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          // Contenido de medallas
          _isLoading
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(color: Color(0xFF723D46)),
                  ),
                )
              : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      _error!,
                      style: const TextStyle(color: Color(0xFF472D30)),
                    ),
                  ),
                )
              : _badges.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      'No hay medallas disponibles para este curso',
                      style: TextStyle(color: Color(0xFF472D30)),
                    ),
                  ),
                )
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: _badges.length,
                  itemBuilder: (context, index) {
                    final badge = _badges[index];

                    return Container(
                      decoration: BoxDecoration(
                        color: const Color(0xB3472D30),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white70,
                            ),
                            child: ClipOval(
                              child: Image.network(
                                badge.urlImagen,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            badge.nombre,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                ),

          const SizedBox(height: 32),

          // Botón para volver
          Center(
            child: ElevatedButton(
              onPressed: widget.onBackToCourses,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF723D46),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Volver al Dojo",
                style: TextStyle(
                  color: Color(0xFFFFE1A8),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
