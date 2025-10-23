import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_application_1/data/repositories/parking_repository.dart';
import 'package:flutter_application_1/domain/models/parking_spot.dart';
import 'package:flutter_application_1/presentation/widgets/parking_marker.dart';
import 'package:flutter_application_1/presentation/widgets/parking_info_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final MapController _mapController = MapController();
  final ParkingRepository _parkingRepository = ParkingRepository();

  List<ParkingSpot> _parkingSpots = [];
  List<ParkingSpot> _filteredSpots = [];
  LatLng? _userLocation;
  bool _isLoading = true;
  bool _locationLoading = false;

  @override
  void initState() {
    super.initState();
    _loadParkingSpots();
  }

  Future<void> _loadParkingSpots() async {
    try {
      final spots = await _parkingRepository.getAllParkingSpots();
      setState(() {
        _parkingSpots = spots;
        _filteredSpots = spots;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error al cargar: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _getUserLocation() async {
    setState(() => _locationLoading = true);

    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permiso de ubicación denegado.')),
        );
        return;
      }

      final position = await Geolocator.getCurrentPosition();
      final userLatLng = LatLng(position.latitude, position.longitude);

      setState(() => _userLocation = userLatLng);
      _mapController.move(userLatLng, 15.0);
    } catch (e) {
      debugPrint('Error obteniendo ubicación: $e');
    } finally {
      setState(() => _locationLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ParkingEase 🚗')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _parkingSpots.isNotEmpty
                    ? LatLng(
                        _parkingSpots.first.latitude,
                        _parkingSpots.first.longitude,
                      )
                    : const LatLng(1.2136, -77.2811),
                initialZoom: 14.0,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.parkingease',
                ),
                MarkerLayer(
                  markers: [
                    if (_userLocation != null)
                      Marker(
                        point: _userLocation!,
                        width: 45,
                        height: 45,
                        child: const Icon(Icons.my_location,
                            color: Colors.blue, size: 30),
                      ),
                    ..._filteredSpots.map((spot) {
                      return Marker(
                        point: LatLng(spot.latitude, spot.longitude),
                        width: 45,
                        height: 45,
                        child: ParkingMarker(
                          spot: spot,
                          onTap: () => _showParkingInfo(spot),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getUserLocation,
        backgroundColor: Colors.blue,
        child: _locationLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Icon(Icons.my_location),
      ),
    );
  }

  void _showParkingInfo(ParkingSpot spot) {
    showModalBottomSheet(
      context: context,
      builder: (_) => ParkingInfoCard(spot: spot),
    );
  }
}
