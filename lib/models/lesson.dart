import 'package:cloud_firestore/cloud_firestore.dart';

class LessonModel {
  final String idLeccion;
  final String idCurso;
  final String titulo;
  final int ordenEnCurso;
  final int numBloques;

  LessonModel({
    required this.idLeccion,
    required this.idCurso,
    required this.titulo,
    required this.ordenEnCurso,
    required this.numBloques,
  });

  factory LessonModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return LessonModel(
      idLeccion: doc.id,
      idCurso: data['id_curso'] as String,
      titulo: data['titulo'] as String,
      ordenEnCurso: data['orden_Curso'] as int,
      numBloques: data['num_bloques'] as int,
    );
  }
}