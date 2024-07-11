import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_flutter/utils/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookList extends StatelessWidget {
  final List<dynamic> books;

  const BookList({super.key, required this.books});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AlysColors.black,
      child: ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          final latestChapterReleaseDate =
              DateTime.parse(book['latest_chapter_release']);
          final isNew =
              DateTime.now().difference(latestChapterReleaseDate).inDays <= 7;
          final genres = book['genres'].join(', ');
          final coverUrl = book['cover_url'];

          return Padding(
            padding: EdgeInsets.all(8.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80.w,
                  height: 120.h,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: coverUrl != null && coverUrl.isNotEmpty
                      ? Image.network(
                          coverUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/placeholder_cover.png',
                              fit: BoxFit.cover,
                            );
                          },
                        )
                      : Image.asset(
                          'assets/placeholder_cover.png',
                          fit: BoxFit.cover,
                        ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book['title'],
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AlysColors.alysBlue,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Text(
                            'Latest: Chapter ${book['latest_chapter']} • ${DateFormat('dd/MM/yyyy').format(latestChapterReleaseDate)}',
                            style: TextStyle(
                                fontSize: 14.sp, color: AlysColors.alysBlue),
                          ),
                          if (isNew)
                            Container(
                              margin: EdgeInsets.only(left: 8.w),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 6.w, vertical: 2.h),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Text(
                                'NEW',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Status: ${book['status']}',
                        style: TextStyle(
                            fontSize: 14.sp, color: AlysColors.alysBlue),
                      ),
                      Text(
                        'Year: ${book['release']}',
                        style: TextStyle(
                            fontSize: 14.sp, color: AlysColors.alysBlue),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Genres: $genres',
                        style: TextStyle(
                            fontSize: 14.sp, color: AlysColors.alysBlue),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(
                  Icons.bookmark,
                  color: AlysColors.alysBlue,
                  size: 24.sp,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
