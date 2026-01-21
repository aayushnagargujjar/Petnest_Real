import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:petnest/models/product_model.dart';
import 'package:petnest/providers/cart_provider.dart';
import 'package:petnest/screens/shop/product_detail_screen.dart';

class ProductCardOnline extends StatelessWidget {
  final ProductModel product;

  const ProductCardOnline({super.key, required this.product});

  // --- ❤️ FIREBASE LIKE FUNCTION ---
  void _toggleLike(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please login to like products!")));
      return;
    }

    final wishlistRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('wishlist')
        .doc(product.id);

    final doc = await wishlistRef.get();

    if (doc.exists) {
      await wishlistRef.delete();
    } else {
      await wishlistRef.set({
        'name': product.name,
        'price': product.price,
        'image': product.imageUrl,
        'addedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final user = FirebaseAuth.instance.currentUser;

    final isItemInCart = cartProvider.items.any((item) => item.id == product.id);
    final quantity = isItemInCart
        ? cartProvider.items.firstWhere((item) => item.id == product.id).quantity
        : 0;

    // --- WRAP EVERYTHING IN GESTURE DETECTOR FOR NAVIGATION ---
    return GestureDetector(
      onTap: () {
        // Navigate to the Detail Screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. Product Image & Like Button ---
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Hero(
                      tag: product.id, // Smooth animation to detail screen
                      child: product.imageUrl.isNotEmpty
                          ? Image.network(product.imageUrl, fit: BoxFit.fitHeight)
                          : const Icon(Icons.pets, color: Colors.grey),
                    ),
                  ),

                  // Like Button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: user == null
                        ? const Icon(Icons.favorite_border, size: 20, color: Colors.grey)
                        : StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .collection('wishlist')
                          .doc(product.id)
                          .snapshots(),
                      builder: (context, snapshot) {
                        final isLiked = snapshot.hasData && snapshot.data!.exists;
                        return GestureDetector(
                          onTap: () => _toggleLike(context),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)]
                            ),
                            child: Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              size: 18,
                              color: isLiked ? Colors.red : Colors.grey[400],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),

            // --- 2. Details Section ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.category.toUpperCase(),
                    style: TextStyle(fontSize: 9, color: Colors.grey[500], fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '₹${product.price.toInt()}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.blue[700]),
                  ),
                ],
              ),
            ),

            // --- 3. Action Button (Cart) ---
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: quantity == 0
                  ? SizedBox(
                width: double.infinity,
                height: 32,
                child: ElevatedButton(
                  onPressed: () => cartProvider.addToCart(product),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue[600],
                    elevation: 0,
                    padding: EdgeInsets.zero,
                    side: BorderSide(color: Colors.blue[600]!, width: 1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('ADD', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              )
                  : Container(
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildCounterButton(Icons.remove, () => cartProvider.updateQuantity(product.id, quantity - 1)),
                    Text('$quantity', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[700], fontSize: 13)),
                    _buildCounterButton(Icons.add, () => cartProvider.updateQuantity(product.id, quantity + 1)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCounterButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Icon(icon, size: 14, color: Colors.blue[700]),
      ),
    );
  }
}