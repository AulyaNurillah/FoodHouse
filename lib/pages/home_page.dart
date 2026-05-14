import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import 'login_page.dart';
import 'add_product_page.dart';
import 'submit_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService api = ApiService();

  List<Product> products = [];
  bool isLoading = true;

  final foodIcons = [
    Icons.fastfood,
    Icons.local_pizza,
    Icons.ramen_dining,
    Icons.lunch_dining,
    Icons.icecream,
    Icons.set_meal,
    Icons.emoji_food_beverage,
    Icons.bakery_dining,
  ];

  @override
  void initState() {
    super.initState();
    getProducts();
  }

  Future<void> getProducts() async {
    setState(() => isLoading = true);

    final token = await StorageService.getToken();
    if (token != null) {
      products = await api.getProducts(token);
    }

    setState(() => isLoading = false);
  }

  Future<void> logout() async {
    await StorageService.removeToken();
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  Future<void> deleteItem(int id) async {
    final token = await StorageService.getToken();
    if (token == null) return;

    final success = await api.deleteProduct(token, id);

    if (success) {
      getProducts();
      showMsg("Produk berhasil dihapus");
    } else {
      showMsg("Gagal menghapus produk");
    }
  }

  void showMsg(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  IconData iconFor(Product item) {
    final seed = item.id % foodIcons.length;
    return foodIcons[seed];
  }

  Future<void> confirmDelete(Product item) async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          "Hapus Produk",
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: Color(0xFF0B1F3A),
          ),
        ),
        content: Text("Yakin ingin menghapus ${item.name}?"),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 42,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: const BorderSide(color: Color(0xFF0B1F3A)),
                    ),
                    child: const Text("BATAL",
                        style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 42,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      deleteItem(item.id);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0B1F3A),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "HAPUS",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget card(Product item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 12),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF0F8),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              iconFor(item),
              color: const Color(0xFF0B1F3A),
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0B1F3A),
                  ),
                ),
                const SizedBox(height: 6),
                Text(item.description,
                    style: const TextStyle(color: Colors.black54)),
                const SizedBox(height: 8),
                Text(
                  "Rp ${item.price}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Color(0xFF0B1F3A),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () => confirmDelete(item),
          )
        ],
      ),
    );
  }

  Widget loader() =>
      const Center(child: CircularProgressIndicator());

  Widget empty() => const Center(
        child: Text("Belum ada produk 🍽️", style: TextStyle(fontSize: 16)),
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
          "FOOD HOUSE",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SubmitPage()),
            ),
          ),
          IconButton(onPressed: logout, icon: const Icon(Icons.logout)),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: getProducts,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: isLoading
              ? loader()
              : products.isEmpty
                  ? empty()
                  : ListView(children: products.map(card).toList()),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF0B1F3A),
        foregroundColor: Colors.white,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddProductPage()),
          );
          getProducts();
        },
        icon: const Icon(Icons.add),
        label: const Text("Add"),
      ),
    );
  }
}