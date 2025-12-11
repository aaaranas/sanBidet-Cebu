import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/bidet_location.dart';

class MapPage extends StatefulWidget {
  final List<BidetLocation> bidets;
  const MapPage({super.key, required this.bidets});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  BitmapDescriptor? bidetIcon;
  late GoogleMapController mapController;

  @override
  void initState() {
    super.initState();
    _loadBidetIcon();
  }

  Future<void> _loadBidetIcon() async {
    final icon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/bidet_icon.png',
    );
    if (mounted) {
      setState(() {
        bidetIcon = icon;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (bidetIcon == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final markers = widget.bidets.map((b) {
      return Marker(
        markerId: MarkerId(b.name),
        position: LatLng(b.lat, b.lng),
        infoWindow: InfoWindow(
          title: b.name,
          snippet: b.imageBytes != null ? '📷 Tap to see image' : null,
          onTap: () {
            if (b.imageBytes != null) {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text(b.name),
                  content: Image.memory(
                    b.imageBytes!,
                    width: 250,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            }
          },
        ),
        icon: bidetIcon!,
      );
    }).toSet();

    return Scaffold(
      appBar: AppBar(title: const Text('San Bidet? Cebu - Map')),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(10.3157, 123.8854), // Cebu City
          zoom: 12,
        ),
        markers: markers,
        onMapCreated: (controller) {
          mapController = controller;
        },
      ),
    );
  }
}
