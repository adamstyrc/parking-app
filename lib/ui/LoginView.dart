import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  @override
  State createState() {
    return LoginViewState();
  }
}

class LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
          color: Colors.white,
          child: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(16.0),
                child: new Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'email',
                          contentPadding:
                              EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
                        ),
                      ),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'password',
                          contentPadding:
                              EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
                        ),
                      ),
                      Container(height: 16.0),
                      RaisedButton(
                        onPressed: () {},
                        color: Colors.blue,
                        child: Text("LOGIN"),
                        textColor: Colors.white,
                      )
                    ],
                  ),
                ),
              ),

              Container(color: Colors.blue, height: 100.0, width: 150.0,)
            ],
          )),
    );
  }
}
