import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'home_screen.dart';
import 'package:geolocator/geolocator.dart';
// ...existing import...
class BookingCleaningScreen extends StatefulWidget {
  final Service service;
  const BookingCleaningScreen({super.key, required this.service});

  @override
  State<BookingCleaningScreen> createState() => _BookingCleaningScreenState();
}

class _BookingCleaningScreenState extends State<BookingCleaningScreen> {
  final TextEditingController locationController = TextEditingController();
  LatLng? _selectedPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

Future<void> _getCurrentLocation() async {
  print('Start get location');
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  print('Service enabled: $serviceEnabled');
  if (!serviceEnabled) {
    _showLocationError('กรุณาเปิด Location Service');
    return;
  }

  LocationPermission permission = await Geolocator.checkPermission();
  print('Permission: $permission');
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    print('Request permission: $permission');
    if (permission == LocationPermission.denied) {
      _showLocationError('ไม่ได้รับอนุญาตให้เข้าถึงตำแหน่ง');
      return;
    }
  }
  if (permission == LocationPermission.deniedForever) {
    _showLocationError('ไม่ได้รับอนุญาตให้เข้าถึงตำแหน่ง (ถาวร)');
    return;
  }

  try {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print('Position: $position');
    setState(() {
      _selectedPosition = LatLng(position.latitude, position.longitude);
      locationController.text =
          '${position.latitude.toStringAsFixed(5)}, ${position.longitude.toStringAsFixed(5)}';
    });
 } catch (e, stack) {
  print('Location error: $e');
  print('Stacktrace: $stack');
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Location error: $e')),
  );
}
}

void _showLocationError(String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('$message\nโปรดตรวจสอบการอนุญาต Location ใน Settings หรือเปลี่ยน browser'))
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.service.name,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'คุณต้องการใช้บริการที่ไหน?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: locationController,
              decoration: InputDecoration(
                labelText: 'ระบุสถานที่ (Location)',
                prefixIcon: const Icon(Icons.location_on),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              readOnly: true,
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 180,
              child: _selectedPosition == null
                  ? const Center(child: CircularProgressIndicator())
                  : FlutterMap(
                      options: MapOptions(
                        initialCenter: _selectedPosition!,
                        initialZoom: 14,
                        onTap: (tapPosition, point) {
                          setState(() {
                            _selectedPosition = point;
                            locationController.text =
                                '${point.latitude.toStringAsFixed(5)}, ${point.longitude.toStringAsFixed(5)}';
                          });
                        },
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                          subdomains: const ['a', 'b', 'c'],
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              width: 40,
                              height: 40,
                              point: _selectedPosition!,
                              child: const Icon(
                                Icons.location_on,
                                color: Colors.red,
                                size: 40,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}