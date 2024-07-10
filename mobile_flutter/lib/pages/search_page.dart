import 'package:flutter/material.dart';
import '../widgets/appbar_bell.dart';
import '../widgets/navbar.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarWithBell(title: 'Search'),
      body: Center(
        child: Text('Search Page Content'),
      ),
      bottomNavigationBar: NavBar(
        selectedLabel: 'Search',
      ),
    );
  }
}
