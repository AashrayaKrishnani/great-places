import 'dart:io';

import 'package:flutter/material.dart';
import 'package:great_places/helpers/db_helper.dart';

import '../models/place.dart';

class PlacesProvider with ChangeNotifier {
  List<Place> _places = [];
  static const String _tableName = 'places';

  List<Place> get places {
    // Returns a copy of the main list and not a pointer to the original list!!
    return [..._places];
  }

  Future<void> addPlace(Place place) async {
    _places.add(place);
    await DBHelper.insert(_tableName, {
      'id': place.id,
      'title': place.title,
      'image': place.image.path,
      'dateTime': place.dateTime.toIso8601String()
    });
    notifyListeners();
  }

  Future<void> loadPlaces() async {
    final data = await DBHelper.getData(_tableName);

    Place p;
    for (var e in data) {
      p = Place(
        id: e['id'],
        title: e['title'],
        dateTime: DateTime.parse(e['dateTime']),
        image: File(e['image']),
        location: PlaceLocation(latitude: 0, longitude: 0),
      );
      if (!_places.any((element) => element.id == p.id)) _places.add(p);
    }

    notifyListeners();
  }
}
