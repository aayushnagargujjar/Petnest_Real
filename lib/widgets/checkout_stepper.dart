
import 'package:flutter/material.dart';

class CheckoutStepper extends StatelessWidget {
  final int currentStep;

  const CheckoutStepper({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    const steps = ['Address', 'Order Summary', 'Payment'];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      color: Colors.white,
      child: Row(
        children: steps.asMap().entries.map((entry) {
          final index = entry.key;
          final stepNumber = index + 1;
          final isCompleted = stepNumber < currentStep;
          final isActive = stepNumber == currentStep;
          final isLast = index == steps.length - 1;

          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: isActive ? Colors.blue[600] : (isCompleted ? Colors.green[500] : Colors.grey[200]),
                          shape: BoxShape.circle,
                          border: Border.all(color: isActive ? Colors.blue[600]! : (isCompleted ? Colors.green[500]! : Colors.grey[300]!)),
                        ),
                        child: Center(
                          child: isCompleted
                              ? const Icon(Icons.check, size: 16, color: Colors.white)
                              : Text(
                                  '$stepNumber',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isActive ? Colors.white : Colors.grey[500],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        entry.value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10,
                          color: isActive ? Colors.blue[600] : Colors.grey[500],
                          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isLast)
                  Container(
                    height: 2,
                    width: 40,
                    margin: const EdgeInsets.only(bottom: 20), // Align with circle
                    color: isCompleted ? Colors.blue[600] : Colors.grey[200],
                  ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
