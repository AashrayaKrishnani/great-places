import 'package:flutter/material.dart';
import 'package:great_places/providers/places_provider.dart';
import 'package:great_places/screens/add_place_screen.dart';
import 'package:great_places/widgets/loading_spinner.dart';
import 'package:great_places/widgets/sweat_smile_image.dart';
import 'package:provider/provider.dart';

class PlacesListScreen extends StatelessWidget {
  static const route = '/places';

  const PlacesListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Great Places! 🤩'),
        actions: [
          IconButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(AddPlaceScreen.route),
              icon: const Icon(Icons.add))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<PlacesProvider>(context, listen: false)
              .loadPlaces();

          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Refreshed Succesfully! 🥳'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 1),
          ));
        },
        child: FutureBuilder(
          future:
              Provider.of<PlacesProvider>(context, listen: false).loadPlaces(),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingSpinner(
                message: 'Remembering Wonderful Adventures! ✨',
              );
            }

            return Consumer<PlacesProvider>(
              builder: (context, value, child) {
                final places = value.places;

                if (places.isEmpty) {
                  return const SweatSmileImage(
                    text: 'Add A Place! 🥰',
                  );
                } else {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                    child: ListView.builder(
                        itemBuilder: (context, index) => Column(children: [
                              ListTile(
                                leading: CircleAvatar(
                                  radius:
                                      MediaQuery.of(context).size.width / 10,
                                  backgroundImage:
                                      FileImage(places[index].image),
                                ),
                                title: Text(
                                  places[index].title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      ?.copyWith(
                                          fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  10 -
                                              10),
                                ),
                                onTap: () {
                                  // Takes to Details Page
                                },
                              ),
                              const SizedBox(height: 20),
                            ]),
                        itemCount: places.length),
                  );
                }
              },
            );
          }),
        ),
      ),
    );
  }
}
