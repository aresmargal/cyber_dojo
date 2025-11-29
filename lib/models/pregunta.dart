import 'package:cyber_dojo/models/respuesta.dart';

class PreguntaModel {
  final String enunciado;
  final List<RespuestaModel> respuestas;

  PreguntaModel({
    required this.enunciado,
    required this.respuestas,
  });

  // Constructor para mapear datos desde el Map de Firestore (anidado)
  factory PreguntaModel.fromMap(Map<String, dynamic> data) {
    // Lista dinámica de respuestas (Map<String, dynamic>) a List<RespuestaModel> usando su factory
    final List<dynamic> respuestasData = data['respuestas'] ?? [];
    final List<RespuestaModel> respuestasList = respuestasData
        .map((respuestaMap) => RespuestaModel.fromMap(respuestaMap as Map<String, dynamic>))
        .toList();

    return PreguntaModel(
      enunciado: data['enunciado'] as String,
      respuestas: respuestasList,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'enunciado': enunciado,
      'respuestas': respuestas.map((r) => r.toMap()).toList(),
    };
  }
}