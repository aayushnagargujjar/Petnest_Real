
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:petnest/providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final total = cart.totalAmount;
    const delivery = 29.0;
    const platform = 6.0;
    final grandTotal = total + delivery + platform;

    return Scaffold(
      appBar: AppBar(title: Text('Your Cart (${cart.itemCount})')),
      body: cart.items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  const Text('Your cart is empty', style: TextStyle(fontSize: 18, color: Colors.grey)),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[600]),
                    child: const Text(' Start Shopping '),
                  )
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final item = cart.items[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                        child: Row(
                          children: [
                            Container(
                              width: 60, height: 60,
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(image: NetworkImage(item.image), fit: BoxFit.cover),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  if(item.weight != null) Text(item.weight!, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                  const SizedBox(height: 4),
                                  Text('₹${item.price.toInt()}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(8)),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove, size: 18),
                                    color: Colors.blue[600],
                                    onPressed: () => cart.updateQuantity(item.id, item.quantity - 1),
                                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                    padding: EdgeInsets.zero,
                                  ),
                                  Text('${item.quantity}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[900])),
                                  IconButton(
                                    icon: const Icon(Icons.add, size: 18),
                                    color: Colors.blue[600],
                                    onPressed: () => cart.updateQuantity(item.id, item.quantity + 1),
                                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                    padding: EdgeInsets.zero,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12, offset: Offset(0, -4))],
                  ),
                  child: Column(
                    children: [
                      _buildBillRow('Item Total', '₹${total.toInt()}'),
                      _buildBillRow('Delivery Fee', '₹${delivery.toInt()}'),
                      _buildBillRow('Platform Fee', '₹${platform.toInt()}'),
                      const Divider(height: 30),
                      _buildBillRow('To Pay', '₹${grandTotal.toInt()}', isTotal: true),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pushNamed(context, '/app/order-summary'),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[600]),
                          child: const Text('Place Order'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildBillRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: isTotal ? FontWeight.bold : FontWeight.normal, fontSize: isTotal ? 18 : 14)),
          Text(value, style: TextStyle(fontWeight: isTotal ? FontWeight.bold : FontWeight.normal, fontSize: isTotal ? 18 : 14)),
        ],
      ),
    );
  }
}
