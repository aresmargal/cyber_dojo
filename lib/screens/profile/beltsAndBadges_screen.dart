import 'package:flutter/material.dart';

class BeltsAndBadgesScreen extends StatelessWidget {
  final VoidCallback onBack;

  const BeltsAndBadgesScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> achievements = [
      {
        "name": "Cinturón Blanco",
        "image": "assets/images/badges/cinturonBlanco.png",
        "unlocked": true,
      },
      {
        "name": "Cinturón Amarillo",
        "image": "assets/images/badges/cinturonAm.png",
        "unlocked": false,
      },
      {
        "name": "Cinturón Verde",
        "image": "assets/images/badges/cinturonVerde.png",
        "unlocked": false,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFFE1A8),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 60),
                CircleAvatar(
                  radius: 55, 
                  backgroundImage: const AssetImage(
                    "assets/images/pfp/pfp4.png",
                  ),
                  backgroundColor: Colors.white,
                ),
                const SizedBox(height: 12),
                const Text(
                  "Lydia",
                  style: TextStyle(
                    fontSize: 22, 
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF472D30),
                  ),
                ),
                const Text(
                  "lydia@ejemplo.com",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const Text(
                  "Cinturón: Blanco",
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
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    final item = achievements[index];
                    final bool unlocked = item["unlocked"];

                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: unlocked
                                ? const Color(0xB3472D30)
                                : const Color(0x69472D30),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: Offset(1, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.white,
                                backgroundImage: AssetImage(item["image"]),
                              ),
                              const SizedBox(height: 6),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                child: Text(
                                  item["name"],
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (!unlocked)
                          const Icon(
                            Icons.lock,
                            size: 32,
                            color: Colors.black54,
                          ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 50),
              ],
            ),
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
