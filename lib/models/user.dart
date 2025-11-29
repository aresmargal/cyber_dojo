import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String alias;
  final String email;
  final String username;
  final String password;
  final Map<String, Map<String, dynamic>>? progresoCursos;
  
  final String? fotoPerfil;
  String? nivel;
  final List<int>? badges;
  int? racha;
  int? tiempoTotal;
  int? tiempoHoy;
  DateTime? ultimoAcceso;

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
    this.tiempoHoy,
    this.ultimoAcceso,
    this.progresoCursos
  });

  // Constructor desde Map para Firestore
  factory UserModel.fromMap(String id, Map<String, dynamic> data) {
    // Conversión segura del campo 'progreso_cursos'
    final Map<String, dynamic>? rawProgress = data['progreso_cursos'] as Map<String, dynamic>?;

    final Map<String, Map<String, dynamic>>? progressMap = rawProgress?.map(
      (key, value) => MapEntry(key, value as Map<String, dynamic>),
    );

    return UserModel(
      id: id,
      alias: data['alias'] ?? '',
      email: data['email'] ?? '',
      username: data['username'] ?? '',
      password: data['password'] ?? '',
      fotoPerfil: data['fotoPerfil'],
      nivel: data['nivel'],
      badges: data['badges'] != null ? List<int>.from(data['badges']) : [],
      racha: data['racha'] ?? 0,
      tiempoTotal: data['tiempoTotal'] ?? 0, 
      tiempoHoy: data['tiempoHoy'] ?? 0,
      ultimoAcceso: (data['ultimoAcceso'] as Timestamp?)?.toDate(),
      progresoCursos: progressMap,  
    );
  }

  // Constructor desde DocumentSnapshot (para SplashScreen)
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel.fromMap(doc.id, data);
  }

  // Para enviar a Firestore
  Map<String, dynamic> toMap() {
    return {
      'alias': alias,
      'email': email,
      'username': username,
      'password': password,
      'fotoPerfil': fotoPerfil, 
      'nivel': nivel,
      'badges': badges ?? [],
      'racha': racha ?? 0,
      'tiempoTotal': tiempoTotal ?? 0, 
      'progreso_cursos': progresoCursos
    };
  }
}