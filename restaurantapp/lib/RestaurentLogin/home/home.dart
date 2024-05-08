import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurantapp/RestaurentLogin/login/loginscreen.dart';
import 'add_data.dart';
import 'update.dart';

class Rhome extends StatefulWidget {
  const Rhome({Key? key}) : super(key: key);

  @override
  State<Rhome> createState() => _RhomeState();
}

class _RhomeState extends State<Rhome> {
  final List<Tab> tabs = <Tab>[
    const Tab(text: 'ADD DATA'),
    const Tab(text: 'UPDATE DATA'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.grey[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      title: const Text('LOGOUT'),
                      content: const Text('Do you want to Logout ?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'NO',
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(logout());
                          },
                          child: const Text(
                            'YES',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.logout_outlined),
            )
          ],
          centerTitle: true,
          backgroundColor: Colors.redAccent,
          title: const Text(
            "Restaurant Partner",
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
          bottom: TabBar(
            tabs: tabs,
          ),
        ),
        body: const TabBarView(
          children: [
            AddDataScreen(),
            UpdateDataScreen(selectedDatabase: ""),
          ],
        ),
      ),
    );
  }

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const RestaurantLogin(),
      ));
    } catch (e) {
      print('Error logging out: $e');
    }
  }
}
