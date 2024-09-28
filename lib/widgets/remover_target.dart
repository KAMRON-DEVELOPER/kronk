import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class RemoverTarget extends StatelessWidget {
  const RemoverTarget({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 60,
      left: 10,
      right: 10,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration:
            const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
        child: DragTarget<GestureDetector>(
          onAcceptWithDetails: (details) {
            print("DETAILS >> $details");
          },
          builder: (context, candidateData, rejectedData) {
            return const Icon(
              Iconsax.trash_bold,
              size: 36,
            );
          },
        ),
      ),
    );
  }
}
