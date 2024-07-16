import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/colors.dart';

class FilterModal extends StatefulWidget {
  final List<String> authors;
  final List<String> genres;
  final Function(String?) onAuthorSelected;
  final Function(List<String>) onGenresSelected;
  final Function(String?) onTypeSelected;
  final Function(String?) onStatusSelected;
  final String? selectedAuthor;
  final List<String> selectedGenres;
  final String? selectedType;
  final String? selectedStatus;

  const FilterModal({
    super.key,
    required this.authors,
    required this.genres,
    required this.onAuthorSelected,
    required this.onGenresSelected,
    required this.onTypeSelected,
    required this.onStatusSelected,
    this.selectedAuthor,
    this.selectedGenres = const [],
    this.selectedType,
    this.selectedStatus,
  });

  @override
  State<FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  String? _selectedAuthor;
  List<String> _selectedGenres = [];
  String? _selectedType;
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _selectedAuthor = widget.selectedAuthor;
    _selectedGenres = List.from(widget.selectedGenres);
    _selectedType = widget.selectedType;
    _selectedStatus = widget.selectedStatus;
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7.h,
      maxChildSize: 0.8.h,
      minChildSize: 0.7.h,
      expand: false,
      shouldCloseOnMinExtent: false,
      builder: (context, scrollController) {
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AlysColors.black,
                borderRadius:
                    BorderRadius.circular(20.0), // Adjust the radius as needed
              ),
              padding: EdgeInsets.symmetric(horizontal: 20.0.w),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30.h),
                    Text(
                      'Type',
                      style: TextStyle(
                        color: AlysColors.alysBlue,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Wrap(
                      spacing: 10.0.w,
                      runSpacing: 10.0.h,
                      children: ['Manga', 'Manhwa', 'Manhua', 'OEL']
                          .map((String type) {
                        return ChoiceChip(
                          label: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical:
                                    1.0.h), // Adjust the vertical padding here
                            child: Text(type),
                          ),
                          selected: _selectedType == type,
                          onSelected: (bool selected) {
                            setState(() {
                              _selectedType = selected ? type : null;
                            });
                          },
                          selectedColor: AlysColors.black,
                          backgroundColor: AlysColors.black,
                          side: BorderSide(
                            color: _selectedType == type
                                ? AlysColors.kingYellow
                                : AlysColors.alysBlue,
                          ),
                          labelStyle: TextStyle(
                            color: _selectedType == type
                                ? AlysColors.kingYellow
                                : AlysColors.alysBlue,
                          ),
                          showCheckmark: false,
                          visualDensity: VisualDensity.compact,
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      'Status',
                      style: TextStyle(
                        color: AlysColors.alysBlue,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Wrap(
                      spacing: 10.0.w,
                      runSpacing: 10.0.h,
                      children: ['Complete', 'Ongoing', 'Hiatus']
                          .map((String status) {
                        return ChoiceChip(
                          label: Padding(
                            padding: EdgeInsets.symmetric(vertical: 1.0.h),
                            child: Text(status),
                          ),
                          selected: _selectedStatus == status,
                          onSelected: (bool selected) {
                            setState(() {
                              _selectedStatus = selected ? status : null;
                            });
                          },
                          selectedColor: AlysColors.black,
                          backgroundColor: AlysColors.black,
                          side: BorderSide(
                            color: _selectedStatus == status
                                ? AlysColors.kingYellow
                                : AlysColors.alysBlue,
                          ),
                          labelStyle: TextStyle(
                            color: _selectedStatus == status
                                ? AlysColors.kingYellow
                                : AlysColors.alysBlue,
                          ),
                          showCheckmark: false,
                          visualDensity: VisualDensity.compact,
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      'Author',
                      style: TextStyle(
                        color: AlysColors.alysBlue,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        Container(
                          width: 250.w,
                          height: 45.h,
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.0.w, vertical: 5.0.h),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: _selectedAuthor == null
                                    ? AlysColors.alysBlue
                                    : AlysColors.kingYellow),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: DropdownButton<String>(
                            value: _selectedAuthor,
                            isExpanded: true,
                            hint: const Text(
                              '---',
                              style: TextStyle(color: AlysColors.alysBlue),
                            ),
                            items: widget.authors.map((String author) {
                              return DropdownMenuItem<String>(
                                value: author,
                                child: Text(author,
                                    style: TextStyle(
                                        color: _selectedAuthor == author
                                            ? AlysColors.kingYellow
                                            : AlysColors.alysBlue)),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedAuthor = newValue;
                              });
                            },
                            dropdownColor: AlysColors.grey,
                            underline: Container(),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(CupertinoIcons.clear,
                              color: AlysColors.alysBlue),
                          onPressed: () {
                            setState(() {
                              _selectedAuthor = null;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      'Genres',
                      style: TextStyle(
                        color: AlysColors.alysBlue,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Wrap(
                      spacing: 10.0.w,
                      runSpacing: 10.0.h,
                      children: widget.genres.map((String genre) {
                        return FilterChip(
                          label: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical:
                                    1.0.h), // Adjust the vertical padding here
                            child: Text(genre),
                          ),
                          selected: _selectedGenres.contains(genre),
                          onSelected: (bool selected) {
                            setState(() {
                              if (selected) {
                                _selectedGenres.add(genre);
                              } else {
                                _selectedGenres.remove(genre);
                              }
                            });
                          },
                          selectedColor: AlysColors.black,
                          backgroundColor: AlysColors.black,
                          side: BorderSide(
                            color: _selectedGenres.contains(genre)
                                ? AlysColors.kingYellow
                                : AlysColors.alysBlue,
                          ),
                          labelStyle: TextStyle(
                            color: _selectedGenres.contains(genre)
                                ? AlysColors.kingYellow
                                : AlysColors.alysBlue,
                          ),
                          showCheckmark: false,
                          visualDensity: VisualDensity.compact,
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 100.h),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: AlysColors.black,
                padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 30.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedAuthor = null;
                          _selectedGenres.clear();
                          _selectedType = null;
                          _selectedStatus = null;
                        });
                      },
                      child: Text(
                        'Reset All',
                        style: TextStyle(
                          color: AlysColors.kingYellow,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        widget.onAuthorSelected(_selectedAuthor);
                        widget.onGenresSelected(_selectedGenres);
                        widget.onTypeSelected(_selectedType);
                        widget.onStatusSelected(_selectedStatus);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            horizontal: 40.0.w, vertical: 5.0.h),
                        backgroundColor: AlysColors.kingYellow,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Text(
                        'Filter',
                        style: TextStyle(
                          color: AlysColors.black,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
