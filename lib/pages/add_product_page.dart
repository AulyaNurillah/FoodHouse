import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final ApiService api = ApiService();

  final name = TextEditingController();
  final price = TextEditingController();
  final desc = TextEditingController();

  bool isLoading = false;

  Future<void> saveProduct() async {
    if (name.text.isEmpty || price.text.isEmpty || desc.text.isEmpty) {
      showMsg("Semua field wajib diisi");
      return;
    }

    setState(() => isLoading = true);

    final token = await StorageService.getToken();
    if (token != null) {
      final success = await api.addProduct(
        token,
        name.text.trim(),
        int.parse(price.text.trim()),
        desc.text.trim(),
      );

      if (!mounted) return;

      showMsg(
        success ? "Produk berhasil ditambah" : "Gagal tambah produk",
      );

      if (success) Navigator.pop(context, true);
    }

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
            "Tambah Produk Baru",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: Color(0xFF0B1F3A),
            ),
          ),
          SizedBox(height: 6),
          Text(
            "Silahkan isi data produk baru dengan lengkap dan benar.",
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
          onPressed: isLoading ? null : saveProduct,
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
                  "SAVE PRODUCT",
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
          "Add Product",
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

            const SizedBox(height: 10),
            button(),
          ],
        ),
      ),
    );
  }
}