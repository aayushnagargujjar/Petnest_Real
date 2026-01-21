
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:petnest/models/product.dart';
import 'package:petnest/providers/cart_provider.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final itemInCart = cartProvider.items.any((item) => item.id == product.id);
    final quantity = itemInCart ? cartProvider.items.firstWhere((item) => item.id == product.id).quantity : 0;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Center(
              child: Image.network(product.image, fit: BoxFit.contain, height: 120),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '₹${product.price.toInt()}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                if (product.mrp != null)
                  Text(
                    '₹${product.mrp?.toInt()}',
                    style: const TextStyle(
                      fontSize: 12,
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey,
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: quantity == 0
                ? SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => cartProvider.addToCart(product),
                      child: const Text('ADD'),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () => cartProvider.updateQuantity(product.id, quantity - 1),
                      ),
                      Text('$quantity', style: const TextStyle(fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => cartProvider.updateQuantity(product.id, quantity + 1),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
