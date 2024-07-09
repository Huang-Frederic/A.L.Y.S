import 'package:flutter/material.dart';
import '../pages/login_page.dart';
import '../pages/home_page.dart';

void navigateToLogin(BuildContext context, AxisDirection direction) async {
  Navigator.pushReplacement(
    context,
    CustomPageRoute(
      child: const LoginPage(),
      direction: direction,
    ),
  );
}

void navigateToHome(BuildContext context, AxisDirection direction) {
  Navigator.pushReplacement(
    context,
    CustomPageRoute(child: const HomePage(), direction: direction),
  );
}

class CustomPageRoute extends PageRouteBuilder {
  final Widget child;
  final AxisDirection direction;

  CustomPageRoute({required this.child, this.direction = AxisDirection.up})
      : super(
          transitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = Offset.zero;
            switch (direction) {
              case AxisDirection.left:
                begin = const Offset(-1.0, 0.0);
                break;
              case AxisDirection.right:
                begin = const Offset(1.0, 0.0);
                break;
              default:
                break;
            }

            const end = Offset.zero;
            const curve = Curves.easeInOut;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
}
