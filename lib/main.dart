import 'package:flutter/material.dart';
import 'Service.dart';
import 'package:flutter_calendar/flutter_calendar.dart';


void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primaryColor: Colors.orange,
        accentColor: Colors.cyan[600],
//        primarySwatch: Colors.orange,

      ),
      home: new MyHomePage(title: 'Vattenfall Parking'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int selectedTabIndex = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
      Service().update();

    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),

      ),
      bottomNavigationBar: new BottomNavigationBar(
          currentIndex: selectedTabIndex,
          onTap: (int index) { setState((){ this.selectedTabIndex = index; }); },
          items: <BottomNavigationBarItem>[
            new BottomNavigationBarItem(icon: new Icon(Icons.today), title: new Text('Days')),
            new BottomNavigationBarItem(icon: new Icon(Icons.calendar_today), title: new Text('Planner')),
            new BottomNavigationBarItem(icon: new Icon(Icons.account_circle), title: new Text('Account')),
          ]),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Calendar(
              showCalendarPickerIcon: false,
              showTodayAction: false,
              isExpandable: true
            ),
            new Text(
              'You have pushed the button this many times:',
            ),
            new Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
    );
  }
}
