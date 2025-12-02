import 'package:cloud_firestore/cloud_firestore.dart';

class TipModel {
  final String id;
  final String texto;
  
  TipModel({required this.id, required this.texto});

  factory TipModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return TipModel(
      id: doc.id,
      texto: data['texto'] as String? ?? 'No se pudo cargar el consejo.',
    );
  }
}