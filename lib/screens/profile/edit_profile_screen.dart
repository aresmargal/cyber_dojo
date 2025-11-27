import 'package:cyber_dojo/models/user.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfileScreen extends StatefulWidget {
  final void Function(UserModel?) onBack;
  final UserModel user;

  const EditProfileScreen({
    super.key,
    required this.onBack,
    required this.user,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;

  final List<String> avatarUrls = [
    "https://raw.githubusercontent.com/aresmargal/cyber_dojo_assets/main/pfp/pfp1.png",
    "https://raw.githubusercontent.com/aresmargal/cyber_dojo_assets/main/pfp/pfp2.png",
    "https://raw.githubusercontent.com/aresmargal/cyber_dojo_assets/main/pfp/pfp3.png",
    "https://raw.githubusercontent.com/aresmargal/cyber_dojo_assets/main/pfp/pfp4.png",
    "https://raw.githubusercontent.com/aresmargal/cyber_dojo_assets/main/pfp/pfp5.png",
    "https://raw.githubusercontent.com/aresmargal/cyber_dojo_assets/main/pfp/pfp6.png",
  ];

  String? _selectedAvatar;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.alias);
    _usernameController = TextEditingController(text: widget.user.username);
    _emailController = TextEditingController(text: widget.user.email);

    _selectedAvatar = widget.user.fotoPerfil;
  }

  void _showAvatarPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: const Color(0xFFFFE1A8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
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
                  children: avatarUrls.map((url) {
                    return GestureDetector(
                      onTap: () {
                        setState(() => _selectedAvatar = url);
                        Navigator.pop(context);
                      },
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(url),
                      ),
                    );
                  }).toList(),
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

          //  Botón volver arriba
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF472D30)),
              onPressed: () => widget.onBack(null),
            ),
          ),

          const SizedBox(height: 10),

          // Foto + editar
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: const Color(0xFF723D46),
                backgroundImage:
                    _selectedAvatar != null && _selectedAvatar!.isNotEmpty
                    ? NetworkImage(_selectedAvatar!)
                    : null,
                child: (_selectedAvatar == null || _selectedAvatar!.isEmpty)
                    ? Text(
                        widget.user.username[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                        ),
                      )
                    : null,
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

          Text(
            _nameController.text.trim(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF472D30),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _emailController.text.trim(),
            style: TextStyle(fontSize: 15, color: Color(0xFF472D30)),
          ),
          const SizedBox(height: 4),
          Text(
            "Cinturón: ${widget.user.nivel}",
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFF472D30),
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 30),

          _buildLabel("Alias: "),
          _buildTextField(_nameController),

          const SizedBox(height: 16),

          _buildLabel("Nombre de usuario: "),
          _buildTextField(_usernameController),

          const SizedBox(height: 16),

          _buildLabel("Correo electrónico: "),
          _buildTextField(_emailController),

          const SizedBox(height: 30),

          ElevatedButton(
            onPressed: () async {
              try {
                final newAlias = _nameController.text.trim();
                final newUsername = _usernameController.text.trim();
                final newEmail = _emailController.text.trim();
                final newFotoPerfil = _selectedAvatar ?? "";

                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.user.id)
                    .update({
                      'alias': newAlias,
                      'username': newUsername,
                      'email': newEmail,
                      'fotoPerfil': newFotoPerfil,
                    });

                final updatedUser = UserModel(
                  id: widget.user.id,
                  alias: newAlias,
                  email: newEmail,
                  username: newUsername,
                  password: widget.user.password,
                  fotoPerfil: newFotoPerfil,
                  nivel: widget.user.nivel,
                  tiempoTotal: widget.user.tiempoTotal,
                  badges: widget.user.badges,
                  racha: widget.user.racha
                );

                if (mounted) {
                  widget.onBack(updatedUser);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Cambios guardados correctamente"),
                      backgroundColor: Color(0xFF472D30),
                    ),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Error al guardar: $e"),
                    backgroundColor: Colors.red,
                  ),
                );
              }
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
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
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
