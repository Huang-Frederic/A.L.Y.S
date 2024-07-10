import 'package:flutter/material.dart';
import 'package:mobile_flutter/utils/check_connectivity.dart';
import 'package:mobile_flutter/widgets/no_wifi.dart';
import '../widgets/appbar_bell.dart';
import '../widgets/navbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
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
      appBar: const AppBarWithBell(title: 'Home'),
      body: !isConnected
          ? const NoWifiWidget(
              retryPage: HomePage(),
            )
          : Center(
              child: Image.network(
                'https://temp.compsci88.com/cover/Solo-Leveling.jpg',
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
      bottomNavigationBar: const NavBar(
        selectedLabel: 'Home',
      ),
    );
  }
}
