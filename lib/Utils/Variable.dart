import 'package:rxdart/rxdart.dart';

class Variable<T> {
  BehaviorSubject<T> behaviourSubject;
  
  Variable (T val) {
    this.behaviourSubject = new BehaviorSubject();
    behaviourSubject.add(val);
  }


  T _value;
  T get value => _value;

  set value (T newValue) {
    _value = newValue;
    behaviourSubject.add(newValue);
  }

  Observable<T> asObservable() {
    return behaviourSubject.stream;
  } 
}