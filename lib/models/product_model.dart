import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String name;
  final String category;
  final double price;
  final String imageUrl;
  final String description;

  ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.imageUrl,
    required this.description,
  });

  // Factory to convert Firestore JSON to Dart Object
  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ProductModel(
      id: doc.id,
      name: data['name'] ?? 'Unknown',
      category: data['category'] ?? 'All',
      // Handles both Int and Double from Firestore
      price: (data['price'] ?? 0).toDouble(),
      imageUrl: data['image'] ?? '',
      description: data['description'] ?? '',
    );
  }
}