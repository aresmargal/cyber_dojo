import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String alias;
  final String email;
  final String username;
  final String password;
  
  final String? fotoPerfil;
  String? nivel;
  final List<int>? badges;
  final int? racha;
  final int? tiempoTotal;

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
      fotoPerfil: data['fotoPerfil'], // ← CAMBIO: sin guion bajo
      nivel: data['nivel'],
      badges: data['badges'] != null ? List<int>.from(data['badges']) : [],
      racha: data['racha'] ?? 0,
      tiempoTotal: data['tiempoTotal'] ?? 0, // ← CAMBIO: camelCase
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
      'fotoPerfil': fotoPerfil, // ← CAMBIO: sin guion bajo
      'nivel': nivel,
      'badges': badges ?? [],
      'racha': racha ?? 0,
      'tiempoTotal': tiempoTotal ?? 0, // ← CAMBIO: camelCase
    };
  }
}