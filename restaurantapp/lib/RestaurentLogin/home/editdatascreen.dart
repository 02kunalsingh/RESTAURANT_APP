// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditDataScreen extends StatefulWidget {
  final String imageUrl;
  final String itemName;
  final String itemDescription;
  final double itemPrice;
  final String itemDelivery;
  final double itemRating;
  final String itemDistance;
  final String selectedDatabase;
  final String documentId;

  const EditDataScreen({
    super.key,
    required this.imageUrl,
    required this.itemName,
    required this.itemDescription,
    required this.itemPrice,
    required this.itemDelivery,
    required this.itemRating,
    required this.itemDistance,
    required this.selectedDatabase,
    required this.documentId,
  });

  @override
  State<EditDataScreen> createState() => _EditDataScreenState();
}

class _EditDataScreenState extends State<EditDataScreen> {
  File? _selectedImage;
  String? _imageUrl;
  final ImagePicker _picker = ImagePicker();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _deliveryController;
  late TextEditingController _ratingController;
  late TextEditingController _distanceController;

  Future<void> _updateDataInFirebase() async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection(widget.selectedDatabase)
          .doc(widget.documentId);
      final Map<String, dynamic> newData = {
        'name': _nameController.text,
        'description': _descriptionController.text,
        'price': double.parse(_priceController.text),
        'delivery': _deliveryController.text,
        'rating': double.parse(_ratingController.text),
        'distance': _distanceController.text,
      };
      await docRef.update(newData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data updated successfully!'),
        ),
      );
    } catch (e) {
      print('Error updating data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update data. Please try again later.'),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _imageUrl = widget.imageUrl;
    _nameController = TextEditingController(text: widget.itemName);
    _descriptionController =
        TextEditingController(text: widget.itemDescription);
    _priceController = TextEditingController(text: widget.itemPrice.toString());
    _deliveryController =
        TextEditingController(text: widget.itemDelivery.toString());
    _ratingController =
        TextEditingController(text: widget.itemRating.toString());
    _distanceController = TextEditingController(text: widget.itemDistance);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _deliveryController.dispose();
    _ratingController.dispose();
    _distanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        title: const Text('Edit Data'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                height: 150,
                width: 330,
                decoration: BoxDecoration(
                    border: Border.all(
                  color: Colors.red,
                )),
                child: _imageUrl != null
                    ? Image.network(
                        _imageUrl!,
                        fit: BoxFit.cover,
                      )
                    : const Center(child: Text("Select Image"))),
            const SizedBox(
              height: 5,
            ),
            InkWell(
              onTap: () {
                showModalBottomSheet(
                  backgroundColor: Colors.redAccent,
                  context: context,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  builder: (context) => SizedBox(
                    height: 200,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: InkWell(
                            onTap: () {
                              _pickImageFromGallery();
                            },
                            child: Container(
                              height: 70,
                              width: 310,
                              decoration: BoxDecoration(
                                  color: Colors.white54,
                                  borderRadius: BorderRadius.circular(18)),
                              child: const Row(
                                children: [
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Icon(Icons.folder_copy_rounded),
                                  SizedBox(
                                    width: 40,
                                  ),
                                  Text(
                                    "Select From Gallery",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: InkWell(
                            onTap: () {
                              _pickimagefromcamera();
                            },
                            child: Container(
                              height: 70,
                              width: 310,
                              decoration: BoxDecoration(
                                  color: Colors.white54,
                                  borderRadius: BorderRadius.circular(18)),
                              child: const Row(
                                children: [
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Icon(Icons.camera_alt),
                                  SizedBox(
                                    width: 40,
                                  ),
                                  Text(
                                    "Select From Camera",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
              child: Center(
                child: Container(
                    height: 30,
                    width: 130,
                    decoration: const BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Select image"),
                        Icon(
                          Icons.image,
                          color: Colors.black,
                        )
                      ],
                    )),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: _deliveryController,
              decoration: const InputDecoration(labelText: 'Delivery'),
            ),
            TextFormField(
              controller: _ratingController,
              decoration: const InputDecoration(labelText: 'Rating'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: _distanceController,
              decoration: const InputDecoration(labelText: 'Distance'),
              // keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  backgroundColor: Colors.redAccent,
                ),
                onPressed: () {
                  _updateDataInFirebase();
                },
                child: const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImageFromGallery() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
      _uploadImageToFirebase();
    }
  }

  Future _pickimagefromcamera() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
      _uploadImageToFirebase();
    }
  }

  Future<void> _uploadImageToFirebase() async {
    if (_selectedImage != null) {
      try {
        final Reference storageReference = FirebaseStorage.instance
            .ref()
            .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');

        await storageReference.putFile(_selectedImage!);

        final String imageUrl = await storageReference.getDownloadURL();
        print('Uploaded image URL: $imageUrl'); // Add this line for debugging
        setState(() {
          _imageUrl = imageUrl;
        });
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
  }
}
