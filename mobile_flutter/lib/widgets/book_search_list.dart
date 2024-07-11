import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_flutter/utils/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookSearchList extends StatelessWidget {
  final List<dynamic> books;

  const BookSearchList({super.key, required this.books});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AlysColors.black,
      padding: EdgeInsets.symmetric(horizontal: 16.0.w),
      child: ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          final latestChapterReleaseDate =
              DateTime.parse(book['latest_chapter_release']);
          final isNew =
              DateTime.now().difference(latestChapterReleaseDate).inDays <= 7;
          final genresList = List<String>.from(book['genres']);
          final displayedGenres = genresList.take(6).join(', ');
          final genres = '$displayedGenres ...';
          final coverUrl = book['cover_url'];

          String truncatedTitle = book['title'];
          if (truncatedTitle.length > 45) {
            truncatedTitle = '${truncatedTitle.substring(0, 45)}...';
          }

          return Padding(
            padding: EdgeInsets.all(10.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 98.w,
                  height: 140.h,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  child: coverUrl != null && coverUrl.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(5.r),
                          child: Image.network(
                            coverUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/placeholder_cover.png',
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(5.r),
                          child: Image.asset(
                            'assets/placeholder_cover.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              truncatedTitle,
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                color: AlysColors.alysBlue,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.bookmark,
                                color: AlysColors.alysBlue,
                                size: 35.sp,
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Latest: ',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AlysColors.alysBlue,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Chapter ${book['latest_chapter']} • ${DateFormat('dd/MM/yyyy').format(latestChapterReleaseDate)}',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: AlysColors.alysBlue,
                                  ),
                                ),
                              ),
                              if (isNew)
                                Container(
                                  margin: EdgeInsets.only(left: 8.w),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5.w, vertical: 2.h),
                                  decoration: BoxDecoration(
                                    color: AlysColors.kingYellow,
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Text(
                                    'NEW',
                                    style: TextStyle(
                                      fontSize: 8.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AlysColors.black,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 2.h),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Status: ',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AlysColors.alysBlue,
                                  ),
                                ),
                                TextSpan(
                                  text: '${book['status']} ',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: AlysColors.alysBlue,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Year: ',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AlysColors.alysBlue,
                                  ),
                                ),
                                TextSpan(
                                  text: '${book['release']}',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: AlysColors.alysBlue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Genres: ',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AlysColors.alysBlue,
                                  ),
                                ),
                                TextSpan(
                                  text: genres,
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: AlysColors.alysBlue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
