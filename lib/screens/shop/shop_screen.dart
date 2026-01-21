import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petnest/models/product_model.dart';
import 'package:petnest/widgets/product_card_online.dart'; // Make sure this matches your file name

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  String _activeCategory = 'All';
  final List<String> _categories = ['All', 'Food & Treats', 'Pharmacy', 'Toys'];
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // Reference to Firestore 'products' collection
  final CollectionReference _productsRef = FirebaseFirestore.instance.collection('products');

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // --- Search Bar ---
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
          ),
          child: TextField(
            controller: _searchController,
            onChanged: (value) => setState(() => _searchQuery = value),
            decoration: InputDecoration(
              hintText: 'Search for products...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),

        // --- Main Content ---
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Sidebar Categories ---
              Container(
                width: 85,
                color: Colors.white,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    final isActive = _activeCategory == cat;
                    return GestureDetector(
                      onTap: () => setState(() => _activeCategory = cat),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
                        decoration: BoxDecoration(
                          color: isActive ? Colors.blue[600] : Colors.transparent,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                        ),
                        child: Text(
                          cat.replaceAll(' & ', ' &\n'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isActive ? Colors.white : Colors.grey[600],
                            height: 1.2,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // --- Product Grid (StreamBuilder) ---
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _productsRef.snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return const Center(child: Text("Error loading products"));
                    }

                    // 1. Convert Data from Firebase to ProductModel
                    final allProducts = snapshot.data!.docs.map((doc) {
                      return ProductModel.fromFirestore(doc);
                    }).toList();

                    // 2. Filter Data (Category + Search)
                    final filteredProducts = allProducts
                        .where((p) => p.category != 'Pets')
                        .where((p) => _activeCategory == 'All' || p.category == _activeCategory)
                        .where((p) => p.name.toLowerCase().contains(_searchQuery.toLowerCase()))
                        .toList();

                    if (filteredProducts.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off, size: 64, color: Colors.grey[300]),
                            const SizedBox(height: 16),
                            const Text("No products found", style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      );
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        // IMP: 0.75 ratio ensures the "ADD" button has enough space
                        childAspectRatio: 0.55,
                      ),
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        return ProductCardOnline(product: filteredProducts[index]);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}