
import 'package:flutter/material.dart';
import 'package:petnest/models/product.dart';

class PetDetailScreen extends StatelessWidget {
  const PetDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pet = ModalRoute.of(context)!.settings.arguments as Product;
    final isBuy = pet.listingType == 'buy';
    final buttonLabel = isBuy ? 'Book Now' : 'Adopt Now';
    final price = isBuy ? pet.advancePrice : pet.price;
    final priceLabel = isBuy ? 'Booking Advance' : 'Adoption Fee';

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 350,
            child: Container(
              color: Colors.grey[200],
              child: pet.videoUrl != null 
                  ? Stack(
                      alignment: Alignment.center,
                      fit: StackFit.expand,
                      children: [
                        Image.network(pet.image, fit: BoxFit.cover),
                        Container(color: Colors.black26),
                        const Icon(Icons.play_circle_fill, color: Colors.white, size: 64),
                      ],
                    )
                  : Image.network(pet.image, fit: BoxFit.cover),
            ),
          ),
          
          // Back Button
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.8), shape: BoxShape.circle),
                child: const Icon(Icons.arrow_back, color: Colors.black),
              ),
            ),
          ),

          // Content Sheet
          DraggableScrollableSheet(
            initialChildSize: 0.60,
            minChildSize: 0.60,
            maxChildSize: 0.95,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2)],
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(pet.name, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                          ),
                          Text(
                            (price != null && price > 0) ? '₹${price.toInt()}' : 'FREE',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue[600]),
                          ),
                        ],
                      ),
                      Text(pet.breed ?? '', style: const TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          _buildChip(pet.gender ?? 'Unknown'),
                          const SizedBox(width: 8),
                          _buildChip(pet.age ?? 'Unknown'),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Text('About', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(pet.description ?? '', style: const TextStyle(color: Colors.grey, height: 1.5, fontSize: 14)),
                      const SizedBox(height: 24),
                      if (pet.breederInfo != null)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.blue[100]!),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(pet.breederInfo!['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                                  const SizedBox(width: 4),
                                  Expanded(child: Text(pet.breederInfo!['location']!, style: TextStyle(fontSize: 13, color: Colors.grey[700]))),
                                ],
                              ),
                              if (pet.verified == true)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text('VERIFIED BREEDER', style: TextStyle(color: Colors.cyan[800], fontWeight: FontWeight.bold, fontSize: 12)),
                                ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 100), // Bottom padding for fixed button
                    ],
                  ),
                ),
              );
            },
          ),
          
          // Bottom Action Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.black12)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(priceLabel, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        Text((price != null && price > 0) ? '₹${price.toInt()}' : 'FREE', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                         Navigator.pushNamed(
                           context, 
                           '/app/order-summary', 
                           arguments: {'item': pet, 'type': isBuy ? 'pet_booking' : 'pet'}
                         );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[600],
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(buttonLabel, style: const TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(24)),
      child: Text(label, style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }
}
