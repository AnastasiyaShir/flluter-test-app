import 'dart:async';
 class MyHomeBloc {
  int _counter = 0;

  final StreamController<String> counterStream =
      StreamController<String>();
  final StreamController<String> alertStream =
      StreamController<String>();

  final StreamController<bool> divisibleStream =
      StreamController<bool>();


  void incrementCounter() {
    if (_counter + 1 > 31) {
      alertStream.add("The number can't be above 31!!!");
      return;
    }
    _counter++;
    _isDivisibleBy10(_counter);
    counterStream.add((_counter).toString());
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
    counterStream.add((_counter).toString());
    if (_counter == 5) {
      alertStream.add("The number is 5");
    }
  }

  void resetCounter() {
    divisibleStream.add(false);
    counterStream.add((_counter = 0).toString());
  }

  _isDivisibleBy10(int number) {
    if (number % 10 == 0) {
      divisibleStream.add(true);
    } else {
      divisibleStream.add(false);
    }
  }

  dispose() {
    alertStream.close();
    counterStream.close();
    divisibleStream.close();
  }
  
  init(){
    divisibleStream.add(false);
    counterStream.add("0");
  }

}
