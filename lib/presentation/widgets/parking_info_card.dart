import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_application_1/domain/models/parking_spot.dart';

class ParkingInfoCard extends StatelessWidget {
  final ParkingSpot spot;
  final LatLng? userLocation;

  const ParkingInfoCard({super.key, required this.spot, this.userLocation});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle para arrastrar
          Center(
            child: Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Header con nombre y rating
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  spot.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (spot.rating != null)
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      spot.rating!.toStringAsFixed(1),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
            ],
          ),
          
          // Dirección
          if (spot.address != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    spot.address!,
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ),
              ],
            ),
          ],
          
          const SizedBox(height: 16),
          
          // Información de disponibilidad y precio
          Row(
            children: [
              // Disponibilidad
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: spot.available && spot.availableSpaces > 0 
                      ? Colors.green.withOpacity(0.2)
                      : Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      spot.available && spot.availableSpaces > 0 
                          ? Icons.check_circle 
                          : Icons.cancel,
                      color: spot.available && spot.availableSpaces > 0 
                          ? Colors.green 
                          : Colors.red,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      spot.available && spot.availableSpaces > 0
                          ? '${spot.availableSpaces} disponibles'
                          : 'Completo',
                      style: TextStyle(
                        color: spot.available && spot.availableSpaces > 0 
                            ? Colors.green 
                            : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
              const Spacer(),
              
              // Precio
              if (spot.pricePerHour != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '\$${spot.pricePerHour!.toStringAsFixed(2)}/hora',
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          
          // Distancia si hay ubicación del usuario
          if (userLocation != null && spot.distance != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.directions_walk, size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  '${spot.distance!.toStringAsFixed(1)} km de distancia',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ],
          
          // Capacidad total
          const SizedBox(height: 12),
          Text(
            'Capacidad total: ${spot.totalSpaces} espacios',
            style: const TextStyle(color: Colors.grey),
          ),
          
          // Botón de acción
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.directions),
              label: const Text('COMO LLEGAR'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                // Aquí integrarías con Google Maps o Waze
                _showDirectionsDialog(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showDirectionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cómo llegar'),
        content: const Text('Se abrirá la aplicación de mapas para guiarte hasta el parqueadero.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Aquí la integración con mapas
            },
            child: const Text('Abrir Mapas'),
          ),
        ],
      ),
    );
  }
}