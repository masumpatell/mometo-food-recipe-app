import 'package:flutter/material.dart';

import 'homepage.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 4),(){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Homepage()),
      );
    });
    return Scaffold(
      body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
            Color(0xff213A50),
            Color(0xff071938),
          ])),
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(
                image: AssetImage("assest/images/2.png"),
                width: 150,
              ),
              const Text(
                "MOMETO",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 70),
              ),
              Container(
                alignment: Alignment.center,
                width: 300,
                // color: Colors.green,
                child: const Text(
                  "Fry up delicious happiness now!",
                  style: TextStyle(color: Colors.white,fontSize: 20),
                ),
              )
            ],
          )),
    );
  }
}
