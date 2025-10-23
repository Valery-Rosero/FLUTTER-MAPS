import 'dart:math';

class ParkingSpot {
  final int id;
  final String name;
  final String? address;
  final double latitude;
  final double longitude;
  final bool available;
  final double? pricePerHour;
  final int totalSpaces;
  final int availableSpaces;
  double? distance;
  final double? rating;

  ParkingSpot({
    required this.id,
    required this.name,
    this.address,
    required this.latitude,
    required this.longitude,
    required this.available,
    this.pricePerHour,
    required this.totalSpaces,
    required this.availableSpaces,
    this.distance,
    this.rating,
  });

  double calculateDistance(double userLat, double userLng) {
    const double earthRadius = 6371; // km
    double dLat = _toRadians(latitude - userLat);
    double dLng = _toRadians(longitude - userLng);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(userLat)) *
            cos(_toRadians(latitude)) *
            sin(dLng / 2) *
            sin(dLng / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  double _toRadians(double degree) => degree * pi / 180;

  factory ParkingSpot.fromMap(Map<String, dynamic> map) {
    return ParkingSpot(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      address: map['address'],
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      available: map['available'] ?? true,
      pricePerHour: map['price_per_hour'] != null
          ? (map['price_per_hour'] as num).toDouble()
          : null,
      totalSpaces: map['total_spaces'] ?? 0,
      availableSpaces: map['available_spaces'] ?? 0,
      rating: map['rating'] != null ? (map['rating'] as num).toDouble() : null,
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
        'available': available,
        'price_per_hour': pricePerHour,
        'total_spaces': totalSpaces,
        'available_spaces': availableSpaces,
        'rating': rating,
      };
}
