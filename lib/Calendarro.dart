import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:mobileoffice/Utils/DateUtils.dart';
import 'package:mobileoffice/events.dart';

abstract class DayTileBuilder {
  Widget build(BuildContext context, DateTime date);
}

class Calendarro extends StatefulWidget {
  Calendarro(
      {Key key,
      this.startDate,
      this.endDate,
      this.displayMode = DisplayMode.WEEKS,
      this.dayTileBuilder,
      this.selectedDate,
      this.selectedDates,
      this.selectionMode = SelectionMode.SINGLE})
      : super(key: key) {

    startDate = DateUtils.toMidnight(startDate);
    endDate = DateUtils.toMidnight(endDate);
  }

  DateTime selectedDate;
  List<DateTime> selectedDates = List();

  DateTime startDate;
  DateTime endDate;
  DisplayMode displayMode;
  SelectionMode selectionMode;

  CalendarroState state;
  DayTileBuilder dayTileBuilder;

  static CalendarroState of(BuildContext context) =>
      context.ancestorStateOfType(const TypeMatcher<CalendarroState>());

  @override
  CalendarroState createState() {
    state = new CalendarroState(
        displayMode: displayMode,
        dayBuilder: dayTileBuilder,
        selectedDate: selectedDate,
        selectedDates: selectedDates);
    return state;
  }

  void setSelectedDate(DateTime date) {
    state.setSelectedDate(date);
  }

  void toggleDate(DateTime date) {
    state.toggleDate(date);
  }

  void setCurrentDate(DateTime date) {
    state.setCurrentDate(date);
  }

  int getPositionOfDate(DateTime date) {
    int daysDifference =
        date.difference(DateUtils.toMidnight(startDate)).inDays;
    int weekendsDifference = ((daysDifference + startDate.weekday) / 7).toInt();
    var position = daysDifference - weekendsDifference * 2;
    print("position: $position");
    return position;
  }

  int getPageForDate(DateTime date) {
    int daysDifference =
        date.difference(DateUtils.toMidnight(startDate)).inDays;
    int startDayOffset = startDate.weekday - DateTime.monday;
    int page = (daysDifference + startDayOffset) ~/ 7;
    return page;
  }
}

enum DisplayMode { MONTHS, WEEKS }
enum SelectionMode { SINGLE, MULTI }

class CalendarroState extends State<Calendarro> {
  CalendarroState(
      {this.displayMode,
      this.dayBuilder,
      this.selectedDate,
      this.selectedDates});

  DisplayMode displayMode;
  DateTime selectedDate;
  List<DateTime> selectedDates;
  DayTileBuilder dayBuilder;

  int startDayOffset;
  int pagesCount;
  PageView pageView;

  @override
  void initState() {
    super.initState();

    if (selectedDate == null) {
      selectedDate = widget.startDate;
    }
  }

  void setSelectedDate(DateTime date) {
    setState(() {
      selectedDate = date;
    });
  }

  void setCurrentDate(DateTime date) {
    setState(() {
      int page = widget.getPageForDate(date);
      pageView.controller.jumpToPage(page);
    });
  }

  @override
  Widget build(BuildContext context) {
    int daysRange = widget.endDate.difference(widget.startDate).inDays;
    if (displayMode == DisplayMode.WEEKS) {
      pagesCount = daysRange ~/ 7 + 1;
    } else {
      pagesCount = widget.endDate.month - widget.startDate.month + 1;
    }

    startDayOffset = widget.startDate.weekday - DateTime.monday;

    pageView = new PageView.builder(
      itemBuilder: (context, position) => buildCalendarPage(position),
      itemCount: pagesCount,
      controller: new PageController(
          initialPage:
              selectedDate != null ? widget.getPageForDate(selectedDate) : 0),
    );

    return new Container(
        height: displayMode == DisplayMode.WEEKS ? 60.0 : 320.0,
        child: pageView);
  }

  Widget buildCalendarPage(int position) {
    DateTime pageStartDate;
    DateTime pageEndDate;

    if (displayMode == DisplayMode.WEEKS) {
      if (position == 0) {
        pageStartDate = widget.startDate;
        pageEndDate = widget.startDate.add(new Duration(days: 6 - startDayOffset));
      } else if (position == pagesCount - 1) {
        pageStartDate =
            widget.startDate.add(new Duration(days: 7 * position - startDayOffset));
        pageEndDate = widget.endDate;
      } else {
        pageStartDate =
            widget.startDate.add(new Duration(days: 7 * position - startDayOffset));
        pageEndDate = widget.startDate
            .add(new Duration(days: 7 * position + 6 - startDayOffset));
      }
    } else {
      if (position == 0) {
        pageStartDate = widget.startDate;
        DateTime nextMonthFirstDate =
            new DateTime(widget.startDate.year, widget.startDate.month + 1, 1);
        pageEndDate = nextMonthFirstDate.subtract(new Duration(days: 1));
      } else if (position == pagesCount - 1) {
        pageEndDate = widget.endDate;
        pageStartDate = new DateTime(widget.endDate.year, widget.endDate.month, 1);
      } else {
        pageStartDate =
            new DateTime(widget.startDate.year, widget.startDate.month + position, 1);
        DateTime nextMonthFirstDate =
            new DateTime(widget.startDate.year, widget.startDate.month + position + 1, 1);
        pageEndDate = nextMonthFirstDate.subtract(new Duration(days: 1));
      }
    }
    //DisplayMode == WEEKS

    return new CalendarPage(
        pageStartDate: pageStartDate, pageEndDate: pageEndDate);
  }

