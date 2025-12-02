import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyber_dojo/models/user.dart';
import 'package:cyber_dojo/screens/auth/login_screen.dart';
import 'package:cyber_dojo/screens/dojoScreens/dojo_course_completed_screen.dart';
import 'package:cyber_dojo/screens/dojoScreens/dojo_lesson_container_screen.dart';
import 'package:cyber_dojo/screens/profile/beltsAndBadges_screen.dart';
import 'package:cyber_dojo/screens/profile/edit_profile_screen.dart';
import 'package:cyber_dojo/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:cyber_dojo/screens/dojoScreens/dojo_main_screen.dart';
import 'package:cyber_dojo/screens/dojoScreens/dojo_course_screen.dart';
import 'package:cyber_dojo/screens/homeCourses/home_screen.dart';
import 'package:cyber_dojo/screens/homeCourses/courses_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  final UserModel user;
  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  int _selectedIndex = 0; // 0 = home, 1 = dojo, etc.
  int? _totalLessonsInCourse; // Total de lecciones de curso

  String? _selectedCourseId; // Guarda el id del curso actual en String
  String? _selectedCourseTitle; // Guarda el Título del curso.
  String? _selectedLessonId;
  String? _selectedLessonTitle;
  String? _selectedCourseDescription;

  List<String> _selectedCourseMedals = [];
  List<int> _selectedCourseBadges = [];

  bool _courseCompleted =
      false; // Bandera para controlar la finalización del curso
  bool _editingProfile = false; //Datos de perfil en edición o no
  bool _viewingBadges = false; //Bool para ver o no las medallas

  late UserModel _currentUser;
  DateTime? _sessionStartTime; //Variable de tiempo en la app según sesión

  @override
  void initState() {
    super.initState();
    _currentUser = widget.user; // Inicializar con el usuario recibido

    WidgetsBinding.instance.addObserver(this);
    _sessionStartTime = DateTime.now();
  }

  //Manejo de tiempo en la app
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _saveSessionTime();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // El usuario regresa a la aplicación
      print('AppLifecycleState: resumed. Iniciando contador.');
      _sessionStartTime = DateTime.now();
    } else if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      // El usuario sale de la aplicación
      print('AppLifecycleState: paused/inactive. Guardando tiempo.');
      _saveSessionTime();
    }
  }

  void _finishCourse() {
    setState(() {
      _selectedLessonId = null;
      _selectedLessonTitle = null;
      _courseCompleted = true; // Activar la pantalla de finalización
    });
    _refreshUserData();
  }

  void _saveSessionTime() async {
    if (_sessionStartTime == null) return;

    final endTime = DateTime.now();
    final duration = endTime.difference(_sessionStartTime!);
    final elapsedSeconds = duration.inSeconds;

    if (elapsedSeconds <= 0)
      return; // Evita guardar duraciones negativas o cero

    final userId = _currentUser.id;

    try {
      final userRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId);
      final doc = await userRef.get();

      // Obtener los valores actuales de BBDD
      final currentTotalTime = (doc.data()?['tiempoTotal'] as int?) ?? 0;
      final lastDailyAccess = (doc.data()?['ultimoAcceso'] as Timestamp?)
          ?.toDate();
      final currentDailyTime = (doc.data()?['tiempoHoy'] as int?) ?? 0;

      // Tiempo total
      final newTotalTime = currentTotalTime + elapsedSeconds;
      // Tiempo de hoy
      int newDailyTime = currentDailyTime;
      // Comprueba si el último acceso fue un día diferente a hoy
      final isNewDay =
          lastDailyAccess == null ||
          lastDailyAccess.year != endTime.year ||
          lastDailyAccess.month != endTime.month ||
          lastDailyAccess.day != endTime.day;

      if (isNewDay) {
        // Si es un día nuevo, el tiempo de hoy se reinicia
        newDailyTime = elapsedSeconds;
      } else {
        newDailyTime += elapsedSeconds;
      }

      await userRef.update({
        'tiempoTotal': newTotalTime,
        'tiempoHoy': newDailyTime,
        'ultimoAcceso': FieldValue.serverTimestamp(),
      });

      // Reinicia el contador de inicio para la próxima sesión
      _sessionStartTime = null;

      // Actualiza la variable de estado local
      if (mounted) {
        setState(() {
          _currentUser.tiempoTotal = newTotalTime;
          _currentUser.tiempoHoy = newDailyTime;
          _currentUser.ultimoAcceso = endTime;
        });
      }
    } catch (e) {
      print('Error al guardar el tiempo de sesión: $e');
    }
  }

  Future<void> _refreshUserData() async {
    try {
      final userId = _currentUser.id;
      final userRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId);
      final doc = await userRef.get();

      if (doc.exists && mounted) {
        final updatedUser = UserModel.fromFirestore(doc);

        setState(() {
          _currentUser = updatedUser;
          print("Datos del usuario refrescados desde Firestore."); //Debug
          print("Progreso cursos: ${_currentUser.progresoCursos}"); // Debug
        });
      }
    } catch (e) {
      print("Error al refrescar datos del usuario: $e");
    }
  }

  // Función para iniciar una lección
  void _startLesson(
    String courseTitle,
    String idLeccion,
    String lessonTitle,
    String courseDescription,
    int numLeccionesTotal,
    List<String> courseMedals,
    List<int> courseBadges,
  ) {
    setState(() {
      _selectedCourseTitle = courseTitle;
      _selectedLessonId = idLeccion;
      _selectedLessonTitle = lessonTitle;
      _selectedCourseDescription = courseDescription;
      _totalLessonsInCourse = numLeccionesTotal;
      _selectedCourseMedals = courseMedals;
      _selectedCourseBadges = courseBadges;
      _selectedIndex = 1;
    });
  }

  // Función para volver al listado de lecciones
  void _backToLessons() {
    setState(() {
      _selectedLessonId = null;
      _selectedLessonTitle = null;
    });
  }

  // Función para una lección completada
  void _lessonCompleted() {
    //  guardar el progreso o navegar a la pantalla de "Lección Completada"
    _backToLessons();
  }

  // Manejo de la informacion que se muestra en el body
  @override
  Widget build(BuildContext context) {
    Widget body = const Center(child: Text("Cargando..."));

    // Si el curso acaba de terminar, muestra la pantalla de finalización
    if (_courseCompleted) {
      body = DojoCourseCompletedScreen(
        courseTitle: _selectedCourseTitle ?? "Curso",
        courseDescription: _selectedCourseDescription ?? "",
        courseImage: "https://picsum.photos/400/200",
        numLecciones: _totalLessonsInCourse ?? 0,
        medals: _selectedCourseMedals,
        onBackToCourses: () async {
          await _refreshUserData();

          setState(() {
            _selectedCourseId = null;
            _selectedCourseTitle = null;
            _courseCompleted = false;
            _selectedIndex = 1; // Volver al Dojo
          });
        },
      );

      // Si hay una lección activa (ejecutándose), muestra el contenedor de la lección
    } else if (_selectedLessonId != null) {
      body = DojoLessonContainerScreen(
        idLeccion: _selectedLessonId!,
        courseTitle: _selectedCourseTitle!,
        lessonTitle: _selectedLessonTitle!,
        onLessonCompleted: _lessonCompleted,
        onCourseCompleted: _finishCourse,
        onBackToLessons: _backToLessons,
        courseId: _selectedCourseId!,
        numLeccionesTotal: _totalLessonsInCourse!,
        userId: _currentUser.id,
        courseBadges: _selectedCourseBadges,
      );

      // Si hay un curso activo, muestra la lista de lecciones del curso
    } else if (_selectedCourseId != null) {
      body = DojoCourseScreen(
        courseId: _selectedCourseId!,
        onBack: () => setState(() {
          _selectedCourseId = null;
          _selectedCourseTitle = null;
          _totalLessonsInCourse = null;
        }),
        onLessonSelected:
            (
              courseTitle,
              idLeccion,
              lessonTitle,
              courseDescription,
              numLeccionesTotal,
              courseMedals,
              courseBadges,
            ) {
              _startLesson(
                courseTitle,
                idLeccion,
                lessonTitle,
                courseDescription,
                numLeccionesTotal,
                courseMedals,
                courseBadges,
              );
            },
      );

      // Lógica de navegacion principal (Home, Dojo, Courses, Profile)
    } else {
      Widget screen = const Center(child: Text("Pantalla no encontrada"));

      if (_selectedIndex == 0) {
        screen = HomeScreen(
          onCourseSelected: (courseId, courseTitle) {
            setState(() {
              _selectedCourseId = courseId;
              _selectedCourseTitle = courseTitle;
              _selectedIndex = 1;
            });
          },
          currentUser: _currentUser,
          onExploreCourses: () {
            setState(() => _selectedIndex = 2);
          },
          onGoToDojo: () {
            setState(() => _selectedIndex = 1);
          },
        );
      } else if (_selectedIndex == 1) {
        screen = DojoScreen(
          onCourseSelected: (courseId, courseTitle) {
            setState(() {
              _selectedCourseId = courseId;
              _selectedCourseTitle = courseTitle;
            });
          },
          onExploreCourses: () {
            setState(() => _selectedIndex = 2);
          },
          currentUser: _currentUser,
        );
      } else if (_selectedIndex == 2) {
        screen = CoursesScreen(
          onCourseSelected: (courseId, courseTitle) {
            setState(() {
              _selectedCourseId = courseId;
              _selectedCourseTitle = courseTitle;
            });
          },
          currentUser: _currentUser,
        );
      } else if (_selectedIndex == 3) {
        if (_viewingBadges) {
          screen = BeltsAndBadgesScreen(
            onBack: () {
              setState(() => _viewingBadges = false);
            },
            userBadges: _currentUser.badges?.cast<int>() ?? [],
            user: _currentUser,
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
                            "Racha de entrenamiento: ${_currentUser.racha ?? 0} días 🔥",
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
            // Limpiar todo el estado del curso solo si el user NO está en courseCompleted
            if (!_courseCompleted) {
              _selectedCourseId = null;
              _selectedCourseTitle = null;
              _selectedLessonId = null;
              _selectedLessonTitle = null;
              _selectedCourseDescription = null;
              _totalLessonsInCourse = null;
              _selectedCourseMedals = [];
              _selectedCourseBadges = [];
            } else {
              // Si está en courseCompleted, limpiar todo incluyendo el flag
              _selectedCourseId = null;
              _selectedCourseTitle = null;
              _selectedLessonId = null;
              _selectedLessonTitle = null;
              _selectedCourseDescription = null;
              _totalLessonsInCourse = null;
              _selectedCourseMedals = [];
              _selectedCourseBadges = [];
              _courseCompleted = false;
            }

            _selectedIndex = index;
          });

          if (index == 3) {
            _refreshUserData();
          }
        },

        items: [
          BottomNavigationBarItem(
            icon: Image.network(
              _selectedIndex == 0
                  ? "https://raw.githubusercontent.com/aresmargal/cyber_dojo_assets/main/bottomNavigation/homeIconFull.png"
                  : "https://raw.githubusercontent.com/aresmargal/cyber_dojo_assets/main/bottomNavigation/homeIcon.png",
              height: 26,
            ),
            label: "Inicio",
          ),
          BottomNavigationBarItem(
            icon: Image.network(
              _selectedIndex == 1
                  ? "https://raw.githubusercontent.com/aresmargal/cyber_dojo_assets/main/bottomNavigation/dojoIconFull.png"
                  : "https://raw.githubusercontent.com/aresmargal/cyber_dojo_assets/main/bottomNavigation/dojoIcon.png",
              height: 26,
            ),
            label: "Dojo",
          ),
          BottomNavigationBarItem(
            icon: Image.network(
              _selectedIndex == 2
                  ? "https://raw.githubusercontent.com/aresmargal/cyber_dojo_assets/main/bottomNavigation/coursesIconFull.png"
                  : "https://raw.githubusercontent.com/aresmargal/cyber_dojo_assets/main/bottomNavigation/coursesIcon.png",
              height: 28,
            ),
            label: "Misiones",
          ),
          BottomNavigationBarItem(
            icon: Image.network(
              _selectedIndex == 3
                  ? "https://raw.githubusercontent.com/aresmargal/cyber_dojo_assets/main/bottomNavigation/profileIconFull.png"
                  : "https://raw.githubusercontent.com/aresmargal/cyber_dojo_assets/main/bottomNavigation/profileIcon.png",
              height: 26,
            ),
            label: "Perfil",
          ),
        ],
      ),
    );
  }
}
