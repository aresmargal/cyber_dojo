import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyber_dojo/models/block.dart';
import 'package:cyber_dojo/screens/dojoScreens/dojo_lesson_text_screen.dart';
import 'package:cyber_dojo/screens/dojoScreens/dojo_lesson_question_screen.dart';
import 'package:flutter/material.dart';

class DojoLessonContainerScreen extends StatefulWidget {
  final String idLeccion;
  final String courseTitle;
  final String lessonTitle;
  final VoidCallback onLessonCompleted; // Callback cuando la lección termina
  final VoidCallback onBackToLessons;
  final VoidCallback onCourseCompleted; // Callback cuando el curso termina
  final String courseId;
  final int numLeccionesTotal;

  const DojoLessonContainerScreen({
    super.key,
    required this.idLeccion,
    required this.courseTitle,
    required this.lessonTitle,
    required this.onLessonCompleted,
    required this.onBackToLessons,
    required this.onCourseCompleted,
    required this.courseId,
    required this.numLeccionesTotal,
  });

  @override
  State<DojoLessonContainerScreen> createState() =>
      _DojoLessonContainerScreenState();
}

class _DojoLessonContainerScreenState extends State<DojoLessonContainerScreen> {
  late Future<List<BlockModel>> _blocksFuture;
  int _currentBlockIndex = 0;
  List<BlockModel> _blocks = [];

  @override
  void initState() {
    super.initState();
    _blocksFuture = _fetchLessonBlocks();
  }

  // Carga inicial de TODOS los bloques
  Future<List<BlockModel>> _fetchLessonBlocks() async {
    final blocksSnapshot = await FirebaseFirestore.instance
        .collection('bloque')
        .where('id_leccion', isEqualTo: widget.idLeccion)
        .orderBy('orden_Leccion')
        .get();

    _blocks = blocksSnapshot.docs
        .map((doc) => BlockModel.fromFirestore(doc))
        .toList();

    return _blocks;
  }

  // Función para comprobar si la lección actual es la última del curso
  bool _checkIfLastLesson() {
    // Obtener ID de la lección actual
    final String id = widget.idLeccion;
    final parts = id.split('_');

    if (parts.length < 3) return false; // ID mal formado

    // Obtener el último segmento
    final String lessonNumberString = parts.last;

    final int? currentLessonNumber = int.tryParse(lessonNumberString);
    if (currentLessonNumber == null) return false; // Error de formato

    return currentLessonNumber == widget.numLeccionesTotal;
  }

  // Función de paso AUTOMÁTICO al siguiente bloque
  void _nextBlock() {
  if (_currentBlockIndex < _blocks.length - 1) {
    // Si aún quedan bloques, se avanza
    setState(() {
      _currentBlockIndex++;
    });
    
  } else {
    // Si el bloque es el último 
    
    if (_checkIfLastLesson()) {
      widget.onCourseCompleted(); 
    } else {
      widget.onLessonCompleted(); 
    }
  }
}

  // Función para construir el widget del bloque actual
  Widget _buildCurrentBlockWidget() {
    if (_blocks.isEmpty) {
      return const Center(child: Text("Lección sin bloques."));
    }

    final currentBlock = _blocks[_currentBlockIndex];

    if (currentBlock.tipo == 'teoria') {
      // Si es un bloque de TEORÍA
      return DojoLessonTextScreen(
        courseTitle: widget.courseTitle,
        lessonTitle: widget.lessonTitle,
        lessonText: currentBlock.contenidoTeoria ?? "Contenido no disponible.",
        onBack: widget.onBackToLessons, // Volver a la lista de lecciones
        onNext: _nextBlock,
      );
    } else if (currentBlock.tipo == 'pregunta') {
      final pregunta = currentBlock.pregunta!;

      // Mapear la lista de objetos RespuestaModel a una lista de Strings
      final List<String> opcionesTexto = pregunta.respuestas
          .map((r) => r.texto)
          .toList();

      // Retorna el primer índice donde 'esCorrecto' es true.
      final int indiceRespuestaCorrecta = pregunta.respuestas.indexWhere(
        (r) => r.esCorrecto,
      );

      if (indiceRespuestaCorrecta == -1) {
        return const Center(
          child: Text("Error: Pregunta sin respuesta correcta definida."),
        );
      }

      // Pasar los datos al widget
      return DojoLessonQuestionScreen(
        courseTitle: widget.courseTitle,
        lessonTitle: widget.lessonTitle,

        questionText: pregunta.enunciado,
        options: opcionesTexto,
        correctAnswerIndex: indiceRespuestaCorrecta,

        onBack: widget
            .onBackToLessons, // Volver a la lista de lecciones si pulsa atrás
        onNext:
            _nextBlock, // Llama a la función que avanza el índice del contenedor
      );
    } else {
      return Center(
        child: Text("Tipo de bloque desconocido: ${currentBlock.tipo}"),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BlockModel>>(
      future: _blocksFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF723D46)),
          );
        }
        if (snapshot.hasError ||
            snapshot.data == null ||
            snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              "Error al cargar lección: ${snapshot.error ?? 'No hay bloques'}",
            ),
          );
        }

        return _buildCurrentBlockWidget();
      },
    );
  }
}