  bool isDateSelected(DateTime date) {
    if (widget.selectionMode == SelectionMode.MULTI) {
      return selectedDates.contains(date);
    } else {
      return DateUtils.isSameDay(selectedDate, date);
    }
  }

  void toggleDate(DateTime date) {
    setState(() {
      for (var i = selectedDates.length - 1; i >= 0; i--) {
        if (DateUtils.isSameDay(selectedDates[i], date)) {
          selectedDates.removeAt(i);
          return;
        }
      }

      selectedDates.add(date);
    });
  }

  void update() {
    setState(() {});
  }
}

class CalendarPage extends StatelessWidget {
  CalendarPage({
    this.pageStartDate,
    this.pageEndDate,
  });

  DateTime pageStartDate;
  DateTime pageEndDate;

  @override
  Widget build(BuildContext context) {
    return new Container(
        child: Column(
            mainAxisSize: MainAxisSize.min, children: buildRows(context)));
  }

  List<Widget> buildRows(BuildContext context) {
    List<Widget> rows = [];
    rows.add(new CalendarDayLabelsView());

    int startDayOffset = pageStartDate.weekday - DateTime.monday;
    DateTime weekLastDayDate =
        pageStartDate.add(new Duration(days: 6 - startDayOffset));

    if (pageEndDate.isAfter(weekLastDayDate)) {
      rows.add(new Row(
          children: buildCalendarRow(context, pageStartDate, weekLastDayDate)));

      for (var i = 1; i < 6; i++) {
        DateTime nextWeekFirstDayDate =
            pageStartDate.add(new Duration(days: 7 * i - startDayOffset));

        if (nextWeekFirstDayDate.isAfter(pageEndDate)) {
          break;
        }

        DateTime nextWeekLastDayDate =
            pageStartDate.add(new Duration(days: 7 * i - startDayOffset + 6));
        if (nextWeekLastDayDate.isAfter(pageEndDate)) {
          nextWeekLastDayDate = pageEndDate;
        }

        rows.add(new Row(
            children: buildCalendarRow(
                context, nextWeekFirstDayDate, nextWeekLastDayDate)));
      }
    } else {
      rows.add(new Row(
          children: buildCalendarRow(context, pageStartDate, pageEndDate)));
    }

    return rows;
  }

  List<Widget> buildCalendarRow(
      BuildContext context, DateTime rowStartDate, DateTime rowEndDate) {
    List<Widget> items = [];

    DateTime currentDate = rowStartDate;
    for (int i = 0; i < 7; i++) {
      if (i + 1 >= rowStartDate.weekday && i + 1 <= rowEndDate.weekday) {
        CalendarroState calendarro = Calendarro.of(context) as CalendarroState;
        if (calendarro.dayBuilder != null) {
          Widget dayTile = calendarro.dayBuilder.build(context, currentDate);
          items.add(dayTile);
        } else {
          items.add(CalendarDayItem(date: currentDate));
        }
        currentDate = currentDate.add(new Duration(days: 1));
      } else {
        items.add(new Expanded(
          child: new Text(""),
        ));
      }
    }

    return items;
  }

  Widget buildCalendarItem(DateTime date) {
    return new CalendarDayItem(
      date: date,
    );
  }
}

class CalendarDayItem extends StatelessWidget {
  CalendarDayItem({this.date, this.calendarro});

  DateTime date;
  CalendarroState calendarro;
  int count = 0;
  BuildContext context;

  @override
  Widget build(BuildContext context) {
    context = context;
    bool isWeekend = DateUtils.isWeekend(date);
    var textColor = isWeekend ? Colors.grey : Colors.black;
    bool isToday = DateUtils.isToday(date);
    calendarro = Calendarro.of(context) as CalendarroState;

    bool isSelected = calendarro.isDateSelected(date);

    BoxDecoration boxDecoration;
    if (isSelected) {
      boxDecoration =
          new BoxDecoration(color: Colors.white, shape: BoxShape.circle);
    } else if (isToday) {
      boxDecoration = new BoxDecoration(
          border: new Border.all(
            color: Colors.white,
            width: 1.0,
          ),
          shape: BoxShape.circle);
    }

    return new Expanded(
        child: new GestureDetector(
      child: new Container(
          height: 40.0,
          decoration: boxDecoration,
          child: new Center(
              child: new Text(
            "${date.day}",
            textAlign: TextAlign.center,
            style: new TextStyle(color: textColor),
          ))),
      onTap: handleTap,
    ));
  }

  void handleTap() {
    calendarro.setSelectedDate(date);
    calendarro.setCurrentDate(date);
  }
}

class CalendarDayLabelsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Row(
      children: <Widget>[
        new Expanded(child: new Text("Mon", textAlign: TextAlign.center)),
        new Expanded(child: new Text("Tue", textAlign: TextAlign.center)),
        new Expanded(child: new Text("Wed", textAlign: TextAlign.center)),
        new Expanded(child: new Text("Thu", textAlign: TextAlign.center)),
        new Expanded(child: new Text("Fri", textAlign: TextAlign.center)),
        new Expanded(child: new Text("Sat", textAlign: TextAlign.center)),
        new Expanded(child: new Text("Sun", textAlign: TextAlign.center)),
      ],
    );
  }
}
