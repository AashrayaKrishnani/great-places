import 'package:flutter/material.dart';
import 'package:great_places/providers/places_provider.dart';
import 'package:great_places/screens/add_place_screen.dart';
import 'package:provider/provider.dart';

import 'screens/places_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const primarySwatchColor = Colors.indigo;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: PlacesProvider()),
      ],
      child: MaterialApp(
        title: 'Great Places',
        theme: ThemeData(
          primarySwatch: primarySwatchColor,
          colorScheme: ColorScheme.fromSwatch(
              primarySwatch: primarySwatchColor, accentColor: Colors.amber),
        ),
        home: const PlacesListScreen(),
        routes: {
          PlacesListScreen.route: (context) => const PlacesListScreen(),
          AddPlaceScreen.route: (context) => const AddPlaceScreen(),
        },
      ),
    );
  }
}
