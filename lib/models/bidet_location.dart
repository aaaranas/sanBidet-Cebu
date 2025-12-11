import 'dart:typed_data';

class BidetLocation {
  final String name;
  final double lat;
  final double lng;
  final Uint8List? imageBytes; // Web-friendly image storage

  BidetLocation({
    required this.name,
    required this.lat,
    required this.lng,
    this.imageBytes,
  });
}
