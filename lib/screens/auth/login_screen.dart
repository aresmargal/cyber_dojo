import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyber_dojo/models/user.dart';
import 'package:cyber_dojo/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cyber_dojo/screens/auth/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  //Método para validar usuario
  Future<void> _loginUser() async {
    if(!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try{
      final query = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

      if (query.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Usuario no encontrado")),);
        return;
      }

      final doc = query.docs.first;
      final userData = doc.data();

      //Comprobar contraeña TODO: SOLO PARA PRUEBAS, CAMBIAR A FIREBASE AUTHENTICATOR
      if(userData['password'] != password) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Contraseña incorrecta")),);
        return;
      }

      // Crear el UserModel
      final user = UserModel.fromMap(doc.id, userData);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(user: user),
        ),
      );
    } catch (e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al iniciar sesion: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE1A8),
      appBar: AppBar(
        title: const Text(
          "Iniciar sesión",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF723D46),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 30),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Imagen superior
                SvgPicture.asset('assets/images/loginScreen.svg', height: 180),
                const SizedBox(height: 20),

                // Texto motivador
                const Text(
                  "Tu entrenamiento te espera",
                  style: TextStyle(
                    color: Color(0xFF723D46),
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 40),

                // Correo electrónico
                _buildTextField(
                  controller: _emailController,
                  label: "Correo electrónico",
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v!.isEmpty) return "Introduce tu correo";
                    if (!v.contains("@")) return "Correo no válido";
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Contraseña
                _buildTextField(
                  controller: _passwordController,
                  label: "Contraseña",
                  icon: Icons.lock_outline,
                  obscureText: !_isPasswordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: const Color(0xFF723D46),
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  validator: (v) =>
                      v!.isEmpty ? "Introduce tu contraseña" : null,
                ),

                const SizedBox(height: 40),

                // Botón de iniciar sesión
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF723D46),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _loginUser,
                    child: const Text(
                      "Iniciar sesión",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // Texto inferior
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "¿Aún no tienes una cuenta? Crear cuenta",
                    style: TextStyle(
                      color: Color(0xFF723D46),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget reutilizable
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.black87),
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black87),
        prefixIcon: Icon(icon, color: const Color(0xFF723D46)),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF723D46), width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF723D46), width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
