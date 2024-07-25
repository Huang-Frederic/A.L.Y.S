import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_flutter/utils/colors.dart';
import 'dart:ui';

class BookPage extends StatefulWidget {
  final dynamic book;

  const BookPage({super.key, required this.book});

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final genresList = List<String>.from(widget.book['genres'] ?? []);
    final coverUrl = widget.book['cover_url'] ?? '';
    final title = widget.book['title'] ?? 'No Title';
    final release = widget.book['release'] ?? 'Unknown Year';
    final status = widget.book['status'] ?? 'Unknown Status';
    final authorsList = List<String>.from(widget.book['authors'] ?? []);
    final author = authorsList.isNotEmpty
        ? authorsList.length > 2
            ? '${authorsList[0]} ...'
            : authorsList[0]
        : 'Unknown Author';
    final synopsis = widget.book['description'] ?? 'No Synopsis Available';
    final String countryFlag;
    switch (widget.book['type']) {
      case 'Manga':
        countryFlag = '🇯🇵';
        break;
      case 'Manhwa':
        countryFlag = '🇰🇷';
        break;
      case 'Manhua':
        countryFlag = '🇨🇳';
        break;
      case 'OEL':
        countryFlag = '🇬🇧';
        break;
      default:
        countryFlag = '🏳';
    }

    return Scaffold(
      body: Stack(
        children: [
          // Background color for the entire page
          Container(
            color: AlysColors.black,
          ),
          // Top 200px background with cover image and blur effect
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 500.h,
            child: Container(
              decoration: BoxDecoration(
                image: coverUrl.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(coverUrl),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.3),
                          BlendMode.darken,
                        ),
                      )
                    : null,
                color: coverUrl.isEmpty ? Colors.black : null,
              ),
              child: Stack(
                children: [
                  BackdropFilter(
                    filter: ImageFilter.blur(
                        sigmaX: 2.5, sigmaY: 2.5), // Reduced blur
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 50.h, // Height of the fade effect
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.0),
                            Colors.black.withOpacity(0.5),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Black container with border radius
          Positioned(
            top: 235.h,
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              height: 500.h,
              decoration: BoxDecoration(
                color: AlysColors.black,
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),

          // Content of the page
          SingleChildScrollView(
            padding: EdgeInsets.only(top: 110.h),
            child: Container(
              padding:
                  EdgeInsets.symmetric(horizontal: 24.0.w, vertical: 16.0.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Cover image
                      if (coverUrl.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5.r),
                          child: Image.network(
                            coverUrl,
                            width: 135.0.w,
                            height: 200.h,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/placeholder_cover.png',
                                width: 135.0.w,
                                height: 200.h,
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                      if (coverUrl.isEmpty)
                        Image.asset(
                          'assets/placeholder_cover.png',
                          width: 135.0.w,
                          height: 200.h,
                          fit: BoxFit.cover,
                        ),
                      SizedBox(width: 16.w),
                      // Text content
                      Expanded(
                        child: Container(
                          height: 200.h, // Added height constraint
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment
                                .spaceBetween, // Added this line
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  title,
                                  style: TextStyle(
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AlysColors.alysBlue,
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        countryFlag,
                                        style: TextStyle(fontSize: 18.sp),
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        '• $release • $status',
                                        style: TextStyle(
                                            fontSize: 16.sp,
                                            color: AlysColors.alysBlue),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    author,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: AlysColors.alysBlue,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Row(
                                    children: [
                                      Text(
                                        '87.5%',
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                          color: AlysColors.kingYellow,
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        '• 25 chapters left',
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          color: AlysColors.alysBlue,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4.h),
                                  Container(
                                    width: double.infinity,
                                    height: 8.h,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(4.r),
                                    ),
                                    child: FractionallySizedBox(
                                      alignment: Alignment.centerLeft,
                                      widthFactor: 0.875,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AlysColors.kingYellow,
                                          borderRadius:
                                              BorderRadius.circular(4.r),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 6.h),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 40.w,
                                        height:
                                            40.h, // Same height as the button
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: AlysColors.kingYellow,
                                              width: 1),
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.bookmark,
                                            color: AlysColors.kingYellow,
                                            size: 20.sp, // Smaller icon
                                          ),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          minimumSize: Size(185.w, 40.h),
                                          backgroundColor:
                                              AlysColors.kingYellow,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                          ),
                                        ),
                                        child: Text(
                                          'Read Chapter 365',
                                          style: TextStyle(
                                            color: AlysColors.black,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Genres section
                  SizedBox(height: 16.h),
                  Text(
                    'Genres',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AlysColors.alysBlue,
                    ),
                  ),
                  SizedBox(height: 4.h), // Reduced the height here
                  Wrap(
                    spacing: 6.0.w,
                    children: genresList.map((genre) {
                      return Chip(
                        padding: EdgeInsets.zero,
                        labelPadding: EdgeInsets.symmetric(
                          vertical:
                              -4.h, // Adjust this value to change the height
                          horizontal: 6.w,
                        ),
                        label: Text(
                          genre,
                          style: const TextStyle(color: AlysColors.kingYellow),
                        ),
                        backgroundColor: AlysColors.black,
                        side: const BorderSide(color: AlysColors.kingYellow),
                      );
                    }).toList(),
                  ),

                  SizedBox(height: 16.h),
                  Text(
                    'Synopsis',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AlysColors.alysBlue,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isExpanded
                              ? synopsis
                              : '${synopsis.substring(0, 200)}...',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: AlysColors.alysBlue,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Center(
                          child: Icon(
                            _isExpanded
                                ? CupertinoIcons.chevron_up
                                : CupertinoIcons.chevron_down,
                            color: AlysColors.kingYellow,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Back button on top of everything else
          Positioned(
            top: 60.h,
            left: 20.w,
            child: IconButton(
              icon: const Icon(CupertinoIcons.back,
                  color: Colors.white, size: 34),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}
