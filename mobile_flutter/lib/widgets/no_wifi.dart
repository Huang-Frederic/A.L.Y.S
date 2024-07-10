import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
            Icon(CupertinoIcons.wifi_slash,
                size: 100.sp, color: AlysColors.alysBlue),
            SizedBox(height: 20.h),
            Text(
              'Oups !',
              style: TextStyle(
                fontSize: 30.sp,
                fontWeight: FontWeight.bold,
                color: AlysColors.alysBlue,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              'There is no Internet connection\nPlease check your internet connection',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.sp, color: AlysColors.alysBlue),
            ),
            SizedBox(height: 30.h),
            ElevatedButton(
              onPressed: () {
                navigateTo(context, retryPage, AxisDirection.down);
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 15.h),
                backgroundColor: AlysColors.kingYellow,
                textStyle: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.r),
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
