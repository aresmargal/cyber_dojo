import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyber_dojo/models/pregunta.dart';

class BlockModel {
  final String idBloque;
  final String idLeccion;
  final String tipo; // "teoria" o "pregunta"
  final int ordenEnLeccion;

  // si tipo == "teoria"
  final String? contenidoTeoria;

  // si tipo == "pregunta"
  final PreguntaModel? pregunta;

  BlockModel({
    required this.idBloque,
    required this.idLeccion,
    required this.tipo,
    required this.ordenEnLeccion,
    this.contenidoTeoria,
    this.pregunta,
  });

  // Factory para crear un modelo desde un DocumentSnapshot (al leer de Firestore)
  factory BlockModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    PreguntaModel? pregunta;
    if (data['tipo'] == 'pregunta' && data.containsKey('pregunta')) {
      pregunta = PreguntaModel.fromMap(
        data['pregunta'] as Map<String, dynamic>,
      );
    }

    return BlockModel(
      idBloque: doc.id,
      idLeccion: data['id_leccion'] as String,
      tipo: data['tipo'] as String,
      ordenEnLeccion: data['orden_Leccion'] as int,
      contenidoTeoria: data['contenido_Teoria'] as String?,
      pregunta: pregunta,
    );
  }
}
