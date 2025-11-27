import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyber_dojo/models/badge.dart';
import 'package:cyber_dojo/models/user.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class ProfileScreen extends StatelessWidget {
  final UserModel user;
  final VoidCallback onEditProfile;
  final VoidCallback onViewAllBadges;
  final VoidCallback onLogout;

  const ProfileScreen({
    super.key,
    required this.user,
    required this.onEditProfile,
    required this.onViewAllBadges,
    required this.onLogout,
  });

  //Obtener insignias del user
  Future<List<BadgeModel>> _fetchBadges() async {
    final snapshot = await FirebaseFirestore.instance.collection('badge').get();

    final allBadges = snapshot.docs
        .map((doc) => BadgeModel.fromFirestore(doc))
        .toList();

    final userBadgeIds = user.badges?.cast<int>() ?? [];
    final unlockedBadges = allBadges
        .where((badge) => userBadgeIds.contains(badge.id))
        .toList();
    final lockedBadges = allBadges
        .where((badge) => !userBadgeIds.contains(badge.id))
        .toList();

    return [...unlockedBadges, ...lockedBadges];
  }

  //Dibujar insignia
  Widget _buildProfileBadgeItem(BadgeModel badge, bool isUnlocked) {
    final backgroundColor = isUnlocked
        ? const Color(0xB3472D30) 
        : const Color(0x69472D30);

    return Container(
      width: 100, 
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(1, 2),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Imagen de la insignia
              Container(
                height: 50, 
                width: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  image: DecorationImage(
                    image: NetworkImage(badge.urlImagen),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              // Nombre de la insignia
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(
                  badge.nombre,
                  textAlign: TextAlign.center,
                  maxLines: 1, 
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFFFFE1A8),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          if (!isUnlocked)
            const Icon(Icons.lock, size: 28, color: Colors.black54),
        ],
      ),
    );
  }

  //Manejo de tiempo en la app
  String formatSeconds(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;

    if (minutes > 0) {
      return '$minutes min $seconds seg';
    } else {
      return '$seconds seg';
    }
  }

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
            backgroundImage:
                (user.fotoPerfil != null && user.fotoPerfil!.isNotEmpty)
                ? NetworkImage(user.fotoPerfil!)
                : null, // no mostrar imagen si es null
            child: (user.fotoPerfil == null || user.fotoPerfil!.isEmpty)
                ? Text(
                    user.alias
                        .substring(0, 1)
                        .toUpperCase(), // inicial del alias
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
            style: TextStyle(fontSize: 14, color: Color(0xFF723D46)),
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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            ),
            child: const Text(
              "Editar perfil",
              style: TextStyle(color: Color(0xFFFFE1A8), fontSize: 16),
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
            child: Row( 
              crossAxisAlignment: CrossAxisAlignment.center, 
              children: [
                SizedBox( 
                  width: 60, 
                  child: Center( 
                    child: Image.network(
                      'https://raw.githubusercontent.com/aresmargal/cyber_dojo_assets/main/buttons/reloj.png', 
                      width: 50, 
                      height: 50, 
                      fit: BoxFit.contain, 
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                
                Expanded( 
                  child: Column( 
                    crossAxisAlignment: CrossAxisAlignment.start, 
                    mainAxisAlignment: MainAxisAlignment.center, 
                    children: [
                      Text(
                        "Entrenamiento de hoy: ${formatSeconds(user.tiempoHoy ?? 0)}",
                        style: TextStyle(
                          color: Color(0xFFFFE1A8),
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8), 
                      Text(
                        "Entrenamiento total: ${formatSeconds(user.tiempoTotal ?? 0)}",
                        style: TextStyle(
                          color: Color(0xFFFFE1A8),
                          fontSize: 16,
                        ),
                      ),
                    ],
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

          FutureBuilder<List<BadgeModel>>(
            future: _fetchBadges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  height: 120, // Mantener el espacio mientras carga
                  child: Center(
                    child: CircularProgressIndicator(color: Color(0xFF723D46)),
                  ),
                );
              }

              final allAchievements = snapshot.data!;
              
              // Mostrar las primeras 4
              final itemsToShow = min(allAchievements.length, 4);
              final visibleAchievements = allAchievements.sublist(0, itemsToShow);
              final userBadgesIds = user.badges?.cast<int>() ?? [];

              return SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: visibleAchievements.length,
                  itemBuilder: (context, index) {
                    final item = visibleAchievements[index];
                    final bool unlocked = userBadgesIds.contains(item.id);

                    return _buildProfileBadgeItem(item, unlocked);
                  },
                ),
              );
            },
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
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
            ),
            child: const Text(
              "Cerrar sesión",
              style: TextStyle(color: Color(0xFFFFE1A8), fontSize: 16),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
