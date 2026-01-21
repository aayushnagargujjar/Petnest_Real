
import 'package:flutter/material.dart';
import 'package:petnest/widgets/checkout_stepper.dart';
import 'package:provider/provider.dart';
import 'package:petnest/providers/cart_provider.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedMethod = 'gpay';
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final total = args['total'] as double;
    final type = args['type'] as String;

    return Scaffold(
      appBar: AppBar(title: const Text('Payments')),
      body: Column(
        children: [
          const CheckoutStepper(currentStep: 3),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Amount', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text('₹${total.toInt()}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.blue)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildPaymentGroup('UPI', [
                    _buildRadioOption('gpay', 'Google Pay', image: 'assets/icons/gpay.png'),
                    _buildRadioOption('phonepe', 'PhonePe', image: 'assets/icons/phonepe.png'),
                  ]),
                  const SizedBox(height: 16),
                  _buildPaymentGroup('Cards', [
                    _buildRadioOption('card', 'Credit / Debit / ATM Card', icon: Icons.credit_card),
                  ]),
                  if (type == 'cart') ...[
                     const SizedBox(height: 16),
                     _buildPaymentGroup('Cash', [
                        _buildRadioOption('cod', 'Cash on Delivery', icon: Icons.money),
                     ]),
                  ]
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
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isProcessing ? null : () async {
                   setState(() => _isProcessing = true);
                   
                   // Simulate payment
                   await Future.delayed(const Duration(seconds: 2));
                   
                   if (mounted) {
                     if (type == 'cart') {
                       Provider.of<CartProvider>(context, listen: false).clearCart();
                       // Random Order ID
                       Navigator.pushReplacementNamed(context, '/app/tracking', arguments: 'PN${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}');
                     } else {
                       Navigator.popUntil(context, ModalRoute.withName('/app'));
                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Booking Confirmed!'), backgroundColor: Colors.green));
                     }
                   }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber[400], 
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isProcessing 
                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                  : Text(_selectedMethod == 'cod' ? 'Place Order' : 'Pay ₹${total.toInt()}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPaymentGroup(String title, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildRadioOption(String value, String label, {IconData? icon, String? image}) {
    return RadioListTile(
      value: value,
      groupValue: _selectedMethod,
      onChanged: (val) => setState(() => _selectedMethod = val.toString()),
      title: Row(
        children: [
          if (icon != null) ...[Icon(icon, size: 24, color: Colors.grey[700]), const SizedBox(width: 12)],
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
      activeColor: Colors.blue,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }
}
