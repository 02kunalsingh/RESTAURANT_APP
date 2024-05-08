// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'editdatascreen.dart';

class UpdateDataScreen extends StatefulWidget {
  final String selectedDatabase;
  const UpdateDataScreen({super.key, required this.selectedDatabase});

  @override
  State<UpdateDataScreen> createState() => _UpdateDataScreenState();
}

class _UpdateDataScreenState extends State<UpdateDataScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _selectedDatabase = 'Scroll';
  List<Map<String, dynamic>> _dataList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> deleteData(String documentId) async {
    try {
      await _firestore.collection(_selectedDatabase).doc(documentId).delete();
      setState(() {
        _dataList.removeWhere((element) => element['id'] == documentId);
      });
    } catch (e) {
      print('Error deleting data: $e');
    }
  }

  Future<void> fetchData() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection(_selectedDatabase).get();
      setState(() {
        _dataList = querySnapshot.docs
            .map<Map<String, dynamic>>(
                (doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
            .toList();
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> updateData(int index) async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Select Database to update",
            style: TextStyle(fontSize: 18),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              value: _selectedDatabase,
              items: ['Scroll', 'Products'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedDatabase = newValue!;
                  fetchData();
                });
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _dataList.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 0.5),
                          borderRadius: BorderRadius.circular(
                              20), // Adjust the radius as needed
                        ),
                        child: ListTile(
                          title: Text(_dataList[index]['name']),
                          subtitle: Text(
                            _dataList[index]['description'],
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                          leading: SizedBox(
                            height: 50,
                            width: 80,
                            child: Image.network(
                              _dataList[index]['image'],
                              fit: BoxFit.cover,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        print(_dataList[index]);
                                        return EditDataScreen(
                                          documentId: _dataList[index]['id'],
                                          selectedDatabase: _selectedDatabase,
                                          imageUrl:
                                              _dataList[index]['image'] ?? '',
                                          itemName:
                                              _dataList[index]['name'] ?? '',
                                          itemDescription: _dataList[index]
                                                  ['description'] ??
                                              '',
                                          itemPrice: double.tryParse(
                                                  _dataList[index]['price']
                                                      .toString()) ??
                                              0.0,
                                          itemDelivery: _dataList[index]
                                                  ['delivery'] ??
                                              "",
                                          itemRating: double.tryParse(
                                                  _dataList[index]['rating']
                                                      .toString()) ??
                                              0.0,
                                          itemDistance: _dataList[index]
                                                  ['distance'] ??
                                              '',
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        backgroundColor: Colors.grey[300],
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        title: const Text('Delete Data'),
                                        content: const Text(
                                            'Are you sure you want to delete this data ?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text(
                                              'Cancel',
                                              style: TextStyle(
                                                  color: Colors.green),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              deleteData(
                                                  _dataList[index]['id']);
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text(
                                              'Delete',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10), //spacing btwn each Tile
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
