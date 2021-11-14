import 'dart:async';

class MyHomeBloc {
  int _counter = 0;

  final counterStream = StreamController<String>.broadcast();
  final alertStream = StreamController<String>.broadcast();
  final divisibleStream = StreamController<bool>.broadcast();

  void incrementCounter() {
    if (_counter + 1 > 31) {
      alertStream.add("The number can't be above 31!!!");
      return;
    }
    _counter++;
    _isDivisibleBy10(_counter);
    counterStream.add(_counter.toString());
    if (_counter == 5) {
      alertStream.add("The number is 5");
    }
  }

  void decrementCounter() {
    if (_counter - 1 < 0) {
      alertStream.add("The number can't be below 0 !!!");
      return;
    }

    _counter--;
    _isDivisibleBy10(_counter);
    counterStream.add(_counter.toString());
    if (_counter == 5) {
      alertStream.add("The number is 5");
    }
  }

  void resetCounter() {
    divisibleStream.add(false);
    counterStream.add("${_counter = 0}");
  }

  _isDivisibleBy10(int number) {
      divisibleStream.add(number % 10 == 0);
  }

  dispose() {
    alertStream.close();
    counterStream.close();
    divisibleStream.close();
  }

  init() {
    divisibleStream.add(false);
    counterStream.add("0");
  }
}
