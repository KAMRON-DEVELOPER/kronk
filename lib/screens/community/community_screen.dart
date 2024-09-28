import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../widgets/appbar.dart';
import '../../widgets/navbar.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff353b4d),
      appBar: buildAppBar(context, "Home screen"),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('community body'),
            Icon(
              Iconsax.message,
              size: 64,
            ),
          ],
        ),
      ),
      bottomNavigationBar: const Navbar(),
    );
  }
}
