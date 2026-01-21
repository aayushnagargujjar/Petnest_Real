
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petnest/data/mock_data.dart';
import 'package:petnest/models/doctor.dart';
import 'package:petnest/models/service_data.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  String _activeSpecialty = 'All';
  final List<String> _specialties = [
    'All', 'General Surgeon', 'Dermatology', 'Nutritionist', 'Orthopedics', 'Cardiology', 'General Physician'
  ];

  @override
  Widget build(BuildContext context) {
    final filteredDoctors = mockDoctors
        .where((d) => _activeSpecialty == 'All' || d.specialty == _activeSpecialty)
        .toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Our Services', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
                Text('Everything your pet needs, in one place.', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.9,
              ),
              itemCount: mockServices.length,
              itemBuilder: (context, index) => _MainServiceCard(service: mockServices[index]),
            ),
          ),

          const SizedBox(height: 24),

          // SOS Banner
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Colors.red, Colors.orange]),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.red.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Medical Emergency?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        const Text('Connect with a vet in 2 mins', style: TextStyle(color: Colors.white70, fontSize: 12)),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.red[600],
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            minimumSize: Size.zero,
                          ),
                          icon: const Icon(Icons.emergency, size: 16),
                          label: const Text('SOS Call Now', style: TextStyle(fontSize: 12)),
                        ),
                      ],
                    ),
                  ),
                  SvgPicture.asset('assets/icons/paw_print.svg', width: 64, height: 64, colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.2), BlendMode.srcIn)),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Consult a Specialist', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Text('Find the right doctor for your pet\'s needs.', style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          
          const SizedBox(height: 12),

          // Sticky-like Specialty Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: _specialties.map((specialty) {
                final isActive = _activeSpecialty == specialty;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(specialty),
                    selected: isActive,
                    onSelected: (val) => setState(() => _activeSpecialty = specialty),
                    backgroundColor: Colors.white,
                    selectedColor: Colors.blue[600],
                    labelStyle: TextStyle(
                      color: isActive ? Colors.white : Colors.grey[700],
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    showCheckmark: false,
                    elevation: isActive ? 2 : 0,
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 16),

          // Doctor List
          filteredDoctors.isEmpty 
              ? const Padding(padding: EdgeInsets.all(32), child: Center(child: Text("No doctors found")))
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredDoctors.length,
                  itemBuilder: (context, index) {
                    return _DoctorCard(doctor: filteredDoctors[index]);
                  },
                ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _MainServiceCard extends StatelessWidget {
  final ServiceData service;
  const _MainServiceCard({required this.service});

  @override
  Widget build(BuildContext context) {
    final Map<String, String> iconMap = {
      'VideoIcon': 'assets/icons/video.svg',
      'PawPrintIcon': 'assets/icons/paw_print.svg',
      'UserIcon': 'assets/icons/user.svg',
      'HomeIcon': 'assets/icons/home.svg',
    };
    final iconPath = iconMap[service.icon] ?? 'assets/icons/paw_print.svg';

    return GestureDetector(
      onTap: () {
        if (service.id == 1) {
           // Scroll to doctors (simplified: just showing a message here)
           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Scroll down to book a vet!')));
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[100]!),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(50)),
              child: SvgPicture.asset(iconPath, width: 28, height: 28, colorFilter: ColorFilter.mode(Colors.blue[600]!, BlendMode.srcIn)),
            ),
            Column(
              children: [
                Text(service.name, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 2),
                Text(service.duration, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
            Text('from ₹${service.price.toInt()}', style: TextStyle(color: Colors.blue[600], fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class _DoctorCard extends StatelessWidget {
  final Doctor doctor;
  const _DoctorCard({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.purple[100],
                child: Text(doctor.initials, style: const TextStyle(color: Colors.purple, fontWeight: FontWeight.bold, fontSize: 18)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(doctor.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: Colors.amber[100], borderRadius: BorderRadius.circular(4)),
                          child: Text('⭐ ${doctor.rating}', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.amber[900])),
                        ),
                      ],
                    ),
                    Text(doctor.specialty, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                    Text('${doctor.experience} yrs exp • ${doctor.distance}km', style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pushNamed(context, '/app/booking', arguments: doctor),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blue[700],
                    side: BorderSide(color: Colors.blue[100]!),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Column(children: [const Text('CLINIC VISIT', style: TextStyle(fontSize: 10)), Text('₹${doctor.clinicPrice.toInt()}', style: const TextStyle(fontWeight: FontWeight.bold))]),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/app/booking', arguments: doctor),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Column(children: [const Text('VIDEO CALL', style: TextStyle(fontSize: 10)), Text('₹${doctor.videoCallPrice.toInt()}', style: const TextStyle(fontWeight: FontWeight.bold))]),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
