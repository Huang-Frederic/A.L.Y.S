import 'package:flutter/material.dart';
import '../widgets/appbar_bell.dart';
import '../widgets/navbar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarWithBell(title: 'Profile'),
      body: Center(
        child: Text('Profile Page Content'),
      ),
      bottomNavigationBar: NavBar(
        selectedLabel: 'Profile',
      ),
    );
  }
}
