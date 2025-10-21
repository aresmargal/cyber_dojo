import 'package:cyber_dojo/screens/dojoScreens/dojo_main_screen.dart';
import 'package:cyber_dojo/screens/homeCourses/home_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Lista de pantallas
  final List<Widget> _screens = const [
    HomeScreen(),
    DojoScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE1A8),

       // Cabecera personalizada
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          padding: const EdgeInsets.only(top: 50, left: 20, right: 16, bottom: 16),
          decoration: const BoxDecoration(
            color: Color(0xFF723D46),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Foto de perfil
              const CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage("assets/images/pfp/pfp4.png"),
                backgroundColor: Colors.white,
              ),
              const SizedBox(width: 12),

              // Texto de bienvenida y racha
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Bienvenido a tu Dojo, @LydiaNinja",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Racha de entrenamiento: 5 días 🔥",
                      style: TextStyle(
                        color: Color(0xFFFFE1A8),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      body: _screens[_selectedIndex],

      // Menú inferior
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF723D46),
        selectedItemColor: const Color(0xFFFFE1A8),
        unselectedItemColor: Colors.white70,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Inicio",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Dojo",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Cursos",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Pefil",
          ),
        ],
      ),
    );
  }
}