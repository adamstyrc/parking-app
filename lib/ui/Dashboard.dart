
import 'package:flutter/material.dart';
import 'package:mobileoffice/ui/AccountView.dart';
import 'package:mobileoffice/ui/DaysView.dart';
import 'package:mobileoffice/ui/PlannerView.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key key, this.title}) : super(key: key);

  final String title;

  @override
  DashboardState createState() => new DashboardState();
}

class DashboardState extends State<Dashboard> with SingleTickerProviderStateMixin<Dashboard> {
  int selectedTabIndex = 0;
  Widget displayedTabWidget = null;
  TabController tabController;

  @override
  Widget build(BuildContext context) {
    displayedTabWidget = new Text("cccc");
    return new Scaffold(
//      appBar: new AppBar(
//        title: new Text(widget.title),
//
//      ),
    appBar: AppBar(
      title: Text("Parking"),
    ),
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
              new Offstage(offstage: selectedTabIndex != 0, child: DaysView()),
              new Offstage(offstage: selectedTabIndex != 1, child: PlannerView()),
              new Offstage(offstage: selectedTabIndex != 2, child: AccountView()),
            ])
          ]
      ),
      floatingActionButton: null,
//      floatingActionButton: new FloatingActionButton(
//        onPressed: _incrementCounter,
//        tooltip: 'Increment',
//        child: new Icon(Icons.add),
//      ),
    );
  }
}