import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_app/widgets/test_alet_dialog.dart';
import '';
import 'my_home_bloc.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final myHomeBloc = MyHomeBloc();
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = myHomeBloc.alertStream.stream.listen((event) {
      showAlertDialog(event);
    });

    myHomeBloc.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key("scaffold"),
      appBar: AppBar(
        key: const Key("app_bar"),
        title: const Text("Flutter app test", key: Key("text_test_app")),
      ),
      body: Center(
        key: const Key("center"),
        child: Column(
          key: const Key("column"),
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:',
                key: Key("text_pushed_btn")),
            StreamBuilder<String>(
                initialData: "0",
                stream: myHomeBloc.counterStream.stream,
                builder: (context, snapshot) {
                  return Text(
                    snapshot.data ?? "0",
                    key: const Key("text_result"),
                    style: Theme.of(context).textTheme.headline4,
                  );
                }),
            const SizedBox(key: Key("sb_result"), height: 10),
            StreamBuilder<bool>(
                initialData: false,
                stream: myHomeBloc.divisibleStream.stream,
                builder: (context, snapshotVisible) {
                  final visible = snapshotVisible.data!;
                  return AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: visible? 1 : 0,
                    child: const Text("The number divisible by 10",
                        key: Key("text_divisible")),
                  );
                }),
          ],
        ),
      ),
      floatingActionButton: Row(
        key: const Key("row"),
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            key: const Key("cont_increment"),
            margin: const EdgeInsets.symmetric(horizontal: 5.0),
            child: FloatingActionButton(
              key: const Key("increment_btn"),
              onPressed: myHomeBloc.incrementCounter,
              child: const Icon(
                Icons.add,
                key: Key("icon_add"),
              ),
            ),
          ),
          Container(
            key: const Key("cont_decrement"),
            margin: const EdgeInsets.symmetric(horizontal: 5.0),
            child: FloatingActionButton(
              key: const Key("decrement_btn"),
              onPressed: myHomeBloc.decrementCounter,
              child: const Icon(
                Icons.remove,
                key: Key("icon_remove"),
              ),
            ),
          ),
          Container(
            key: const Key("cont_clear"),
            margin: const EdgeInsets.symmetric(horizontal: 5.0),
            child: FloatingActionButton(
              key: const Key("clear_btn"),
              onPressed: myHomeBloc.resetCounter,
              child: const Text(
                "C",
                key: Key("text_clear"),
              ),
            ),
          )
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  showAlertDialog(String text) {
    CustomAlertDialog.show(context, text,doSome: (){});
  }

  @override
  void dispose() {
    super.dispose();
    myHomeBloc.dispose();
    _subscription?.cancel();
    _subscription = null;
  }
}
