import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final username = TextEditingController();
  final password = TextEditingController();

  final ApiService api = ApiService();

  bool isLoading = false;
  bool isHidden = true;

  Future<void> login() async {
    if (username.text.isEmpty || password.text.isEmpty) {
      showMsg("Username dan Password wajib diisi");
      return;
    }

    setState(() => isLoading = true);

    final token = await api.login(
      username.text.trim(),
      password.text.trim(),
    );

    if (token != null) {
      await StorageService.saveToken(token);
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } else {
      showMsg("Login gagal");
    }

    setState(() => isLoading = false);
  }

  void showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  InputDecoration fieldStyle({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: const Color(0xFF0B1F3A)),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget gap(double h) => SizedBox(height: h);

  Widget iconBox() => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF0B1F3A),
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Icon(
          Icons.restaurant,
          size: 62,
          color: Color(0xFFF6F1E9),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F1E9),

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                iconBox(),
                gap(24),

                const Text(
                  "Food House",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF0B1F3A),
                    letterSpacing: 1.2,
                  ),
                ),

                gap(8),

                const Text(
                  "Halo, Selamat datang kembali!👋",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                gap(36),

                TextField(
                  controller: username,
                  decoration: fieldStyle(
                    hint: "Username",
                    icon: Icons.person,
                  ),
                ),

                gap(18),

                TextField(
                  controller: password,
                  obscureText: isHidden,
                  decoration: fieldStyle(
                    hint: "Password",
                    icon: Icons.lock,
                    suffix: IconButton(
                      icon: Icon(
                        isHidden
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () => setState(() => isHidden = !isHidden),
                    ),
                  ),
                ),

                gap(28),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0B1F3A),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "LOGIN",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),

                gap(20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}