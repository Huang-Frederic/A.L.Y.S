import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_flutter/pages/bookmark_page.dart';
import 'package:mobile_flutter/pages/home_page.dart';
import 'package:mobile_flutter/pages/profile_page.dart';
import 'package:mobile_flutter/pages/search_page.dart';
import '../utils/colors.dart';
import '../utils/navigations.dart';

class NavBar extends StatelessWidget {
  final String selectedLabel;

  const NavBar({
    super.key,
    required this.selectedLabel,
  });

  void _onItemTapped(BuildContext context, String label) {
    switch (label) {
      case 'Home':
        navigateTo(context, const HomePage(), AxisDirection.down);
        break;
      case 'Search':
        navigateTo(context, const SearchPage(), AxisDirection.down);
        break;
      case 'Bookmark':
        navigateTo(context, const BookmarkPage(), AxisDirection.down);
        break;
      case 'Profile':
        navigateTo(context, const ProfilePage(), AxisDirection.down);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AlysColors.black,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 0,
            blurRadius: 10.r,
            offset: Offset(0, -3.h),
          ),
        ],
      ),
      child: BottomAppBar(
        color: Colors.transparent,
        height: 90.0.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildNavItem(context, 'Home', CupertinoIcons.globe),
            _buildNavItem(context, 'Search', CupertinoIcons.search),
            _buildNavItem(context, 'Bookmark', CupertinoIcons.bookmark_fill),
            _buildNavItem(context, 'Profile', CupertinoIcons.person_fill),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, String label, IconData icon) {
    final bool isSelected = selectedLabel == label;
    return InkWell(
      onTap: () => _onItemTapped(context, label),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              icon,
              size: label == "Bookmark" ? 26.0.sp : 30.0.sp,
              color: isSelected ? AlysColors.kingYellow : AlysColors.alysBlue,
            ),
            Container(
              margin: EdgeInsets.only(top: 5.0.h),
              height: 4.0.h,
              width: 30.0.w,
              decoration: BoxDecoration(
                color: isSelected
                    ? AlysColors.kingYellow
                    : AlysColors.kingYellow.withOpacity(0),
                borderRadius: BorderRadius.circular(30.0.r),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
