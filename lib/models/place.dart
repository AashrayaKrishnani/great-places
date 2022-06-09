import 'dart:io';

class Place {
  final String id;
  final String title;
  final PlaceLocation location;
  final File image;
  final DateTime dateTime;

  Place(
      {required this.id,
      required this.title,
      required this.location,
      required this.image,
      required this.dateTime});
}

class PlaceLocation {
  final double latitude;
  final double longitude;
  final String? address;

  PlaceLocation(
      {required this.latitude, required this.longitude, this.address});
}
