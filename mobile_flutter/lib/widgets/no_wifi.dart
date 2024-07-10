import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_flutter/utils/navigations.dart';
import 'package:mobile_flutter/utils/colors.dart';

class NoWifiWidget extends StatelessWidget {
  final Widget retryPage;

  const NoWifiWidget({super.key, required this.retryPage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AlysColors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(CupertinoIcons.wifi_slash,
                size: 100, color: AlysColors.alysBlue),
            const SizedBox(height: 20),
            const Text(
              'Oups !',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: AlysColors.alysBlue),
            ),
            const SizedBox(height: 10),
            const Text(
              'There is no Internet connection\nPlease check your internet connection',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: AlysColors.alysBlue),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                navigateTo(context, retryPage, AxisDirection.down);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    horizontal: 50.0, vertical: 15.0),
                backgroundColor: AlysColors.kingYellow,
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: const BorderSide(color: AlysColors.kingYellow),
                ),
              ),
              child: const Text(
                'Try Again',
                style: TextStyle(color: AlysColors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
