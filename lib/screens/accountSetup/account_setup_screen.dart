import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AccountSetupScreen extends StatefulWidget {
  const AccountSetupScreen({super.key});

  @override
  State<AccountSetupScreen> createState() => _AccountSetupScreenState();
}

class AccountSetupData {
  final String image;
  final String title;
  final List<String> options;

  AccountSetupData({
    required this.image,
    required this.title,
    required this.options,
  });
}

final List<AccountSetupData> setupPages = [
  AccountSetupData(
    image: 'assets/images/level.svg',
    title: '¿Qué nivel tienes?',
    options: ['Principiante', 'Intermedio', 'Avanzado'],
  ),
  AccountSetupData(
    image: 'assets/images/daily.svg',
    title: '¿Cuánto quieres entrenar al día?',
    options: ['10 min', '30 min', '1 hora'],
  ),
  AccountSetupData(
    image: 'assets/images/goals.svg',
    title: '¿Cuál es tu objetivo principal?',
    options: ['Aprender teoría', 'Hacer prácticas', 'Ambos'],
  ),
];

class _AccountSetupScreenState extends State<AccountSetupScreen> {
  int currentPage = 0;
  int? selectedOption;

  void _nextPage() {
    if (selectedOption == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Selecciona una opción")),
      );
      return;
    }

    if (currentPage < setupPages.length - 1) {
      setState(() {
        currentPage++;
        selectedOption = null; // reset para la siguiente página
      });
    } else {
      // TODO: Guardar configuración y navegar a Home
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("¡Configuración completada!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final pageData = setupPages[currentPage];

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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 30),
          child: Column(
            children: [
              // Imagen SVG centrada
              SvgPicture.asset(
                pageData.image,
                height: 180,
              ),
              const SizedBox(height: 20),

              // Título
              Text(
                pageData.title,
                style: const TextStyle(
                  color: Color(0xFF723D46),
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              // Opciones
              ...List.generate(pageData.options.length, (index) {
                final option = pageData.options[index];
                final isSelected = selectedOption == index;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedOption = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF472D30)
                          : const Color(0xFF723D46),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      option,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }),

              const Spacer(),

              // Botón Siguiente
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC9CBA3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _nextPage,
                  child: const Text(
                    "Siguiente",
                    style: TextStyle(
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
      ),
    );
  }
}
