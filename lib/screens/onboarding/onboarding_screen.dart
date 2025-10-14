import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cyber_dojo/screens/auth/login_screen.dart';
import 'package:cyber_dojo/screens/auth/register_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "image": "assets/images/onBoarding/onBng1.svg",
      "title": "Entrena como un ninja digital",
      "subtitle": "Domina la ciberseguridad desde cero",
    },
    {
      "image": "assets/images/onBoarding/onBng2.svg",
      "title": "Avanza de cinturón en cinturón",
      "subtitle": "Supera lecciones y sube de rango en tu camino a la ciberseguridad",
    },
    {
      "image": "assets/images/onBoarding/onBng3.svg",
      "title": "Protege, aprende, domina",
      "subtitle": "Conviértete en un experto en seguridad paso a paso",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFE1A8),
      body: SafeArea(
        child: Column(
          children: [
            // PageView con las 3 pantallas
            Expanded(
              flex: 6,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (value) {
                  setState(() {
                    _currentPage = value;
                  });
                },
                itemCount: onboardingData.length,
                itemBuilder: (context, index) => OnboardContent(
                  image: onboardingData[index]["image"]!,
                  title: onboardingData[index]["title"]!,
                  subtitle: onboardingData[index]["subtitle"]!,
                ),
              ),
            ),

            // Indicadores
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                onboardingData.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  width: _currentPage == index ? 20 : 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? const Color(0xff723D46)
                        : Colors.white54,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            const Spacer(),

            // Botón "Crear cuenta"
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff723D46),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const RegisterScreen()),
    );
                },
                child: const Text(
                  "Crear cuenta",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Texto inferior con opción de iniciar sesión
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
              },
              child: const Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Text(
                  "¿Ya tienes una cuenta? Inicia sesión",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardContent extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;

  const OnboardContent({super.key, required this.image, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           SvgPicture.asset(
            image,
            height: 250,
          ),
          const SizedBox(height: 40),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 26,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 20,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
