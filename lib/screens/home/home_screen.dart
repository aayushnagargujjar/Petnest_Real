import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petnest/models/product_model.dart';
import 'package:petnest/widgets/product_card_online.dart';
import 'package:petnest/data/mock_data.dart';
import 'package:petnest/models/service_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  // Reference to Firestore 'products' collection
  final CollectionReference _productsRef = FirebaseFirestore.instance.collection('products');

  final List<String> _offerImages = [
    'https://images.unsplash.com/photo-1583337130417-3346a1be7dee?auto=format&fit=crop&w=600&q=80',
    'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?auto=format&fit=crop&w=600&q=80',
    'https://images.unsplash.com/photo-1548199973-03cce0bbc87b?auto=format&fit=crop&w=600&q=80',
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentPage < _offerImages.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Search Bar
            _buildSearchBar(),
            const SizedBox(height: 24),

            // 2. Carousel
            _buildOfferCarousel(),
            const SizedBox(height: 24),

            // 3. Services (Mock Data)
            _buildServicesSection(context),
            const SizedBox(height: 24),

            // 4. BESTSELLERS GRID (Connected to Firebase ☁️)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    'Bestsellers',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)
                ),
                const SizedBox(height: 16),

                StreamBuilder<QuerySnapshot>(
                  stream: _productsRef.snapshots(),
                  builder: (context, snapshot) {
                    // A. Loading State
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // B. Error State
                    if (snapshot.hasError) {
                      return const Center(child: Text("Error loading products"));
                    }

                    // C. Data Loaded
                    final allProducts = snapshot.data!.docs.map((doc) {
                      return ProductModel.fromFirestore(doc);
                    }).toList();

                    // --- 🧠 SMART FALLBACK LOGIC ---
                    List<ProductModel> displayList;

                    // Logic: Try to find expensive items (Price > 500)
                    final highValueItems = allProducts.where((p) => p.price > 500).toList();

                    if (highValueItems.isNotEmpty) {
                      displayList = highValueItems;
                    } else {
                      // Fallback: Shuffle and show random items if no expensive items found
                      displayList = List.from(allProducts)..shuffle();
                    }

                    // Take max 6 items
                    final finalBestsellers = displayList.take(6).toList();

                    if (finalBestsellers.isEmpty) {
                      return const Text("No products available.");
                    }

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.6, // Keeps buttons readable
                      ),
                      itemCount: finalBestsellers.length,
                      itemBuilder: (context, index) {
                        // This Card now handles the "Click -> Open Details" logic internally
                        return ProductCardOnline(product: finalBestsellers[index]);
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))
          ]
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search 'dog food' or 'grooming'...",
          hintStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget _buildOfferCarousel() {
    return AspectRatio(
      aspectRatio: 2 / 1,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: PageView.builder(
          controller: _pageController,
          itemCount: _offerImages.length,
          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
            });
          },
          itemBuilder: (context, index) {
            return Image.network(
              _offerImages[index],
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey[200]),
            );
          },
        ),
      ),
    );
  }

  Widget _buildServicesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Services near you', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/app/services'),
              child: const Text('SEE ALL', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: mockServices.length,
            itemBuilder: (context, index) {
              return ServiceCard(service: mockServices[index]);
            },
          ),
        ),
      ],
    );
  }
}

class ServiceCard extends StatelessWidget {
  final ServiceData service;
  const ServiceCard({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final Map<String, String> iconMap = {
      'VideoIcon': 'assets/icons/video.svg',
      'PawPrintIcon': 'assets/icons/paw_print.svg',
      'UserIcon': 'assets/icons/user.svg',
      'HomeIcon': 'assets/icons/home.svg',
    };
    final iconPath = iconMap[service.icon] ?? 'assets/icons/paw_print.svg';

    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 16, bottom: 4, top: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2)
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(iconPath, width: 24, height: 24, colorFilter: ColorFilter.mode(Colors.blue[600]!, BlendMode.srcIn)),
          ),
          Column(
            children: [
              Text(service.name, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 4),
              Text(service.duration, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
            ],
          ),
          SizedBox(
            width: double.infinity,
            height: 32,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                backgroundColor: Colors.blue[600],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text('Book ₹${service.price.toInt()}', style: const TextStyle(fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }
}