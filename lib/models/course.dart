import 'package:cloud_firestore/cloud_firestore.dart';

class CourseModel {
  final String idCurso;
  final String titulo;
  final String nivel;
  final int numLecciones;

  CourseModel({
    required this.idCurso,
    required this.titulo,
    required this.nivel,
    required this.numLecciones,
  });

  factory CourseModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CourseModel(
      idCurso: doc.id, 
      titulo: data['titulo'] as String,
      nivel: data['nivel'] as String,
      numLecciones: data['num_lecciones'] as int,
    );
  }
}