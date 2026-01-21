import 'package:flutter/foundation.dart';
import 'package:petnest/models/product.dart';       // Old Offline Model
import 'package:petnest/models/product_model.dart'; // New Online Model

// Unified CartItem (Stores everything as String to be safe)
class CartItem {
  final String id;
  final String name;
  final double price;
  final String image;
  final String? category;
  final String? weight;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    this.category,
    this.weight,
    this.quantity = 1,
  });
}

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => [..._items];

  // Helper: Count total items
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  // Helper: Calculate total price
  double get totalAmount => _items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));

  // --- 🛒 HYBRID ADD TO CART ---
  // Accepts 'dynamic' so it can take both Product (Old) AND ProductModel (New)
  void addToCart(dynamic product) {
    String id;
    String name;
    double price;
    String image;
    String? category;
    String? weight;

    // DETECT: Is it the New Online Product?
    if (product is ProductModel) {
      id = product.id;
      name = product.name;
      price = product.price;
      image = product.imageUrl;
      category = product.category;
      weight = null; // Online model doesn't have weight yet
    }
    // DETECT: Is it the Old Offline Product?
    else if (product is Product) {
      id = product.id.toString(); // Convert int ID to String!
      name = product.name;
      price = product.price;
      image = product.image;
      category = product.category;
      weight = product.weight;
    }
    else {
      print("Error: Unknown product type");
      return;
    }

    // Logic: Check if item is already in cart
    final index = _items.indexWhere((item) => item.id == id);
    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(
        id: id,
        name: name,
        price: price,
        image: image,
        category: category,
        weight: weight,
        quantity: 1,
      ));
    }
    notifyListeners(); // Refresh UI
  }

  // --- ➕➖ HYBRID UPDATE QUANTITY ---
  // Accepts 'dynamic id' to handle both '10' (int) and '"27"' (String)
  void updateQuantity(dynamic id, int newQuantity) {
    final String searchId = id.toString(); // Convert everything to String to match CartItem

    final index = _items.indexWhere((item) => item.id == searchId);
    if (index >= 0) {
      if (newQuantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = newQuantity;
      }
      notifyListeners(); // Refresh UI
    }
  }

  // Clear Cart
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}