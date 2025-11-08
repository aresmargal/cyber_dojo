import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  final VoidCallback onBack;

  const EditProfileScreen({super.key, required this.onBack});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController(text: "Lydia");
  final TextEditingController _usernameController = TextEditingController(text: "@LydiaNinja");
  final TextEditingController _emailController = TextEditingController(text: "lydia@ejemplo.com");

  String _selectedAvatar = "assets/images/pfp/pfp4.png"; // imagen por defecto

  void _showAvatarPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: const Color(0xFFFFE1A8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Elige tu nuevo avatar",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xFF472D30),
                  ),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: List.generate(6, (index) {
                    String avatarPath = "assets/images/pfp/pfp${index + 1}.png";
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedAvatar = avatarPath;
                        });
                        Navigator.pop(context); // cierra el diálogo
                      },
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        backgroundImage: AssetImage(avatarPath),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Cancelar",
                    style: TextStyle(color: Color(0xFF472D30)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 20),

          // 🔹 Botón volver arriba
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF472D30)),
              onPressed: widget.onBack,
            ),
          ),

          const SizedBox(height: 10),

          // 🖼️ Foto + editar
           Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(_selectedAvatar),
              ),
              Positioned(
                bottom: 0,
                right: 4,
                child: GestureDetector(
                  onTap: _showAvatarPicker,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF723D46),
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          const Text("Lydia",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF472D30))),
          const SizedBox(height: 4),
          const Text("lydia@ejemplo.com",
              style: TextStyle(fontSize: 15, color: Color(0xFF472D30))),
          const SizedBox(height: 4),
          const Text("Cinturón: Blanco",
              style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF472D30),
                  fontWeight: FontWeight.w600)),

          const SizedBox(height: 30),

          _buildLabel("Nombre"),
          _buildTextField(_nameController),

          const SizedBox(height: 16),

          _buildLabel("Nombre de usuario"),
          _buildTextField(_usernameController),

          const SizedBox(height: 16),

          _buildLabel("Correo electrónico"),
          _buildTextField(_emailController),

          const SizedBox(height: 30),

          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Cambios guardados correctamente"),
                  backgroundColor: Color(0xFF472D30),
                ),
              );
              widget.onBack();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF723D46),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "Guardar cambios",
              style: TextStyle(color: Color(0xFFFFE1A8), fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF472D30),
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFFFE1A8),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF472D30)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF472D30)),
        ),
      ),
      style: const TextStyle(color: Color(0xFF472D30)),
    );
  }
}
