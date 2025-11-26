class UserModel {
  final String id;                  // ID del documento en Firestore
  final String alias;               // Obl
  final String email;               // Obl
  final String username;            // Obl
  final String password;            // Obl (solo para pruebas, luego usar Firebase Auth)
  
  final String? fotoPerfil;         // Opc
        String? nivel;              // Opc
  final List<int>? badges;          // Opc
  final int? racha;                 // Opc
  final int? tiempoTotal;           // Opc

  UserModel({
    required this.id,
    required this.alias,
    required this.email,
    required this.username,
    required this.password,
    this.fotoPerfil,
    this.nivel,
    this.badges,
    this.racha,
    this.tiempoTotal,
  });

  // Constructor desde Map para Firestore
  factory UserModel.fromMap(String id, Map<String, dynamic> data) {
    return UserModel(
      id: id,
      alias: data['alias'] ?? '',
      email: data['email'] ?? '',
      username: data['username'] ?? '',
      password: data['password'] ?? '',
      fotoPerfil: data['foto_perfil'],
      nivel: data['nivel'],
      badges: data['badges'] != null ? List<int>.from(data['badges']) : [],
      racha: data['racha'] ?? 0,
      tiempoTotal: data['tiempo_total'] ?? 0,
    );
  }

  // Para enviar a Firestore (solo los campos a guardar)
  Map<String, dynamic> toMap() {
    return {
      'alias': alias,
      'email': email,
      'username': username,
      'password': password,
      'foto_perfil': fotoPerfil,
      'nivel': nivel,
      'badges': badges ?? [],
      'racha': racha ?? 0,
      'tiempo_total': tiempoTotal ?? 0,
    };
  }
}
