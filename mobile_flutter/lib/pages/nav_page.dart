import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_flutter/pages/bookmark_page.dart';
import 'package:mobile_flutter/pages/home_page.dart';
import 'package:mobile_flutter/pages/profile_page.dart';
import 'package:mobile_flutter/pages/search_page.dart';
import '../utils/colors.dart';

class NavPage extends StatefulWidget {
  const NavPage({super.key});

  @override
  State<NavPage> createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  int _selectedIndex = 0;
  static const List<Widget> _pages = <Widget>[
    HomePage(),
    SearchPage(),
    BookmarkPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        height: 110.0.h, // Set your desired height here
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _buildNavItem(CupertinoIcons.globe, 0),
              _buildNavItem(CupertinoIcons.search, 1),
              _buildNavItem(CupertinoIcons.bookmark_fill, 2),
              _buildNavItem(CupertinoIcons.person_fill, 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final bool isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => _onItemTapped(index),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 5.h),
            Icon(
              icon,
              size: index == 2 ? 26.0.sp : 30.0.sp,
              color: isSelected ? AlysColors.kingYellow : AlysColors.alysBlue,
            ),
            Container(
              margin: EdgeInsets.only(top: 5.0.h),
              height: 4.0.h,
              width: 30.0.w,
              decoration: BoxDecoration(
                color: isSelected ? AlysColors.kingYellow : Colors.transparent,
                borderRadius: BorderRadius.circular(30.0.r),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
