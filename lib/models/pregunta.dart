import 'package:cyber_dojo/models/respuesta.dart';

class PreguntaModel {
  final String enunciado;
  final List<RespuestaModel> respuestas;

  PreguntaModel({required this.enunciado, required this.respuestas});

  // Constructor para mapear datos desde el Map de Firestore (anidado)
  factory PreguntaModel.fromMap(Map<String, dynamic> data) {
    // Lista dinámica de respuestas (Map<String, dynamic>) a List<RespuestaModel> usando su factory
    final Map<String, dynamic> respuestasMap =
        data['respuestas'] as Map<String, dynamic>? ?? {};

    final List<RespuestaModel> respuestasList = respuestasMap.values
        .map(
          (respuestaMapValue) =>
              RespuestaModel.fromMap(respuestaMapValue as Map<String, dynamic>),
        )
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
