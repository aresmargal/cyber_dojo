import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final VoidCallback onEditProfile; 

  const ProfileScreen({super.key, required this.onEditProfile});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // --- Foto de perfil ---
          const CircleAvatar(
            radius: 60,
            backgroundImage: AssetImage("assets/images/pfp/pfp4.png"),
            backgroundColor: Colors.white,
          ),
          const SizedBox(height: 16),

          // --- Nombre y correo ---
          const Text(
            "Lydia",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF472D30),
            ),
          ),
          const SizedBox(height: 6),

          const Text(
            "lydia@ejemplo.com",
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF723D46),
            ),
          ),
          const SizedBox(height: 6),

          // --- Cinturón ---
          const Text(
            "Cinturón: Blanco",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xFF472D30),
            ),
          ),
          const SizedBox(height: 6),

          // --- Botón Editar Perfil ---
          ElevatedButton(
            onPressed: onEditProfile,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF723D46),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            ),
            child: const Text(
              "Editar perfil",
              style: TextStyle(
                color: Color(0xFFFFE1A8),
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 5),

          // --- Tu actividad ---
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Tu actividad",
              style: TextStyle(
                color: const Color(0xFF723D46),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 5),

          // --- Bloque de actividad ---
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xB3472D30),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(16),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Entrenamiento de hoy: 23 minutos",
                  style: TextStyle(
                    color: Color(0xFFFFE1A8),
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Entrenamiento total: 1 hora y 9 minutos", //TODO: Unir BBDD
                  style: TextStyle(
                    color: Color(0xFFFFE1A8),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),

          // --- Cinturones e Insignias ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Cinturones e Insignias",
                style: TextStyle(
                  color: Color(0xFF723D46),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Ver todos",
                style: TextStyle(
                  color: Color(0xFF472D30),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),

          SizedBox(
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: List.generate(3, (index) {
                return Container(
                  width: 100,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xB3472D30),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Cinturón blanco",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFFFE1A8),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 40),

          // --- Botón Cerrar Sesión ---
          ElevatedButton(
            onPressed: () {
              // TODO: Implementar cierre de sesión
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF472D30),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
            ),
            child: const Text(
              "Cerrar sesión",
              style: TextStyle(
                color: Color(0xFFFFE1A8),
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
