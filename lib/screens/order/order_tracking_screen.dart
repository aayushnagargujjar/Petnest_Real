
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';
import 'dart:math';

class OrderTrackingScreen extends StatefulWidget {
  const OrderTrackingScreen({super.key});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> with SingleTickerProviderStateMixin {
  int _step = 0;
  late Timer _timer;
  late Timer _etaTimer;
  String? _orderId;
  int _eta = 25;

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _orderId = ModalRoute.of(context)?.settings.arguments as String? ?? 'PN12345';
  }

  @override
  void initState() {
    super.initState();
    // Simulate order progress steps
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_step < 3) {
        setState(() => _step++);
      } else {
        _timer.cancel();
      }
    });

    // Simulate ETA Countdown
    _etaTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (_eta > 0) setState(() => _eta--);
    });

    // Animation for Bike
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
  }

  @override
  void dispose() {
    _timer.cancel();
    _etaTimer.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tracking Order', style: TextStyle(fontSize: 18, color: Colors.black)),
            if (_orderId != null) Text('ID: #$_orderId', style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.popUntil(context, ModalRoute.withName('/app')),
        ),
      ),
      body: Column(
        children: [
          // Map Visual Area
          SizedBox(
            height: 250,
            width: double.infinity,
            child: Stack(
              children: [
                 Image.network('https://placehold.co/400x260/EBF5FF/747474?text=Map+View', fit: BoxFit.cover, width: double.infinity, height: double.infinity),
                 // Custom Painter for Path
                 Positioned.fill(
                   child: CustomPaint(
                     painter: PathPainter(),
                   ),
                 ),
                 // Animated Bike
                 if (_step >= 2)
                 AnimatedBuilder(
                   animation: _animation,
                   builder: (context, child) {
                     return Positioned(
                       top: 20 + (sin(_animation.value * pi) * 20), // Simple curve simulation
                       left: 20 + (_animation.value * (MediaQuery.of(context).size.width - 60)),
                       child: Container(
                         padding: const EdgeInsets.all(6),
                         decoration: const BoxDecoration(
                           color: Color(0xFF4F46E5), // Indigo 600
                           shape: BoxShape.circle,
                           boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))]
                         ),
                         child: SvgPicture.asset('assets/icons/bike.svg', width: 20, height: 20, colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
                       ),
                     );
                   },
                 ),
                 // Store Marker
                 Positioned(
                   top: 20,
                   left: 20,
                   child: _buildMapMarker(Icons.store, Colors.red, 'PetNest Store'),
                 ),
                 // Home Marker
                 Positioned(
                   bottom: 40,
                   right: 20,
                   child: _buildMapMarker(Icons.home, Colors.green, 'Your Home'),
                 )
              ],
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  _buildAgentCard(),
                  const SizedBox(height: 24),
                  _buildStatusStep('Order Placed', 'We received your order', 0),
                  _buildStatusStep('Confirmed', 'Store has confirmed', 1),
                  _buildStatusStep('Out for Delivery', 'Agent is on the way', 2),
                  _buildStatusStep('Arriving Soon', 'Agent is nearby', 3),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapMarker(IconData icon, Color color, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(blurRadius: 5, color: Colors.black12)]),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, backgroundColor: Colors.white)),
      ],
    );
  }

  Widget _buildAgentCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(16), 
        boxShadow: [const BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Arriving in', style: TextStyle(color: Colors.grey, fontSize: 12)),
              Text('$_eta Mins', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.blue)),
            ],
          ),
          Row(
            children: [
              const CircleAvatar(radius: 20, backgroundImage: NetworkImage('https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100')),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Ravi Kumar', style: TextStyle(fontWeight: FontWeight.bold)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(4)),
                    child: Row(
                      children: [
                        Icon(Icons.call, size: 12, color: Colors.green[700]),
                        const SizedBox(width: 4),
                        Text('Call', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.green[700])),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusStep(String title, String sub, int step) {
    final isActive = _step >= step;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isActive ? Colors.green : Colors.grey[200],
                shape: BoxShape.circle,
                border: Border.all(color: isActive ? Colors.green : Colors.grey[300]!)
              ),
              child: isActive ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
            ),
            if (step < 3) Container(width: 2, height: 40, color: _step > step ? Colors.green : Colors.grey[300]),
          ],
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: isActive ? Colors.black : Colors.grey)),
            Text(sub, style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 24), // Spacer for timeline height
          ],
        ),
      ],
    );
  }
}

class PathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Simple quadratic bezier curve simulation based on React SVG path roughly
    final paint = Paint()
      ..color = const Color(0xFF4F46E5).withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    
    // Dash effect logic omitted for brevity, solid line for prototype
    final path = Path();
    path.moveTo(30, 30);
    path.quadraticBezierTo(size.width * 0.5, 30, size.width * 0.5, 60);
    path.lineTo(size.width - 30, 60); // Simplified path

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
