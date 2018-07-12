
import 'package:event_bus/event_bus.dart';

var eventBus = EventBus();

class DayClickedEvent {
  DateTime date;
  int pageIndex;

  DayClickedEvent({this.date, this.pageIndex});
}

class ReservationsUpdatedEvent {}