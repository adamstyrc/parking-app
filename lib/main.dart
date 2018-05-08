import 'package:flutter/material.dart';
import 'Service.dart';
import 'package:flutter_calendar/flutter_calendar.dart';
import 'Calendarro.dart';
import 'DaysView.dart';


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

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin<MyHomePage> {
  int selectedTabIndex = 0;
  Widget displayedTabWidget = null;
  TabController tabController;

  void _incrementCounter() {
    setState(() {
      Service().update();
      Service()
        .getMonth(12, 2018)
        .asObservable()
        .listen((data)=>print(data));

    });


  }

  @override
  Widget build(BuildContext context) {
    displayedTabWidget = new Text("cccc");
    return new Scaffold(
//      appBar: new AppBar(
//        title: new Text(widget.title),
//
//      ),
      bottomNavigationBar: new BottomNavigationBar(
          currentIndex: selectedTabIndex,
          onTap: (int index) {
            setState((){
              this.selectedTabIndex = index;

              switch(selectedTabIndex) {
                case 0:
                  displayedTabWidget = new Text("aaaa");
                  break;
                case 1:
                  displayedTabWidget = new Text("bbbb");
              }

            }
            );

          },
          items: <BottomNavigationBarItem>[
            new BottomNavigationBarItem(icon: new Icon(Icons.today), title: new Text('Days')),
            new BottomNavigationBarItem(icon: new Icon(Icons.calendar_today), title: new Text('Planner')),
            new BottomNavigationBarItem(icon: new Icon(Icons.account_circle), title: new Text('Account')),
          ]),
      body: new Column(
        children: <Widget>[
          new Material(child: new Container(height: 56.0), elevation: 4.0, color: Colors.orange),
          new Stack(children: <Widget>[
            new Offstage(offstage: selectedTabIndex != 0, child: new DaysView()),
            new Offstage(offstage: selectedTabIndex != 1, child: new Text("bbbb2")),
            new Offstage(offstage: selectedTabIndex != 2, child: new Text("ccc2")),
          ])
        ]
      ),

      floatingActionButton: new FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
    );
  }
}
