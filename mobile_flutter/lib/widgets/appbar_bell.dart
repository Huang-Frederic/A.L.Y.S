import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_flutter/pages/notification_page.dart';
import 'package:mobile_flutter/utils/navigations.dart';
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
      automaticallyImplyLeading: false,
      title: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.0.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 32.sp,
                fontWeight: FontWeight.w600,
                color: AlysColors.alysBlue,
              ),
            ),
            IconButton(
              icon: const Icon(
                CupertinoIcons.bell_fill,
                color: AlysColors.alysBlue,
              ),
              iconSize: 26.0.sp,
              onPressed: () {
                navigateTo(
                    context, const NotificationPage(), AxisDirection.right);
              },
            ),
          ],
        ),
      ),
      titleSpacing: 0,
    );
  }
}
