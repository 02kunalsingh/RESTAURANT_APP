// ignore_for_file: avoid_print, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:restaurantapp/RestaurentLogin/home/home.dart';

class RestaurantLogin extends StatefulWidget {
  const RestaurantLogin({Key? key}) : super(key: key);

  @override
  State<RestaurantLogin> createState() => _RestaurantLoginState();
}

class _RestaurantLoginState extends State<RestaurantLogin> {
  bool isloading = false;
  final GlobalKey<FormState> formskey = GlobalKey();
  final usernamecontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(50),
                      bottomLeft: Radius.circular(50),
                    ),
                  ),
                  child: ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Colors.black87, Colors.black54],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomCenter,
                    ).createShader(bounds),
                    blendMode: BlendMode.darken,
                    child: Lottie.asset(
                      "assets/login/restaurantlogin.json",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: Center(
                    child: Text(
                      "Restaurant Login",
                      style: TextStyle(
                          fontSize: 28,
                          color: Colors.white30,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 210, left: 20),
                  child: Form(
                    key: formskey,
                    child: Container(
                      height: 350,
                      width: 320,
                      decoration: const BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          const Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                              right: 20,
                              top: 30,
                            ),
                            child: TextFormField(
                              controller: usernamecontroller,
                              style: const TextStyle(color: Colors.white),
                              validator: (username) {
                                if (username == null || username.isEmpty) {
                                  return "Enter Username";
                                }
                                return null;
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              cursorColor: Colors.red,
                              decoration: const InputDecoration(
                                label: Text(
                                  "Username",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                labelStyle: TextStyle(color: Colors.white),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                ),
                              ),
                              onTapOutside: (event) =>
                                  FocusManager.instance.primaryFocus!.unfocus(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                              right: 20,
                              top: 20,
                            ),
                            child: TextFormField(
                              style: const TextStyle(color: Colors.white),
                              validator: (password) {
                                if (password == null || password.isEmpty) {
                                  return "Enter password";
                                }
                                return null;
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: passwordcontroller,
                              cursorColor: Colors.red,
                              obscureText: true,
                              decoration: const InputDecoration(
                                label: Text(
                                  "Password",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                labelStyle: TextStyle(color: Colors.white),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                ),
                              ),
                              onTapOutside: (event) =>
                                  FocusManager.instance.primaryFocus!.unfocus(),
                            ),
                          ),
                          const SizedBox(height: 40),
                          SizedBox(
                            height: 41,
                            width: 150,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                ),
                                backgroundColor: Colors.redAccent,
                              ),
                              onPressed: () async {
                                if (formskey.currentState!.validate()) {
                                  setState(() {
                                    isloading = true;
                                  });
                                  try {
                                    await _auth.signInWithEmailAndPassword(
                                      email: usernamecontroller.text.trim(),
                                      password: passwordcontroller.text.trim(),
                                    );
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => const Rhome(),
                                      ),
                                    );
                                  } catch (e) {
                                    print("Error: $e");
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            "Login failed. Please try again."),
                                      ),
                                    );
                                  } finally {
                                    setState(() {
                                      isloading = false;
                                    });
                                  }
                                }
                              },
                              child: isloading
                                  ? const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("Wait .. ",
                                            style:
                                                TextStyle(color: Colors.white)),
                                        SizedBox(width: 10),
                                        CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 1),
                                      ],
                                    )
                                  : const Text(
                                      "Login",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
