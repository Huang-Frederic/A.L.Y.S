import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils/navigations.dart';
import '../utils/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLoginAfterDelay();
  }

  Future<void> _navigateToLoginAfterDelay() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) {
      return;
    }
    navigateToLogin(context, AxisDirection.right);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AlysColors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/logo.svg',
              width: 200,
              height: 200,
              colorFilter:
                  const ColorFilter.mode(AlysColors.alysBlue, BlendMode.srcIn),
            ),
            const Text(
              'ALYS',
              style: TextStyle(
                fontSize: 60,
                fontFamily: 'CrimsonPro',
                color: AlysColors.alysBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
