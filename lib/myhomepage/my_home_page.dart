import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'my_home_bloc.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title, required this.myHomeBloc})
      : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final MyHomeBloc myHomeBloc;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  showAlertDialog(BuildContext context, String text) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () => Navigator.pop(context, true),
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text(text),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.myHomeBloc.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.myHomeBloc.alertStream.stream.listen((event) {
      showAlertDialog(context, event);
    });

    widget.myHomeBloc.init();

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            StreamBuilder<String>(
                initialData: "0",
                stream: widget.myHomeBloc.counterStream.stream,
                builder: (context, snapshot) {
                  return Text(
                    snapshot.data.toString(),
                    style: Theme.of(context).textTheme.headline4,
                  );
                }),
            const SizedBox(height: 10),
            StreamBuilder<bool>(
                initialData: false,
                stream: widget.myHomeBloc.divisibleStream.stream,
                builder: (context, snapshotVisible) {
                  return Visibility(
                    child: const Text("The number divisible by 5"),
                    visible: snapshotVisible.data ?? false,
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                  );
                }),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 5.0),
            child: FloatingActionButton(
              onPressed: widget.myHomeBloc.incrementCounter,
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 5.0),
            child: FloatingActionButton(
              onPressed: widget.myHomeBloc.decrementCounter,
              tooltip: 'Decrement',
              child: const Icon(Icons.remove),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 5.0),
            child: FloatingActionButton(
              onPressed: widget.myHomeBloc.resetCounter,
              tooltip: 'Decrement',
              child: const Text("C"),
            ),
          )
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
