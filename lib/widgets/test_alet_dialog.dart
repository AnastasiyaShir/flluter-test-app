import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String text;
  final Function()? doSome;
  final Function(String s)? onClick;

  const CustomAlertDialog(
      {Key? key, this.doSome, this.onClick, required this.text})
      : super(key: key);

  static show(BuildContext context, String text,
      {Function()? doSome, Function(String s)? onClick}) {
    showDialog(
      context: context,
      builder: (BuildContext context) =>
          CustomAlertDialog(text: text, doSome: doSome, onClick: onClick),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: const Key("alert_dialog"),
      content: Text(text, key: const Key("text_dialog")),
      actions: [
        _okButton(context),
      ],
    );
  }

  Widget _okButton(BuildContext context) {
    return TextButton(
      key: const Key("tb_ok"),
      child: const Text(
        "OK",
        key: Key("text_ok"),
      ),
      onPressed: () {
        doSome?.call();
        Navigator.pop(context, true);
      },
    );
  }
}
