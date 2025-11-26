import 'package:cyber_dojo/models/user.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final UserModel user; 
  final VoidCallback onEditProfile; 
  final VoidCallback onViewAllBadges; 
  final VoidCallback onLogout; 

  const ProfileScreen({super.key, required this.user, required this.onEditProfile, required this.onViewAllBadges, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // --- Foto de perfil ---
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.white,
            backgroundImage: (user.fotoPerfil != null && user.fotoPerfil!.isNotEmpty)
                ? NetworkImage(user.fotoPerfil!)
                : null, // no mostrar imagen si es null
            child: (user.fotoPerfil == null || user.fotoPerfil!.isEmpty)
                ? Text(
                    user.alias.substring(0, 1).toUpperCase(), // inicial del alias
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF723D46),
                    ),
                  )
                : null,
          ),
          const SizedBox(height: 16),

          // --- Nombre y correo ---
          Text(
            user.alias,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF472D30),
            ),
          ),
          const SizedBox(height: 6),

          Text(
            user.email,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF723D46),
            ),
          ),
          const SizedBox(height: 6),

          // --- Cinturón ---
          Text(
            "Cinturón: ${user.nivel}",
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
            child: Column(
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
                  "Entrenamiento total: ${user.tiempoTotal}",
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Cinturones e Insignias",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF472D30),
                  ),
                ),
                GestureDetector(
                  onTap: onViewAllBadges, 
                  child: const Text(
                    "Ver todos",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF723D46),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
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
                        "C",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFFFE1A8),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 40),

          // --- Botón Cerrar Sesión ---
          ElevatedButton(
            onPressed: onLogout,
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
