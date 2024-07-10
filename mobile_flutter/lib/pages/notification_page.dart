import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_flutter/utils/check_connectivity.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:mobile_flutter/utils/colors.dart';
import 'package:mobile_flutter/widgets/no_wifi.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool isConnected = false;
  int _selectedIndex = 0;

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

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AlysColors.black,
        title: Text(
          'Notifications',
          style: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.w600,
            color: AlysColors.alysBlue,
          ),
        ),
        leading: IconButton(
          icon: Icon(CupertinoIcons.left_chevron, size: 25.sp),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () => Navigator.pop(context),
          color: AlysColors.alysBlue,
        ),
        actions: [
          IconButton(
            icon: Icon(
              CupertinoIcons.ellipsis_vertical,
              size: 25.sp,
            ),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () {
              // Placeholder for future functionality
            },
            color: AlysColors.alysBlue,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0.h),
          child: Container(
            color: AlysColors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTabButton('All', 0),
                _buildTabButton('Unread', 1),
                _buildTabButton('Read', 2),
              ],
            ),
          ),
        ),
      ),
      body: isConnected
          ? Container(
              color: AlysColors.black,
              child: const NoNotificationContent(),
            )
          : const NoWifiWidget(retryPage: NotificationPage()),
    );
  }

  Widget _buildTabButton(String label, int index) {
    final bool isSelected = _selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => _onTabTapped(index),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16.0.h),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? AlysColors.kingYellow : Colors.transparent,
                width: 2.0.h,
              ),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? AlysColors.kingYellow : AlysColors.alysBlue,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NoNotificationContent extends StatelessWidget {
  const NoNotificationContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              Icon(
                CupertinoIcons.bell_slash,
                size: 100.sp,
                color: AlysColors.alysBlue,
              ),
              Positioned(
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(14.w),
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '0',
                    style: TextStyle(
                      color: Colors.transparent,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Text(
            'No Notification to show',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AlysColors.alysBlue,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            'The notification feature is not available yet, I will notify you when something new happens!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              color: AlysColors.alysBlue,
            ),
          ),
          SizedBox(height: 80.h),
        ],
      ),
    );
  }
}
