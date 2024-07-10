import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_flutter/pages/home_page.dart';
import 'package:mobile_flutter/pages/login_page.dart';
import 'package:mobile_flutter/utils/check_connectivity.dart';
import 'package:mobile_flutter/widgets/snackbar.dart';
import '../utils/navigations.dart';
import '../utils/colors.dart';
import '../database/auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    _navigateAfterDelay();
  }

  Future<void> _navigateAfterDelay() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) {
      return;
    }
    bool isConnected = (await handleConnectivity());
    if (!mounted) {
      return;
    }
    if (!isConnected) {
      snackBar(context, 'Please check your internet connection and try again.',
          isError: true);
      navigateTo(context, const LoginPage(), AxisDirection.right);
    } else if (checkSession(context)) {
      navigateTo(context, const HomePage(), AxisDirection.right);
    } else {
      navigateTo(context, const LoginPage(), AxisDirection.right);
    }
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
