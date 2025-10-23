import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/models/parking_spot.dart';

class ParkingMarker extends StatelessWidget {
  final ParkingSpot spot;
  final VoidCallback onTap;

  const ParkingMarker({
    super.key,
    required this.spot,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: spot.available ? Colors.green : Colors.red,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: const Icon(
          Icons.local_parking,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}
