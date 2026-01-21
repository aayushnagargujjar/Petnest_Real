
import 'package:flutter/material.dart';
import 'package:petnest/models/product.dart';
import 'package:provider/provider.dart';
import 'package:petnest/providers/cart_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final product = ModalRoute.of(context)!.settings.arguments as Product;
    final cartProvider = Provider.of<CartProvider>(context);
    final itemInCart = cartProvider.items.any((item) => item.id == product.id);
    final quantity = itemInCart ? cartProvider.items.firstWhere((item) => item.id == product.id).quantity : 0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 300,
            backgroundColor: Colors.orange[50],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Colors.orange[50],
                padding: const EdgeInsets.all(40),
                child: Image.network(product.image, fit: BoxFit.contain),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        '₹${product.price.toInt()}',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (product.weight != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(20)),
                      child: Text(product.weight!, style: TextStyle(color: Colors.grey[800], fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  const SizedBox(height: 24),
                  const Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    product.description ?? 'No description available.',
                    style: const TextStyle(color: Colors.grey, height: 1.5, fontSize: 16),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.black12))),
        child: quantity == 0 
        ? ElevatedButton(
            onPressed: () {
                cartProvider.addToCart(product);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added to cart!'), duration: Duration(milliseconds: 1000)));
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[600], padding: const EdgeInsets.symmetric(vertical: 16)),
            child: const Text('Add to Cart', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('In Cart', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              Container(
                decoration: BoxDecoration(color: Colors.blue[600], borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    IconButton(icon: const Icon(Icons.remove, color: Colors.white), onPressed: () => cartProvider.updateQuantity(product.id, quantity - 1)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('$quantity', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                    ),
                    IconButton(icon: const Icon(Icons.add, color: Colors.white), onPressed: () => cartProvider.updateQuantity(product.id, quantity + 1)),
                  ],
                ),
              )
            ],
          ),
      ),
    );
  }
}
