
import 'package:flutter/material.dart';
import 'package:petnest/data/mock_data.dart';
import 'package:petnest/models/product.dart';

class PetsScreen extends StatelessWidget {
  const PetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pets = mockProducts.where((p) => p.category == 'Pets').toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const Text('Find a new friend 🐾', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
                const Text('Your next companion is waiting for you.', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 20),
              ]),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _PetCard(pet: pets[index]),
                childCount: pets.length,
              ),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 20)),
        ],
      ),
    );
  }
}

class _PetCard extends StatelessWidget {
  final Product pet;
  const _PetCard({required this.pet});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/app/pet-detail', arguments: pet),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 4))],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(pet.image, height: 200, width: double.infinity, fit: BoxFit.cover),
                if (pet.verified == true)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: pet.listingType == 'buy' ? Colors.cyan[50] : Colors.green[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: pet.listingType == 'buy' ? Colors.cyan[200]! : Colors.green[200]!),
                      ),
                      child: Text(
                        pet.listingType == 'buy' ? 'VERIFIED BREEDER' : 'VERIFIED SHELTER',
                        style: TextStyle(
                          color: pet.listingType == 'buy' ? Colors.cyan[800] : Colors.green[800],
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(pet.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      Text(
                        pet.price > 0 ? '₹${pet.price.toInt()}' : 'FREE',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue[600]),
                      ),
                    ],
                  ),
                  Text(pet.breed ?? 'Unknown Breed', style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildChip(pet.gender ?? 'Unknown'),
                      const SizedBox(width: 8),
                      _buildChip(pet.age ?? 'Unknown'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pushNamed(context, '/app/pet-detail', arguments: pet),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[600],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('See Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: TextStyle(color: Colors.grey[800], fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }
}
