import 'package:flutter/material.dart';
import 'package:mobileoffice/Utils/Logger.dart';
import 'package:mobileoffice/controller/ReservationsController.dart';
import 'package:mobileoffice/ui/AccountView.dart';
import 'package:mobileoffice/ui/DaysView.dart';
import 'package:mobileoffice/ui/PlannerView.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key key, this.title}) : super(key: key);

  final String title;

  @override
  DashboardState createState() => new DashboardState();
}

class DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin<Dashboard>, WidgetsBindingObserver {
  int selectedTabIndex = 0;
  Widget displayedTabWidget = null;
  TabController tabController;


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    Logger.log("state $state");

    if (state == AppLifecycleState.resumed) {
      ReservationsController.get().updateReservations().then((r) {});
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    displayedTabWidget = new Text("cccc");
    return new Scaffold(
//    appBar: AppBar(
//      title: Text("Parking"),
//    ),
      bottomNavigationBar: new BottomNavigationBar(
          currentIndex: selectedTabIndex,
          onTap: (int index) {
            setState(() {
              this.selectedTabIndex = index;

              switch (selectedTabIndex) {
                case 0:
                  displayedTabWidget = new Text("aaaa");
                  break;
                case 1:
                  displayedTabWidget = new Text("bbbb");
              }
            });
          },
          items: <BottomNavigationBarItem>[
            new BottomNavigationBarItem(
                icon: new Icon(Icons.today), title: new Text('Days')),
            new BottomNavigationBarItem(
                icon: new Icon(Icons.calendar_today),
                title: new Text('Planner')),
            new BottomNavigationBarItem(
                icon: new Icon(Icons.account_circle),
                title: new Text('Account')),
          ]),
      body: new Column(children: <Widget>[
        Material(
            child: new Container(
                height: 72.0,
                child: Stack(
                  children: <Widget>[
                    Align(
                        child: Image(
                          image: AssetImage("img/car_white.png"),
                          height: 36.0,
                        ),
                        alignment: FractionalOffset(0.88, 0.95)),
                    Align(child: Text("Parking App", style: TextStyle(color: Colors.white, fontSize: 20.0),), alignment: FractionalOffset(0.05, 0.8))
                  ],
                )),
            elevation: 4.0,
            color: Colors.orange),
        new Stack(children: <Widget>[
          new Offstage(offstage: selectedTabIndex != 0, child: DaysView()),
          new Offstage(offstage: selectedTabIndex != 1, child: PlannerView()),
          new Offstage(offstage: selectedTabIndex != 2, child: AccountView()),
        ])
      ]),
      floatingActionButton: null,
//      floatingActionButton: new FloatingActionButton(
//        onPressed: _incrementCounter,
//        tooltip: 'Increment',
//        child: new Icon(Icons.add),
//      ),
    );
  }
}
