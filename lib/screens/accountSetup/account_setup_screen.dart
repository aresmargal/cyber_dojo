import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AccountSetupScreen extends StatefulWidget {
  const AccountSetupScreen({super.key});

  @override
  State<AccountSetupScreen> createState() => _AccountSetupScreenState();
}

class AccountSetupData {
  final String imageSvg;
  final String title;
  final List<String> options;

  AccountSetupData({
    required this.imageSvg,
    required this.title,
    required this.options,
  });
}

final List<AccountSetupData> setupPages = [
  AccountSetupData(
    imageSvg: 'assets/images/accountSetup/accSt1.svg',
    title: '¿Qué nivel tienes?',
    options: ['Principiante', 'Intermedio', 'Avanzado'],
  ),
  AccountSetupData(
    imageSvg: 'assets/images/accountSetup/accSt2.svg',
    title: '¿Cuánto quieres entrenar al día?',
    options: ['10 min', '30 min', '1 hora'],
  ),
  AccountSetupData(
    imageSvg: 'assets/images/accountSetup/accSt3.svg',
    title: '¿Cuál es tu objetivo principal?',
    options: ['Aprender teoría', 'Hacer prácticas', 'Ambos'],
  ),
];

class _AccountSetupScreenState extends State<AccountSetupScreen> {
  final PageController _pageController = PageController();
  int currentPage = 0;
  final Map<int, int?> selectedOptions = {};

  void _nextPage() {
    if (selectedOptions[currentPage] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Selecciona una opción")),
      );
      return;
    }

    if (currentPage < setupPages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("¡Configuración completada!")),
      );
      // TODO: Guardar datos y navegar a Home
    }
  }

  void _previousPage() {
    if (currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE1A8),
      appBar: AppBar(
        title: const Text(
          "Configura tu cuenta",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF723D46),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const BouncingScrollPhysics(),
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                itemCount: setupPages.length,
                itemBuilder: (context, index) {
                  final page = setupPages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 20),
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          page.imageSvg,
                          height: 140,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          page.title,
                          style: const TextStyle(
                            color: Color(0xFF723D46),
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),

                        // Opciones
                        ...List.generate(page.options.length, (optIndex) {
                          final isSelected =
                              selectedOptions[index] == optIndex;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedOptions[index] = optIndex;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF472D30)
                                    : const Color(0xFF723D46),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                page.options[optIndex],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Botones de navegación
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: Row(
                children: [
                  if (currentPage > 0)
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF723D46),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _previousPage,
                        child: const Text(
                          "Atrás",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  if (currentPage > 0) const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC9CBA3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _nextPage,
                      child: Text(
                        currentPage == setupPages.length - 1
                            ? "Finalizar"
                            : "Siguiente",
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
