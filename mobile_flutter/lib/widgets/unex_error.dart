import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_flutter/utils/navigations.dart';
import 'package:mobile_flutter/utils/colors.dart';

class UnexError extends StatelessWidget {
  final Widget retryPage;

  const UnexError({super.key, required this.retryPage});

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
              width: 100.w,
              height: 100.h,
              colorFilter:
                  const ColorFilter.mode(AlysColors.alysBlue, BlendMode.srcIn),
            ),
            SizedBox(height: 20.h),
            Text(
              'Sorry !',
              style: TextStyle(
                fontSize: 30.sp,
                fontWeight: FontWeight.bold,
                color: AlysColors.alysBlue,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              'An unexpected error occurred. \nPlease try again or contact the admin.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.sp, color: AlysColors.alysBlue),
            ),
            SizedBox(height: 30.h),
            ElevatedButton(
              onPressed: () {
                navigateTo(context, retryPage, AxisDirection.down);
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 12.h),
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
