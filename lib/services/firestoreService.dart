// services/firestore_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyber_dojo/models/block.dart';
import 'package:cyber_dojo/models/course.dart';
import 'package:cyber_dojo/models/lesson.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Obtener todos los cursos
  Stream<List<CourseModel>> getCourses() {
    return _db.collection('cursos')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => CourseModel.fromFirestore(doc)).toList());
  }

  // Obtener lecciones para un curso 
  Stream<List<LessonModel>> getLessonsForCourse(String courseId) {
    return _db
        .collection('lecciones')
        .where('id_curso', isEqualTo: courseId)
        .orderBy('orden_en_curso', descending: false)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => LessonModel.fromFirestore(doc)).toList());
  }

  // Obtener bloques para una lección
  Future<List<BlockModel>> getBlocksForLesson(String lessonId) async {
    final snapshot = await _db
        .collection('bloques')
        .where('id_leccion', isEqualTo: lessonId)
        .orderBy('orden_en_leccion', descending: false)
        .get();
    
    return snapshot.docs
        .map((doc) => BlockModel.fromFirestore(doc))
        .toList();
  }
}