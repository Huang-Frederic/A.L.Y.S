import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/colors.dart';

class AppBarWithFilter extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize = Size.fromHeight(150.0.h);
  final String title;
  final TextEditingController searchController;
  final Function openFilterModal;
  final int activeFilters;

  AppBarWithFilter({
    super.key,
    required this.title,
    required this.searchController,
    required this.openFilterModal,
    required this.activeFilters,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppBar(
          backgroundColor: AlysColors.black,
          automaticallyImplyLeading: false,
          toolbarHeight: 32.0.h,
          centerTitle: true,
          title: Text(
            title,
            style: TextStyle(
              fontSize: 26.sp,
              fontWeight: FontWeight.w600,
              color: AlysColors.alysBlue,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 24.0.w, vertical: 10.0.h),
          color: AlysColors.black,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by title',
                    hintStyle:
                        TextStyle(color: AlysColors.alysBlue.withOpacity(0.8)),
                    prefixIcon: Icon(CupertinoIcons.search,
                        color: AlysColors.alysBlue.withOpacity(0.8)),
                    filled: true,
                    fillColor: AlysColors.grey,
                    contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide:
                          const BorderSide(color: AlysColors.kingYellow),
                    ),
                  ),
                  style: const TextStyle(color: AlysColors.alysBlue),
                  cursorColor: AlysColors.kingYellow,
                ),
              ),
              SizedBox(width: 10.w),
              Stack(
                children: [
                  IconButton(
                    icon: Icon(
                      CupertinoIcons.slider_horizontal_3,
                      color: activeFilters > 0
                          ? AlysColors.kingYellow
                          : AlysColors.alysBlue.withOpacity(0.8),
                      size: 28,
                    ),
                    onPressed: () {
                      openFilterModal();
                    },
                  ),
                  if (activeFilters > 0)
                    Positioned(
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: const BoxDecoration(
                          color: AlysColors.kingYellow,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '$activeFilters',
                          style: TextStyle(
                            color: AlysColors.black,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
