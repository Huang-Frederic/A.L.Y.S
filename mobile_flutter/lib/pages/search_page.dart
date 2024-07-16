import 'package:flutter/material.dart';
import 'package:mobile_flutter/database/book_service.dart';
import 'package:mobile_flutter/utils/check_connectivity.dart';
import 'package:mobile_flutter/utils/colors.dart';
import 'package:mobile_flutter/widgets/appbar_filter.dart';
import 'package:mobile_flutter/widgets/book_search_list.dart';
import 'package:mobile_flutter/widgets/no_wifi.dart';
import 'package:mobile_flutter/widgets/unex_error.dart';
import 'package:mobile_flutter/widgets/filter_modal.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _filteredBooks = [];
  List<dynamic> _allBooks = [];
  List<String> _authors = [];
  List<String> _genres = [];
  String? _selectedAuthor;
  List<String> _selectedGenres = [];
  String? _selectedType;
  String? _selectedStatus;
  late BookService _bookService;
  late Future<List<dynamic>> _booksFuture;
  bool isConnected = false;
  int activeFilters = 0;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _bookService = BookService();
    _booksFuture = _bookService.getAllBooks();
    _searchController.addListener(_filterBooks);
    _fetchData();
  }

  Future<void> _checkConnectivity() async {
    bool result = await handleConnectivity();
    setState(() {
      isConnected = result;
    });
  }

  Future<void> _fetchData() async {
    final books = await _bookService.getAllBooks();
    final genres = await _bookService.fetchGenres();
    final authors = await _bookService.fetchAuthors();
    setState(() {
      _allBooks = books;
      _filteredBooks = books;
      _genres = genres;
      _authors = authors;
    });
  }

  void _filterBooks() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredBooks = _allBooks.where((book) {
        final title = book['title'].toLowerCase();
        final authors = book['authors'].toLowerCase();
        final genres = book['genres'] as List<dynamic>;
        final matchesQuery = title.contains(query) || authors.contains(query);
        final matchesAuthor = _selectedAuthor == null ||
            authors.contains(_selectedAuthor!.toLowerCase());
        final matchesGenres = _selectedGenres.isEmpty ||
            _selectedGenres.every((genre) => genres.contains(genre));
        final matchesType =
            _selectedType == null || book['type'] == _selectedType;
        final matchesStatus =
            _selectedStatus == null || book['status'] == _selectedStatus;
        return matchesQuery &&
            matchesAuthor &&
            matchesGenres &&
            matchesType &&
            matchesStatus;
      }).toList();
    });
  }

  void _openFilterModal() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return FilterModal(
          authors: _authors,
          genres: _genres,
          onAuthorSelected: (author) {
            _selectedAuthor = author;
          },
          onGenresSelected: (genres) {
            _selectedGenres = genres;
          },
          onTypeSelected: (type) {
            _selectedType = type;
          },
          onStatusSelected: (status) {
            _selectedStatus = status;
          },
          selectedAuthor: _selectedAuthor,
          selectedGenres: _selectedGenres,
          selectedType: _selectedType,
          selectedStatus: _selectedStatus,
        );
      },
    ).whenComplete(() {
      setState(() {
        _updateActiveFilters();
        _filterBooks();
      });
    });
  }

  void _updateActiveFilters() {
    setState(() {
      activeFilters = (_selectedAuthor != null ? 1 : 0) +
          _selectedGenres.length +
          (_selectedType != null ? 1 : 0) +
          (_selectedStatus != null ? 1 : 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithFilter(
        title: 'Search',
        searchController: _searchController,
        openFilterModal: _openFilterModal,
        activeFilters: activeFilters,
      ),
      body: !isConnected
          ? const NoWifiWidget(
              retryPage: SearchPage(),
            )
          : FutureBuilder<List<dynamic>>(
              future: _booksFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    color: AlysColors.black,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  );
                } else if (snapshot.hasError ||
                    !snapshot.hasData ||
                    snapshot.data!.isEmpty) {
                  return const UnexError(
                    retryPage: SearchPage(),
                  );
                } else {
                  return BookSearchList(books: _filteredBooks);
                }
              },
            ),
    );
  }
}
