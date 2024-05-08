import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:restaurantapp/RestaurentLogin/home/home.dart';
import 'package:restaurantapp/RestaurentLogin/login/loginscreen.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  void isLogin(BuildContext context) {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        Timer(
          const Duration(seconds: 3),
          () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const Rhome()),
          ),
        );
      } else {
        Timer(
          const Duration(seconds: 3),
          () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const RestaurantLogin()),
          ),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    isLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Colors.red,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage("assets/logo/black-trans.png"),
              width: 300,
            ),
            SizedBox(
              height: mediaQuery.size.height * 0.1,
            ),
            const SpinKitSpinningLines(
              color: Colors.black,
              size: 50,
              duration: Duration(seconds: 3),
            )
          ],
        ),
      ),
    );
  }
}
