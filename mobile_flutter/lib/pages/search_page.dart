import 'package:flutter/material.dart';
import 'package:mobile_flutter/utils/check_connectivity.dart';
import 'package:mobile_flutter/widgets/no_wifi.dart';
import '../widgets/appbar_bell.dart';
import '../widgets/navbar.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
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
      appBar: const AppBarWithBell(title: 'Search'),
      body: !isConnected
          ? const NoWifiWidget(
              retryPage: SearchPage(),
            )
          : Center(
              child: Image.network(
                'https://temp.compsci88.com/cover/Monster-8.jpg',
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
      bottomNavigationBar: const NavBar(
        selectedLabel: 'Search',
      ),
    );
  }
}
