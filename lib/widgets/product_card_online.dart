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

  // ❤️ LIKE / UNLIKE
  Future<void> _toggleLike(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please login to like products")),
      );
      return;
    }

    final ref = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('wishlist')
        .doc(product.id);

    final doc = await ref.get();
    if (doc.exists) {
      await ref.delete();
    } else {
      await ref.set({
        'name': product.name,
        'price': product.price,
        'image': product.imageUrl,
        'addedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final user = FirebaseAuth.instance.currentUser;

    final isInCart = cart.items.any((i) => i.id == product.id);
    final quantity = isInCart
        ? cart.items.firstWhere((i) => i.id == product.id).quantity
        : 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
            Expanded(
          // 🔹 IMAGE + NAVIGATION
          child:InkWell(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductDetailScreen(product: product),
                ),
              );
            },
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                    borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(18)),
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // ❤️ LIKE BUTTON (NOW WORKS)
                Positioned(
                  top: 8,
                  right: 8,
                  child: user == null
                      ? _likeIcon(false, null)
                      : StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .collection('wishlist')
                        .doc(product.id)
                        .snapshots(),
                    builder: (context, snapshot) {
                      final liked =
                          snapshot.hasData && snapshot.data!.exists;
                      return _likeIcon(
                        liked,
                            () => _toggleLike(context),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
            ),
          // 🔹 DETAILS
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.category.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  '₹${product.price.toInt()}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
              ],
            ),
          ),

          // 🔹 CART ACTION
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: quantity == 0
                ? SizedBox(
              height: 34,
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => cart.addToCart(product),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.blue[600]!),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'ADD',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            )
                : Container(
              height: 34,
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _counter(Icons.remove,
                          () => cart.updateQuantity(product.id, quantity - 1)),
                  Text(
                    '$quantity',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[700]),
                  ),
                  _counter(Icons.add,
                          () => cart.updateQuantity(product.id, quantity + 1)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ❤️ Like icon widget
  Widget _likeIcon(bool liked, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
        ),
        child: Icon(
          liked ? Icons.favorite : Icons.favorite_border,
          size: 18,
          color: liked ? Colors.red : Colors.grey,
        ),
      ),
    );
  }

  Widget _counter(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Icon(icon, size: 18, color: Colors.blue[700]),
    );
  }
}
