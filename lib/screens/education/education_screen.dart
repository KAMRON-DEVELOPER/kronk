import 'package:flutter/material.dart';

import '../../widgets/drawer_widget.dart';

class EducationScreen extends StatefulWidget {
  const EducationScreen({super.key});

  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> {
  late int screenWidth;
  late int screenHeight;
  TextEditingController todoTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // int screenWidth = constraints.maxWidth.floor();
        // int screenHeight = constraints.maxHeight.floor();
        return buildDrawerWidget(
          context: context,
          appBarTitle: 'Study',
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //! todo add
              Container(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 60),
                child: Column(
                  children: [
                    TextField(
                      controller: todoTextController,
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 0.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 0.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Text('add todo'),
              const SizedBox(height: 32),

              Container(width: 200, height: 20, color: Colors.yellow),

              Container(width: 200, height: 20, color: Colors.yellow),
            ],
          ),
        );
      },
    );
  }
}
