import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fruits_app/screens/LoginScreen.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //color: Colors.blue,
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 50, right: 10),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Skip',
                      style: TextStyle(color: Colors.green, fontSize: 15),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      CupertinoIcons.arrow_right_circle_fill,
                      color: Colors.green,
                      size: 35,
                    ),
                  ],
                ),
              ),
            ),

            Container(
              child: Stack(
                children: [
                  Center(child: Image.asset('assets/dilevery_boy.png', height: 450, width: 400)),
                  Container(
                    margin: EdgeInsets.only(top: 400),
                    padding: EdgeInsets.only(top: 20),
                    height: 250,
                    width: 330,
                    child: Stack(
                      children: [
                        Container(
                          width: 250,
  
                        ),
                        Container(
                          width: 330,
                          margin: EdgeInsets.only(top: 20),
                          child: Column(
                            children: [
                              SizedBox(height: 10),
                              Text(
                                'Buy Groceries Easily',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                'With Us',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(height: 14),
                              Text(
                                'It is a long established fact that a reader',
                                style: TextStyle(fontSize: 11),
                              ),
                              Text(
                                'will be distracted by the readable.',
                                style: TextStyle(fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
