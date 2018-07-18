import 'package:flutter/material.dart';

class ProgressButton extends StatefulWidget {
  VoidCallback onPressed;

  ProgressButton({GlobalKey<ProgressButtonState> key, this.onPressed}) : super(key : key);

  @override
  State createState() {
    return ProgressButtonState();
  }
}

class ProgressButtonState extends State<ProgressButton> {
  bool inProgress = false;

  Opacity progressIndicator;
  Opacity button;

  @override
  Widget build(BuildContext context) {
    progressIndicator = Opacity(
        child: Theme(
          data: Theme.of(context).copyWith(accentColor: Colors.blue),
          child: new CircularProgressIndicator(),
        ), opacity: inProgress ? 1.0 : 0.0);
    button = Opacity(
        child: RaisedButton(
            color: Colors.blue,
            textColor: Colors.white,
            child: Text("UPDATE"),
            onPressed: () {
              setProgress(true);
              widget.onPressed();
            }),
        opacity: inProgress ? 0.0 : 1.0);
    return Stack(
        children: <Widget>[progressIndicator, button],
        alignment: Alignment.topCenter);
  }

  void setProgress(bool inProgress) {
    setState(() {
      this.inProgress = inProgress;
    });
  }
}
