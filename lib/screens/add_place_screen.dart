import 'dart:io';

import 'package:flutter/material.dart';
import 'package:great_places/models/place.dart';
import 'package:great_places/providers/places_provider.dart';
import 'package:great_places/widgets/loading_spinner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class AddPlaceScreen extends StatefulWidget {
  static const String route = '/add-place';

  const AddPlaceScreen({Key? key}) : super(key: key);

  @override
  _AddPlaceScreenState createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _form = GlobalKey<FormState>();
  bool isSubmitting = false;
  final _titleController = TextEditingController();
  File? _storedImage;

  void _submitForm() async {
    if (_storedImage == null) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 2),
          content: Text('Please Add An Image! 😊'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_form.currentState!.validate() && _storedImage != null) {
      if (!isSubmitting) {
        setState(() {
          isSubmitting = true;
        });
      }

      await storeImage();

      await Provider.of<PlacesProvider>(context, listen: false).addPlace(
        Place(
          id: DateTime.now().toString(),
          title: _titleController.text,
          location: PlaceLocation(latitude: 00, longitude: 00),
          image: _storedImage!,
          dateTime: DateTime.now(),
        ),
      );

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 2),
          content: Text('Place Added Succesfully! 🥳'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  Future<void> _inputImage(ImageSource srcType) async {
    // Won't need more than 1000 pixels ;D
    final tempImg =
        await ImagePicker().pickImage(source: srcType, maxWidth: 1000);

    setState(() {
      _storedImage = File(tempImg!.path);
    });
  }

  Future<void> storeImage() async {
    if (_storedImage != null) {
      final localDir = await syspaths.getApplicationDocumentsDirectory();
      final fileName = path.basename(_storedImage!.path);

      _storedImage =
          await _storedImage!.copy(path.join(localDir.path, fileName));
    }
  }

  Widget get imageInput {
    return Row(
      children: [
        Container(
          height: MediaQuery.of(context).size.width / 2.2,
          width: MediaQuery.of(context).size.width / 2.2,
          decoration: BoxDecoration(
            border: _storedImage == null
                ? null
                : Border.all(
                    color: Colors.grey,
                    width: 1,
                    style: BorderStyle.solid,
                  ),
          ),
          alignment: Alignment.center,
          child: _storedImage == null
              ? const Text(
                  'No Image Selected.',
                  textAlign: TextAlign.center,
                )
              : Image.file(_storedImage!, fit: BoxFit.cover),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextButton.icon(
                onPressed: () => _inputImage(ImageSource.camera),
                icon: const Icon(Icons.camera),
                label: const Text(
                  'Take Picture',
                  textAlign: TextAlign.center,
                ),
              ),
              TextButton.icon(
                onPressed: () => _inputImage(ImageSource.gallery),
                icon: const Icon(Icons.image),
                label: const Text('Choose Image', textAlign: TextAlign.center),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Place! 😍'),
      ),
      body: isSubmitting
          ? const LoadingSpinner(
              message: 'Protecting Memories! 💝',
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _form,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              decoration:
                                  const InputDecoration(label: Text('Title')),
                              keyboardType: TextInputType.name,
                              validator: (val) {
                                if (val == null ||
                                    val.toString().trim().isEmpty) {
                                  return 'Please Enter A Title';
                                } else if (val.toString().trim().length <= 2) {
                                  return 'Please make the Title atleast 3-characters long! :D';
                                }
                              },
                              controller: _titleController,
                              onFieldSubmitted: (_) =>
                                  _form.currentState!.validate(),
                              onSaved: (_) => _submitForm(),
                            ),
                          ),
                          const Divider(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: imageInput,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _submitForm,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Place'),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: const ContinuousRectangleBorder(),
                    primary: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
    );
  }
}
