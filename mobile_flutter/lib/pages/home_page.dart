import 'package:flutter/material.dart';
import '../widgets/appbar_bell.dart';
import '../widgets/navbar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarWithBell(title: 'Home'),
      body: Center(
        child: Text('Home Page Content'),
      ),
      bottomNavigationBar: NavBar(
        selectedLabel: 'Home',
      ),
    );
  }
}
