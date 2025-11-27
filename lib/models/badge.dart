import 'package:cloud_firestore/cloud_firestore.dart';

class BadgeModel {
  final int id;
  final String nombre;
  final String urlImagen;

  BadgeModel({
    required this.id,
    required this.nombre,
    required this.urlImagen,
  });

  // Constructor para crear el modelo desde Firestore
  factory BadgeModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return BadgeModel(
      id: data['ID_badge'] ?? 0, 
      nombre: data['nombre'] ?? 'Desconocida',
      urlImagen: data['imagen'] ?? '',
    );
  }
}