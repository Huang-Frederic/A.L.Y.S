import 'package:flutter/material.dart';
import 'package:mobile_flutter/database/book_service.dart';
import 'package:mobile_flutter/utils/check_connectivity.dart';
import 'package:mobile_flutter/utils/colors.dart';
import 'package:mobile_flutter/widgets/book_list.dart';
import 'package:mobile_flutter/widgets/no_wifi.dart';
import 'package:mobile_flutter/widgets/unex_error.dart';
import '../widgets/appbar_bell.dart';
import '../widgets/navbar.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late BookService _bookService;
  late Future<List<dynamic>> _booksFuture;
  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _bookService = BookService();
    _booksFuture = _bookService.getAllBooks();
  }

  Future<void> _checkConnectivity() async {
    bool result = await handleConnectivity();
    setState(() {
      isConnected = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWithBell(title: 'Search'),
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
                  final books = snapshot.data!;
                  return BookList(books: books);
                }
              },
            ),
      bottomNavigationBar: const NavBar(
        selectedLabel: 'Search',
      ),
    );
  }
}
