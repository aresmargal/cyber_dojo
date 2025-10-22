import 'package:flutter/material.dart';

class DojoCourseScreen extends StatelessWidget {
  final String courseTitle;
  final VoidCallback onBack;

  const DojoCourseScreen({
    super.key,
    required this.courseTitle,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    // Lista temporal de lecciones (TODO: conectar con BBDD)
    final List<Map<String, String>> lessons = [
      {"title": "Introducción a la Ciberseguridad"},
      {"title": "Tipos de Amenazas Digitales"},
      {"title": "Contraseñas Seguras"},
      {"title": "Redes Wi-Fi y Seguridad"},
      {"title": "Phishing y cómo evitarlo"},
      {"title": "Resumen del módulo"},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFFE1A8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Fila superior con botón volver y título ---
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Color(0xFF472D30)),
                    onPressed: onBack,
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        courseTitle,
                        style: const TextStyle(
                          color: Color(0xFF472D30),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),

              const SizedBox(height: 12),

              // --- Bloque de información del curso ---
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xB3472D30),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Row(
                      children: [
                        // Imagen del curso (temp)
                        SizedBox(
                          height: 70,
                          width: 70,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Lecciones: 15",
                                style: TextStyle(color: Colors.white70)),
                            Text("Cinturón: Blanco",
                                style: TextStyle(color: Colors.white70)),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Este curso te enseñará los fundamentos para protegerte en línea...",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // --- Título de sección ---
              const Text(
                "Lecciones",
                style: TextStyle(
                  color: Color(0xFF472D30),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              // --- Lista de lecciones ---
              Expanded(
                child: ListView.builder(
                  itemCount: lessons.length,
                  itemBuilder: (context, index) {
                    final lesson = lessons[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xB3472D30),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        title: Text(
                          "Lección ${index + 1}: ${lesson["title"]}",
                          style: const TextStyle(
                            color: Color(0xFFFFE1A8),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: Color(0xFFFFE1A8),
                          size: 18,
                        ),
                        onTap: () {
                          // TODO: Navegar a la pantalla de lección específica
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
