import 'package:flutter/material.dart';
import '../../widgets/drawer_widget.dart';

class EntertainmentScreen extends StatelessWidget {
  const EntertainmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // int screenWidth = constraints.maxWidth.floor();
        // int screenHeight = constraints.maxHeight.floor();
        return buildDrawerWidget(
          context: context,
          appBarTitle: 'AI screen',
          body: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('SOME TEXT HERE'),
              ],
            ),
          ),
        );
      },
    );
  }
}
