import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_flutter/utils/colors.dart';

class AlysLoader extends StatefulWidget {
  const AlysLoader({super.key});

  @override
  State<AlysLoader> createState() => _AlysLoaderState();
}

class _AlysLoaderState extends State<AlysLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: false);

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ClipRect(
          child: Align(
            alignment: Alignment.topCenter,
            heightFactor: _animation.value,
            child: SvgPicture.asset(
              'assets/logo.svg',
              color: AlysColors.alysBlue,
              width: 100.w,
              height: 100.h,
            ),
          ),
        );
      },
    );
  }
}
