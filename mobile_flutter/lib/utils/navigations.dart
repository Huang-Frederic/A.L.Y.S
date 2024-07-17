import 'package:flutter/material.dart';
import 'package:mobile_flutter/pages/nav_page.dart';

void navigateTo(
    BuildContext context, Widget targetPage, AxisDirection direction) {
  if (targetPage.runtimeType == const NavPage().runtimeType) {
    Navigator.pushReplacement(
      context,
      CustomPageRoute(
        child: targetPage,
        direction: direction,
      ),
    );
  } else {
    Navigator.push(
      context,
      CustomPageRoute(
        child: targetPage,
        direction: direction,
      ),
    );
  }
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
