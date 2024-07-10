import 'package:flutter/material.dart';
import '../widgets/appbar_bell.dart';
import '../widgets/navbar.dart';

class BookmarkPage extends StatelessWidget {
  const BookmarkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarWithBell(title: 'Bookmark'),
      body: Center(
        child: Text('Bookmark Page Content'),
      ),
      bottomNavigationBar: NavBar(
        selectedLabel: 'Bookmark',
      ),
    );
  }
}
