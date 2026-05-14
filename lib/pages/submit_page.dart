import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class SubmitPage extends StatefulWidget {
  const SubmitPage({super.key});

  @override
  State<SubmitPage> createState() => _SubmitPageState();
}

class _SubmitPageState extends State<SubmitPage> {
  final ApiService api = ApiService();

  final name = TextEditingController();
  final price = TextEditingController();
  final desc = TextEditingController();
  final github = TextEditingController();

  bool isLoading = false;

  Future<void> submit() async {
  if ([name, price, desc, github].any((e) => e.text.isEmpty)) {
    showMsg("Semua field wajib diisi");
    return;
  }

  final parsedPrice = int.tryParse(price.text.trim());
  if (parsedPrice == null) {
    showMsg("Harga harus angka");
    return;
  }

  setState(() => isLoading = true);

  final token = await StorageService.getToken();

  if (token == null) {
    showMsg("Token tidak ditemukan, login ulang");
    setState(() => isLoading = false);
    return;
  }

  final success = await api.submitTugas(
    token,
    name.text.trim(),
    parsedPrice,
    desc.text.trim(),
    github.text.trim(),
  );

  if (!mounted) return;

  showMsg(success ? "Tugas berhasil dikirim!" : "Gagal submit tugas");

  if (success) Navigator.pop(context);

  setState(() => isLoading = false);
}

  void showMsg(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  Widget fieldBox({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    int lines = 1,
    TextInputType type = TextInputType.text,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: lines,
        keyboardType: type,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: const Color(0xFF0B1F3A)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
          ),
        ),
      ),
    );
  }

  Widget header() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Kirim Tugas Produk",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: Color(0xFF0B1F3A),
            ),
          ),
          SizedBox(height: 6),
          Text(
            "Silahkan isi seluruh form di bawah sebelum mengirim tugas.",
            style: TextStyle(
              color: Colors.black54,
              height: 1.5,
            ),
          ),
        ],
      );

  Widget button() => SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          onPressed: isLoading ? null : submit,
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
                  "SUBMIT",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F1E9),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1F3A),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Submit Tugas",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header(),
            const SizedBox(height: 24),

            fieldBox(
              controller: name,
              hint: "Nama Produk",
              icon: Icons.restaurant_menu,
            ),
            fieldBox(
              controller: price,
              hint: "Harga",
              icon: Icons.payments,
              type: TextInputType.number,
            ),
            fieldBox(
              controller: desc,
              hint: "Deskripsi Produk",
              icon: Icons.notes,
              lines: 4,
            ),
            fieldBox(
              controller: github,
              hint: "GitHub URL",
              icon: Icons.link,
            ),

            const SizedBox(height: 10),
            button(),
          ],
        ),
      ),
    );
  }
}