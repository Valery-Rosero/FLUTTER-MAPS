import 'package:flutter_application_1/core/config/supabase_config.dart';
import 'package:flutter_application_1/domain/models/parking_spot.dart';

class ParkingRepository {
  final _client = SupabaseConfig.client;

  Future<List<ParkingSpot>> getAllParkingSpots() async {
    try {
      // ✅ Ya no se usan parámetros genéricos en `.select()`
      final response = await _client.from('parking_spots').select();

      // El resultado es un List<dynamic>, así que lo convertimos
      final data = List<Map<String, dynamic>>.from(response);

      return data.map((map) => ParkingSpot.fromMap(map)).toList();
    } catch (e) {
      print('Error fetching parking spots: $e');
      throw Exception('Failed to load parking spots');
    }
  }

  Future<void> addParkingSpot(ParkingSpot spot) async {
    try {
      await _client.from('parking_spots').insert(spot.toMap());
    } catch (e) {
      print('Error adding parking spot: $e');
      throw Exception('Failed to add parking spot');
    }
  }

  Future<void> updateAvailability(int id, bool available, int availableSpaces) async {
    try {
      await _client.from('parking_spots').update({
        'available': available,
        'available_spaces': availableSpaces,
      }).eq('id', id);
    } catch (e) {
      print('Error updating parking spot: $e');
      throw Exception('Failed to update parking spot');
    }
  }
}
