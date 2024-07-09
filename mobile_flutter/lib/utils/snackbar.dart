import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/colors.dart';

void snackBar(BuildContext context, String message, {bool isError = false}) {
  final icon = isError
      ? const Icon(CupertinoIcons.clear_circled, color: Colors.red, size: 30)
      : const Icon(CupertinoIcons.checkmark_alt_circle,
          color: Colors.green, size: 30);

  final overlay = Overlay.of(context);
  late OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) {
      return SnackBarOverlay(
        icon: icon,
        message: message,
        onDismissed: () => overlayEntry.remove(),
      );
    },
  );

  overlay.insert(overlayEntry);
}

class SnackBarOverlay extends StatefulWidget {
  final Icon icon;
  final String message;
  final VoidCallback onDismissed;

  const SnackBarOverlay({
    Key? key,
    required this.icon,
    required this.message,
    required this.onDismissed,
  }) : super(key: key);

  @override
  _SnackBarOverlayState createState() => _SnackBarOverlayState();
}

class _SnackBarOverlayState extends State<SnackBarOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();

    Future.delayed(const Duration(milliseconds: 1500), () async {
      if (mounted) {
        await _controller.reverse();
        widget.onDismissed();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 75.0,
      left: 30.0,
      right: 30.0,
      child: Material(
        color: Colors.transparent,
        child: FadeTransition(
          opacity: _animation,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: AlysColors.grey,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Row(
              children: [
                widget.icon,
                const SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    widget.message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
