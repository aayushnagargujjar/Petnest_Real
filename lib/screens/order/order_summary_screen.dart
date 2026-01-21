
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:petnest/providers/cart_provider.dart';
import 'package:petnest/widgets/checkout_stepper.dart';

class OrderSummaryScreen extends StatelessWidget {
  const OrderSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Determine source: Cart or Single Item (Service/Pet)
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final cart = Provider.of<CartProvider>(context, listen: false);
    
    // Normalize data
    final bool isCart = args == null;
    final List<dynamic> items = isCart ? cart.items : [args!['item']];
    final String type = isCart ? 'cart' : args!['type'];
    
    // Calculate totals
    double itemTotal = 0;
    if (isCart) {
      itemTotal = cart.totalAmount;
    } else {
      dynamic item = items[0];
      if (item is Map) {
         itemTotal = item['price'].toDouble();
      } else {
         itemTotal = (type == 'pet_booking' && item.advancePrice != null) 
            ? item.advancePrice! 
            : item.price;
      }
    }

    final deliveryFee = isCart ? 29.0 : 0.0;
    final platformFee = 6.0;
    final grandTotal = itemTotal + deliveryFee + platformFee;

    final isService = type == 'service';
    final isPetBooking = type == 'pet_booking';

    return Scaffold(
      appBar: AppBar(title: Text(isCart ? 'Order Summary' : 'Booking Summary')),
      body: Column(
        children: [
          const CheckoutStepper(currentStep: 2),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                             Text(isPetBooking ? 'Pickup from:' : (isService ? 'Service Address' : 'Deliver to:'), style: const TextStyle(fontWeight: FontWeight.bold)),
                             TextButton(onPressed: () {}, child: const Text('Change')),
                          ],
                        ),
                        if (isPetBooking) ...[
                           Text(items[0].breederInfo?['name'] ?? 'Breeder', style: const TextStyle(fontSize: 14)),
                           Text(items[0].breederInfo?['location'] ?? '', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        ] else ...[
                           const Text('Rachit Kumar Padhan', style: TextStyle(fontSize: 14)),
                           const Text('Kendumundi Road, Northern Division', style: TextStyle(fontSize: 12, color: Colors.grey)),
                           const Text('Dhanbad, Jharkhand - 703832', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ]
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      children: [
                        ...items.map((item) => Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Image or Icon
                              if (isService) 
                                Container(
                                  width: 40, height: 40, 
                                  decoration: BoxDecoration(color: Colors.purple[100], borderRadius: BorderRadius.circular(8)),
                                  child: Center(child: Text(item['doctor'].initials, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.purple))),
                                )
                              else if (item is! Map)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(item.image, width: 40, height: 40, fit: BoxFit.cover)
                                ),
                              
                              const SizedBox(width: 12),
                              
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item is Map ? item['name'] : item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                    if(item is Map && item.containsKey('bookingDetails'))
                                      Text(item['bookingDetails'], style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                    if(item is! Map && item.weight != null)
                                      Text(item.weight!, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                  ],
                                ),
                              ),
                              Text('₹${(item is Map ? item['price'] : (type == 'pet_booking' ? item.advancePrice : item.price)).toInt()}'),
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      children: [
                        _summaryRow(type == 'pet_booking' ? 'Booking Advance' : 'Item Total', itemTotal),
                        if (deliveryFee > 0) _summaryRow('Delivery Fee', deliveryFee),
                        _summaryRow('Platform Fee', platformFee),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total Amount', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            Text('₹${grandTotal.toInt()}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
             decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.black12)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Total Payable', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      Text('₹${grandTotal.toInt()}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/app/payment', arguments: {'total': grandTotal, 'type': type}),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black),
                    child: const Text('Continue'),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _summaryRow(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text('₹${value.toInt()}', style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
