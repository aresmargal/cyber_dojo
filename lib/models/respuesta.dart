class RespuestaModel {
  final String texto;
  final bool esCorrecto;

  RespuestaModel({required this.texto, required this.esCorrecto});

  // Constructor para mapear datos desde el Map de Firestore (anidado)
  factory RespuestaModel.fromMap(Map<String, dynamic> data) {
    return RespuestaModel(
      texto: data['texto'] as String,
      esCorrecto: data['es_Correcta'] as bool,
    );
  }

  // Método para convertir a Map
  Map<String, dynamic> toMap() {
    return {'texto': texto, 'es_Correcta': esCorrecto};
  }
}
