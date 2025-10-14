import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController =
      TextEditingController();

  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE1A8),
      appBar: AppBar(
        title: const Text(
          "Crear cuenta",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Crea tu cuenta y conviértete en un ninja digital",
                  style: TextStyle(
                    color: Color(0xFF723D46),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 30),

                // Nombre (alias)
                _buildTextField(
                  controller: _nameController,
                  label: "Nombre (alias)",
                  icon: Icons.person_outline,
                  validator: (v) =>
                      v!.isEmpty ? "Introduce tu nombre o alias" : null,
                ),
                const SizedBox(height: 20),

                // Nombre de usuario
                _buildTextField(
                  controller: _usernameController,
                  label: "Nombre de usuario",
                  icon: Icons.alternate_email,
                  validator: (v) =>
                      v!.isEmpty ? "Introduce un nombre de usuario" : null,
                ),
                const SizedBox(height: 20),

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
                      v!.length < 8 ? "Mínimo 8 caracteres" : null,
                ),
                const SizedBox(height: 20),

                // Repetir contraseña
                _buildTextField(
                  controller: _repeatPasswordController,
                  label: "Repetir contraseña",
                  icon: Icons.lock_reset_outlined,
                  obscureText: !_isPasswordVisible,
                  validator: (v) {
                    if (v!.isEmpty) return "Repite la contraseña";
                    if (v != _passwordController.text) {
                      return "Las contraseñas no coinciden";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 40),

                // Botón principal
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
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text("Cuenta creada con éxito. Bienvenido a CyberDojo."),
                          ),
                        );
                      }
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

                const SizedBox(height: 25),

                // Texto inferior
                Center(
                  child: GestureDetector(
                    onTap: () {
                      // TODO: Navegar a iniciar sesión
                    },
                    child: const Text(
                      "¿Ya tienes una cuenta? Inicia sesión",
                      style: TextStyle(
                        color: Color(0xFF723D46),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
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
