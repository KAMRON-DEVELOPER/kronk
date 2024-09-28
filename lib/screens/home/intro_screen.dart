import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rive/rive.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen>
    with SingleTickerProviderStateMixin {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double contentHeight = MediaQuery.of(context).size.height;
    double contentWidth = MediaQuery.of(context).size.width * 0.86;
    double globalMargin = MediaQuery.of(context).size.width * 0.07;
    return Scaffold(
      backgroundColor: const Color(0xff020717),
      body: Stack(
        children: [
          const Positioned.fill(
            child: RiveAnimation.asset(
              "assets/animations/intro-blur.riv",
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Container(
              width: contentWidth,
              height: contentHeight,
              padding: EdgeInsets.only(
                top: globalMargin * 1.5,
                bottom: globalMargin,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //Todo language selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isOpen = !isOpen;
                          });
                        },
                        child: Container(
                          width: 120,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(screenWidth / 56),
                            color: const Color(0xff39942C),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SvgPicture.asset(
                                "assets/icons/circular_en.svg",
                                width: 24,
                                height: 24,
                              ),
                              const Text(
                                "English",
                                style: TextStyle(
                                  color: Color(0xff001000),
                                  fontSize: 16,
                                ),
                              ),
                              Icon(
                                !isOpen
                                    ? Icons.keyboard_arrow_down_rounded
                                    : Icons.keyboard_arrow_up_rounded,
                                color: const Color(0xff001000),
                                size: 24,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  //Todo center content
                  const Column(
                    children: [
                      Text(
                        "Welcome to",
                        style: TextStyle(
                          color: Color(0xff20FF00),
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          fontFamily: "roboto",
                          height: 0,
                        ),
                      ),
                      Text(
                        "Kronk!",
                        style: TextStyle(
                          color: Color(0xff20FF00),
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          height: 0,
                        ),
                      ),
                      Text(
                        "Are you ready for some magic?",
                        style: TextStyle(
                          color: Color(0xff20FF00),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  //Todo authentication buttons
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, '/home/register'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff39942C),
                            padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            ),
                          ),
                          child: const Text(
                            "Register",
                            style: TextStyle(color: Color(0xff000500)),
                          ),
                        ),
                      ),
                      SizedBox(height: globalMargin / 2),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, '/home/login'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff061404),
                            padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            ),
                          ),
                          child: const Text(
                            "Login",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
