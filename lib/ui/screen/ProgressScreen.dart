import 'dart:async';

import 'package:flutter/material.dart';


class ProgressScreen extends ModalRoute<void> {

  @override
  Duration get transitionDuration => Duration(milliseconds: 500);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.5);

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      ) {

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Material(
      type: MaterialType.transparency,
      child: SafeArea(
        child: _buildOverlayContent(context),
      ),
      )
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    return Align(
        child: Theme(
          child: CircularProgressIndicator(),
          data: Theme
              .of(context)
              .copyWith(accentColor: Colors.blue),
        ),
        alignment: Alignment(0.0, 0.7)
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }

  Future<bool> _onBackPressed() {
    var completer = new Completer();
    completer.complete(false);
    return completer.future;
  }
}
