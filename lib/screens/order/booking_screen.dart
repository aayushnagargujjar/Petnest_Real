
import 'package:flutter/material.dart';
import 'package:petnest/models/doctor.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final List<String> _dates = ['Today', 'Tomorrow', 'Oct 24'];
  final List<String> _times = ['09:00 AM', '11:00 AM', '02:00 PM', '04:00 PM', '06:00 PM'];
  String _selectedDate = 'Today';
  String? _selectedTime;

  @override
  Widget build(BuildContext context) {
    final doctor = ModalRoute.of(context)!.settings.arguments as Doctor;

    return Scaffold(
      appBar: AppBar(title: const Text('Book Appointment')),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(doctor.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('Service: Clinic Visit', style: const TextStyle(color: Colors.grey)), 
                        // Note: Ideally pass service type too
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text('Select Date', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  Row(
                    children: _dates.map((date) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedDate = date),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: _selectedDate == date ? Colors.blue[600] : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: _selectedDate == date ? Colors.blue[600]! : Colors.grey[300]!),
                            ),
                            child: Text(
                              date,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _selectedDate == date ? Colors.white : Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )).toList(),
                  ),
                  const SizedBox(height: 24),
                  const Text('Select Time Slot', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 2.5,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: _times.length,
                    itemBuilder: (context, index) {
                      final time = _times[index];
                      final isSelected = _selectedTime == time;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedTime = time),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.blue[600] : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: isSelected ? Colors.blue[600]! : Colors.grey[300]!),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            time,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                      );
                    },
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
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedTime == null ? null : () {
                   Navigator.pushNamed(
                     context, 
                     '/app/order-summary', 
                     arguments: {
                       'item': {
                         'name': 'Appointment with ${doctor.name}',
                         'price': doctor.clinicPrice, // Assuming clinic for now
                         'bookingDetails': 'on $_selectedDate at $_selectedTime',
                         'doctor': doctor
                       }, 
                       'type': 'service'
                     }
                   );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber[400],
                  foregroundColor: Colors.black,
                  disabledBackgroundColor: Colors.grey[300],
                ),
                child: const Text('Confirm & Proceed'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
