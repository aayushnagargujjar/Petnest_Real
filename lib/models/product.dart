
class Product {
  final int id;
  final String name;
  final double price;
  final double? mrp;
  final String category;
  final String image;
  final String? brandLogo;
  final String? weight;
  final String? description;
  final String? brand;
  final int? deliveryTime;
  final double? rating;
  final String? reviewCount;
  final List<String>? tags;
  final String? unitPrice;
  final int? options;
  final String? listingType; // 'buy' or 'adopt'
  final String? breed;
  final String? age;
  final String? gender; // 'Male' or 'Female'
  final bool? verified;
  final String? videoUrl;
  final double? advancePrice;
  final Map<String, String>? breederInfo;

  Product({
    required this.id,
    required this.name,
    required this.price,
    this.mrp,
    required this.category,
    required this.image,
    this.brandLogo,
    this.weight,
    this.description,
    this.brand,
    this.deliveryTime,
    this.rating,
    this.reviewCount,
    this.tags,
    this.unitPrice,
    this.options,
    this.listingType,
    this.breed,
    this.age,
    this.gender,
    this.verified,
    this.videoUrl,
    this.advancePrice,
    this.breederInfo,
  });
}

class CartItem extends Product {
  int quantity;

  CartItem({
    required super.id,
    required super.name,
    required super.price,
    super.mrp,
    required super.category,
    required super.image,
    super.brandLogo,
    super.weight,
    super.description,
    super.brand,
    super.deliveryTime,
    super.rating,
    super.reviewCount,
    super.tags,
    super.unitPrice,
    super.options,
    super.listingType,
    super.breed,
    super.age,
    super.gender,
    super.verified,
    super.videoUrl,
    super.advancePrice,
    super.breederInfo,
    this.quantity = 1,
  });
}
