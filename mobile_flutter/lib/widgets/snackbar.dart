import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/colors.dart';

void snackBar(BuildContext context, String message, {bool isError = false}) {
  final icon = isError
      ? Icon(CupertinoIcons.clear_circled, color: Colors.red, size: 30.sp)
      : Icon(CupertinoIcons.checkmark_alt_circle,
          color: Colors.green, size: 30.sp);

  final overlay = Overlay.of(context);
  late OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) {
      return SnackBarOverlay(
        icon: icon,
        message: message,
        onDismissed: () => overlayEntry.remove(),
      );
    },
  );

  overlay.insert(overlayEntry);
}

class SnackBarOverlay extends StatefulWidget {
  final Icon icon;
  final String message;
  final VoidCallback onDismissed;

  const SnackBarOverlay({
    super.key,
    required this.icon,
    required this.message,
    required this.onDismissed,
  });

  @override
  State<SnackBarOverlay> createState() => _SnackBarOverlayState();
}

class _SnackBarOverlayState extends State<SnackBarOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();

    Future.delayed(const Duration(milliseconds: 1500), () async {
      if (mounted) {
        await _controller.reverse();
        widget.onDismissed();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 75.h,
      left: 30.w,
      right: 30.w,
      child: Material(
        color: Colors.transparent,
        child: FadeTransition(
          opacity: _animation,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: AlysColors.grey,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              children: [
                widget.icon,
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    widget.message,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
