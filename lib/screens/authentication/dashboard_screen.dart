
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:petnest/providers/user_provider.dart';
import 'package:petnest/data/mock_data.dart';
import 'package:petnest/models/misc.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final role = Provider.of<UserProvider>(context).role;

    if (role == UserRole.doctor) {
      return const _DoctorDashboard();
    } else if (role == UserRole.seller) {
      return const _SellerDashboard();
    }
    return const Center(child: Text("Invalid Role"));
  }
}

class _DoctorDashboard extends StatelessWidget {
  const _DoctorDashboard();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildStatCard('TODAY\'S PATIENTS', '12', Colors.blue[50]!, Colors.blue[800]!),
              const SizedBox(width: 16),
              _buildStatCard('EARNINGS', '₹12,500', Colors.green[50]!, Colors.green[800]!),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Upcoming Appointments', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: mockAppointments.length,
            separatorBuilder: (c, i) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final appt = mockAppointments[index];
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [const BoxShadow(color: Colors.black12, blurRadius: 2)]),
                child: Row(
                  children: [
                    CircleAvatar(backgroundColor: Colors.blue[100], child: Text(appt.petName[0], style: TextStyle(color: Colors.blue[800], fontWeight: FontWeight.bold))),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(text: TextSpan(style: const TextStyle(color: Colors.black), children: [
                            TextSpan(text: appt.petName, style: const TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: ' (${appt.ownerName})', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                          ])),
                          Text(appt.service, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(appt.time, style: const TextStyle(fontWeight: FontWeight.bold)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: appt.status == 'Confirmed' ? Colors.green[100] : Colors.amber[100],
                            borderRadius: BorderRadius.circular(8)
                          ),
                          child: Text(appt.status, style: TextStyle(fontSize: 10, color: appt.status == 'Confirmed' ? Colors.green[800] : Colors.amber[800], fontWeight: FontWeight.bold)),
                        )
                      ],
                    )
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color bg, Color text) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            Text(title, style: TextStyle(color: text, fontSize: 11, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(color: text, fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class _SellerDashboard extends StatelessWidget {
  const _SellerDashboard();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                Text('TOTAL REVENUE', style: TextStyle(color: Colors.blue[800], fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('₹85,240', style: TextStyle(color: Colors.blue[900], fontSize: 32, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildMiniStat('Active Orders', '8'),
              const SizedBox(width: 16),
              _buildMiniStat('Products', '45'),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Recent Orders', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: mockSellerOrders.length,
            separatorBuilder: (c, i) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final order = mockSellerOrders[index];
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [const BoxShadow(color: Colors.black12, blurRadius: 2)]),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${order.orderNumber} (${order.customerName})', style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text(order.items, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('₹${order.price.toInt()}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: order.status == 'New' ? Colors.blue[100] : Colors.purple[100],
                                borderRadius: BorderRadius.circular(8)
                              ),
                              child: Text(order.status, style: TextStyle(fontSize: 10, color: order.status == 'New' ? Colors.blue[800] : Colors.purple[800], fontWeight: FontWeight.bold)),
                            )
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: OutlinedButton(onPressed: (){}, child: const Text("Decline"))),
                        const SizedBox(width: 12),
                        Expanded(child: ElevatedButton(onPressed: (){}, child: const Text("Accept"))),
                      ],
                    )
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget _buildMiniStat(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [const BoxShadow(color: Colors.black12, blurRadius: 2)]),
        child: Column(
          children: [
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
