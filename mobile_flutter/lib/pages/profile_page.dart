import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_flutter/pages/login_page.dart';
import 'package:mobile_flutter/utils/check_connectivity.dart';
import 'package:mobile_flutter/utils/colors.dart';
import 'package:mobile_flutter/utils/navigations.dart';
import 'package:mobile_flutter/widgets/no_wifi.dart';
import '../widgets/appbar_bell.dart';
import '../database/auth.dart'; // Import the auth service

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
  }

  Future<void> _checkConnectivity() async {
    bool result = await handleConnectivity();
    setState(() {
      isConnected = result;
    });
  }

  Future<void> _logout() async {
    await authLogout(context);
    // Navigate to login page after logout
    navigateTo(context, const LoginPage(), AxisDirection.left);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWithBell(title: 'Profile'),
      body: !isConnected
          ? const NoWifiWidget(
              retryPage: ProfilePage(),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    'https://temp.compsci88.com/cover/Boku-No-Hero-Academia.jpg',
                    width: 300.w,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                  SizedBox(height: 20.h),
                  ElevatedButton(
                    onPressed: _logout,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: 50.w, vertical: 15.h),
                      backgroundColor: AlysColors.kingYellow,
                      textStyle: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                    ),
                    child: Text(
                      'Logout',
                      style: TextStyle(
                        color: AlysColors.black,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
