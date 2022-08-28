import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class SharedAxisTransitionSwitcher extends StatelessWidget {
  const SharedAxisTransitionSwitcher({
    @required this.fillColor,
    @required this.child,
    @required this.transitionType,
  })  : assert(fillColor != null),
        assert(transitionType != null),
        assert(child != null);

  final Widget child;
  final Color fillColor;
  final SharedAxisTransitionType transitionType;

  @override
  Widget build(BuildContext context) {
    return PageTransitionSwitcher(
      transitionBuilder: (child, animation, secondaryAnimation) {
        return SharedAxisTransition(
          fillColor: fillColor,
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          transitionType: transitionType,
          child: child,
        );
      },
      child: child,
    );
  }
}

class FadeThroughTransitionSwitcher extends StatelessWidget {
  const FadeThroughTransitionSwitcher({
    @required this.fillColor,
    @required this.child,
  })  : assert(fillColor != null),
        assert(child != null);

  final Widget child;
  final Color fillColor;

  @override
  Widget build(BuildContext context) {
    return PageTransitionSwitcher(
      transitionBuilder: (child, animation, secondaryAnimation) {
        return FadeThroughTransition(
          fillColor: fillColor,
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          child: child,
        );
      },
      child: child,
    );
  }
}

class FadeTransitionSwitcher extends StatelessWidget {
  const FadeTransitionSwitcher({
    @required this.fillColor,
    @required this.child,
  })  : assert(fillColor != null),
        assert(child != null);

  final Widget child;
  final Color fillColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 100),
      child: child,
    );
  }
}
