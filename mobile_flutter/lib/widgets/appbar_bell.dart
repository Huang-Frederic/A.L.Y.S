import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/colors.dart';

class AppBarWithBell extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;
  final String title;

  const AppBarWithBell({super.key, required this.title})
      : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AlysColors.black,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: AlysColors.alysBlue,
              ),
            ),
            IconButton(
              icon: const Icon(
                CupertinoIcons.bell_fill,
                color: AlysColors.alysBlue,
              ),
              iconSize: 26.0,
              onPressed: () {
                // Handle notifications
              },
            ),
          ],
        ),
      ),
    );
  }
}
