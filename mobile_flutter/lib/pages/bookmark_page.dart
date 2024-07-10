import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_flutter/utils/check_connectivity.dart';
import 'package:mobile_flutter/widgets/no_wifi.dart';
import '../widgets/appbar_bell.dart';
import '../widgets/navbar.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
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
      appBar: const AppBarWithBell(title: 'Bookmark'),
      body: !isConnected
          ? const NoWifiWidget(
              retryPage: BookmarkPage(),
            )
          : Center(
              child: Image.network(
                'https://temp.compsci88.com/cover/Omniscient-Readers-Viewpoint.jpg',
                width: 300.w,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
      bottomNavigationBar: const NavBar(
        selectedLabel: 'Bookmark',
      ),
    );
  }
}
