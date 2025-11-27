import 'package:cyber_dojo/models/user.dart';
import 'package:cyber_dojo/screens/auth/login_screen.dart';
import 'package:cyber_dojo/screens/dojoScreens/dojo_course_completed_screen.dart';
import 'package:cyber_dojo/screens/dojoScreens/dojo_lesson_text_screen.dart';
import 'package:cyber_dojo/screens/profile/beltsAndBadges_screen.dart';
import 'package:cyber_dojo/screens/profile/edit_profile_screen.dart';
import 'package:cyber_dojo/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:cyber_dojo/screens/dojoScreens/dojo_main_screen.dart';
import 'package:cyber_dojo/screens/dojoScreens/dojo_course_screen.dart';
import 'package:cyber_dojo/screens/dojoScreens/dojo_lesson_question_screen.dart';
import 'package:cyber_dojo/screens/homeCourses/home_screen.dart';
import 'package:cyber_dojo/screens/homeCourses/courses_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  final UserModel user;
  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // 0 = home, 1 = dojo, etc.
  String? _selectedCourse; // Guarda el curso actual abierto
  Map<String, String>? _selectedLesson; // Guarda la lección actual
  bool _editingProfile = false; //Datos de perfil en edición o no
  bool _viewingBadges = false; //Bool para ver o no las medallas
  late UserModel _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.user; // Inicializar con el usuario recibido
  }

  @override
  Widget build(BuildContext context) {
    // Elegir qué mostrar en el body
    Widget body;
    if (_selectedCourse != null && _selectedLesson?["type"] == "question") {
      //Mostrar pantalla de pregunta
      body = DojoLessonQuestionScreen(
        courseTitle: _selectedCourse!,
        lessonTitle: _selectedLesson!["title"]!,
        questionText: "¿Cuál de las siguientes contraseñas es más segura?",
        options: ["12345678", "Lyd!@2024", "contraseña"],
        correctAnswerIndex: 1,
        onBack: () {
          // Volver al texto de la lección
          setState(() {
            _selectedLesson = {
              "title": _selectedLesson!["title"]!,
              "text": _selectedLesson!["text"]!,
            };
          });
        },
        onNext: () {
          // Volver al listado de lecciones
          //setState(() => _selectedLesson = null);
          //Prueba completed screen
          setState(() {
            _selectedLesson = {
              "type": "completed",
              "title": _selectedLesson!["title"]!,
              "text": _selectedLesson!["text"]!,
            };
          });
        },
      );
    } else if (_selectedCourse != null &&
        _selectedLesson?["type"] == "completed") {
      body = DojoCourseCompletedScreen(
        courseTitle: _selectedCourse!,
        courseDescription:
            "Aprende las bases de la ciberseguridad mientras entrenas como un ninja digital.",
        courseImage: "",
        medals: ["", "", ""],
        onBackToCourses: () {
          setState(() {
            _selectedLesson = null;
            _selectedCourse = null;
          });
        },
      );
    } else if (_selectedLesson != null) {
      //Mostrar pantalla de texto
      body = DojoLessonTextScreen(
        courseTitle: _selectedCourse!,
        lessonTitle: _selectedLesson!["title"]!,
        lessonText: _selectedLesson!["text"]!,
        onBack: () => setState(() => _selectedLesson = null),
        onNext: () {
          // Cambiar al modo "pregunta"
          setState(() {
            _selectedLesson = {
              "type": "question",
              "title": _selectedLesson!["title"]!,
              "text": _selectedLesson!["text"]!,
            };
          });
        },
      );
    } else if (_selectedCourse != null) {
      body = DojoCourseScreen(
        courseTitle: _selectedCourse!,
        onBack: () => setState(() => _selectedCourse = null),
        onLessonSelected: (lesson) {
          setState(
            () => _selectedLesson = {
              "type": "text",
              "title": lesson["title"]!,
              "text": lesson["text"]!,
            },
          );
        },
      );
    } else {
      Widget screen = const Center(
        child: Text("Pantalla no encontrada"),
      ); //Valor por defecto por errores

      if (_selectedIndex == 0) {
        screen = HomeScreen(
          onCourseSelected: (courseTitle) {
            setState(() => _selectedCourse = courseTitle);
          },
        );
      } else if (_selectedIndex == 1) {
        screen = DojoScreen(
          onCourseSelected: (courseTitle) {
            setState(() => _selectedCourse = courseTitle);
          },
          onExploreCourses: () {
            setState(() => _selectedIndex = 2);
          },
        );
      } else if (_selectedIndex == 2) {
        screen = CoursesScreen(
          onCourseSelected: (courseTitle) {
            setState(() => _selectedCourse = courseTitle);
          },
        );
      } else if (_selectedIndex == 3) {
        if (_viewingBadges) {
          screen = BeltsAndBadgesScreen(
            onBack: () {
              setState(() => _viewingBadges = false);
            },
          );
        } else {
          screen = _editingProfile
              ? EditProfileScreen(
                  user: _currentUser,
                  onBack: (UserModel? updatedUser) {
                    setState(() {
                      if (updatedUser != null) {
                        _currentUser = updatedUser;
                      }
                      _editingProfile = false;
                    });
                  },
                )
              : ProfileScreen(
                  user: _currentUser,
                  onEditProfile: () {
                    setState(() => _editingProfile = true);
                  },
                  onViewAllBadges: () {
                    setState(() => _viewingBadges = true);
                  },
                  onLogout: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.remove("user_id"); // Borrar sesión guardada

                    if (mounted) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (route) => false, // Eliminar toda la pila de navegación
                      );
                    }
                  },
                );
        }
      }

      body = screen;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFE1A8),

      // Cabecera
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          padding: const EdgeInsets.only(
            top: 50,
            left: 20,
            right: 16,
            bottom: 16,
          ),
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
          child: _selectedIndex == 3
              ? const Center(
                  child: Text(
                    "Tu perfil",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.white,
                      backgroundImage:
                          (_currentUser.fotoPerfil != null &&
                              _currentUser.fotoPerfil!.isNotEmpty)
                          ? NetworkImage(_currentUser.fotoPerfil!)
                          : null,
                      child:
                          (_currentUser.fotoPerfil == null ||
                              _currentUser.fotoPerfil!.isEmpty)
                          ? Text(
                              _currentUser.alias.substring(0, 1).toUpperCase(),
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF723D46),
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Bienvenido a tu Dojo, @${_currentUser.username}",
                            style: const TextStyle(
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

      body: body,

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF723D46),
        selectedItemColor: const Color(0xffC9CBA3),
        unselectedItemColor: const Color(0xffC9CBA3),
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedCourse = null;
            _selectedLesson = null;
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              _selectedIndex == 0
                  ? "assets/images/icons/homeIconFull.png"
                  : "assets/images/icons/homeIcon.png",
              height: 26,
            ),
            label: "Inicio",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              _selectedIndex == 1
                  ? "assets/images/icons/dojoIconFull.png"
                  : "assets/images/icons/dojoIcon.png",
              height: 32,
            ),
            label: "Dojo",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              _selectedIndex == 2
                  ? "assets/images/icons/coursesIconFull.png"
                  : "assets/images/icons/coursesIcon.png",
              height: 28,
            ),
            label: "Misiones",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              _selectedIndex == 3
                  ? "assets/images/icons/profileIconFull.png"
                  : "assets/images/icons/profileIcon.png",
              height: 26,
            ),
            label: "Perfil",
          ),
        ],
      ),
    );
  }
}
