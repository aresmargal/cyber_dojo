import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyber_dojo/models/badge.dart';
import 'package:cyber_dojo/models/user.dart';
import 'package:flutter/material.dart';

class BeltsAndBadgesScreen extends StatelessWidget {
  final VoidCallback onBack;
  final List<int> userBadges;
  final UserModel user;

  const BeltsAndBadgesScreen({
    super.key,
    required this.onBack,
    required this.userBadges,
    required this.user,
  });

  Future<List<BadgeModel>> _fetchBadges() async {
    final snapshot = await FirebaseFirestore.instance.collection('badge').get();

    //Obtener todas las insignias y filtrar por las que el user tiene
    final allBadges = snapshot.docs
        .map((doc) => BadgeModel.fromFirestore(doc))
        .toList();
    final unlockedBadges = allBadges
        .where((badge) => userBadges.contains(badge.id))
        .toList();
    return [...unlockedBadges, ...allBadges];
  }

  //Dibuja la insignia
  Widget _buildBadgeItem(BadgeModel badge, bool isUnlocked) {
    final backgroundColor = isUnlocked
        ? const Color(0xB3472D30)
        : const Color(0x69472D30);

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.maxWidth;

        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Imagen
                    Container(
                      width: size * 0.45,
                      height: size * 0.45,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white70,
                        image: DecorationImage(
                          image: NetworkImage(badge.urlImagen),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Texto del nombre
                    Flexible(
                      child: Text(
                        badge.nombre,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: size * 0.11, 
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (!isUnlocked)
                Icon(Icons.lock, size: size * 0.3, color: Colors.black54),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE1A8),
      body: Stack(
        children: [
          FutureBuilder<List<BadgeModel>>(
            future: _fetchBadges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF723D46)),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text('Error al cargar insignias: ${snapshot.error}'),
                );
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('No se encontraron insignias.'),
                );
              }

              final List<BadgeModel> achievements = snapshot.data!;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white,
                      backgroundImage:
                          (user.fotoPerfil != null &&
                              user.fotoPerfil!.isNotEmpty)
                          ? NetworkImage(user.fotoPerfil!)
                          : null, // no mostrar imagen si es null
                      child:
                          (user.fotoPerfil == null || user.fotoPerfil!.isEmpty)
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
                    const SizedBox(height: 12),
                    Text(
                      user.alias,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF472D30),
                      ),
                    ),
                    Text(
                      user.email,
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    Text(
                      "Cinturón: ${user.nivel}",
                      style: TextStyle(fontSize: 18, color: Color(0xFF723D46)),
                    ),
                    const SizedBox(height: 24),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Cinturones e Insignias",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF472D30),
                        ),
                      ),
                    ),
                    //Grid para las insignias
                    const SizedBox(height: 16),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: achievements.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 1.0,
                          ),
                      itemBuilder: (context, index) {
                        final item = achievements[index];
                        final bool unlocked = userBadges.contains(item.id);

                        return _buildBadgeItem(item, unlocked);
                      },
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              );
            },
          ),

          // Botón de volver flotante
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: onBack,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
