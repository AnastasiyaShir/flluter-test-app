import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_test_app/main.dart';

void main() {
  //define the equivalence classes:
  // < 0
  // > 31
  // 5
  // 10, 20, 30
  // [0; 5) + (5; 10) + (10; 20) + (20, 30) + (30; 31]

  // Let's define the boundary values and
  // one element to the left and to the right of the boundary.
  // 0; -1; 1;
  // 5; 4; 6;
  // 30; 29; 31; 32

  group('HomePage Widget', () {
    testWidgets('behavior on value: -1', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      HomePage homePage = HomePage(tester);

      await homePage.setNumber(0);
      await homePage.clickOnSubButton();
      expect(await homePage.getAlertDialogFinder(), findsOneWidget);
      expect(homePage.getDialogText(), 'The number can\'t be below 0 !!!');
      expect(await homePage.getTextResult(), '0');
    });

    testWidgets('behavior on value: 0', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      HomePage homePage = HomePage(tester);

      await homePage.setNumber(0);
      await asserZeroValue(homePage);

      await homePage.clickOnAddButton();
      expect(await homePage.getTextResult(), '1');

      await homePage.setNumber(0);
      await clickOnClearButtonAndAssert(homePage);
    });

    testWidgets('behavior on value: 1', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      HomePage homePage = HomePage(tester);

      await homePage.setNumber(1);
      expect(await homePage.getTextResult(), '1');

      await homePage.clickOnAddButton();
      expect(await homePage.getTextResult(), '2');

      await homePage.setNumber(1);
      await homePage.clickOnSubButton();
      await asserZeroValue(homePage);

      await homePage.setNumber(1);
      await clickOnClearButtonAndAssert(homePage);
    });

    testWidgets('behavior on value: 4', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      HomePage homePage = HomePage(tester);

      await homePage.setNumber(4);
      expect(await homePage.getTextResult(), '4');
      expect(await homePage.getTextDivisibleOpacity(), 0.0);

      await clickOnClearButtonAndAssert(homePage);
    });

    testWidgets('behavior on value: 5', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      HomePage homePage = HomePage(tester);

      await homePage.setNumber(5);
      expect(await homePage.getAlertDialogFinder(), findsOneWidget);
      expect(homePage.getDialogText(), 'The number is 5');

      expect(await homePage.getTextResult(), '5');
      expect(await homePage.getTextDivisibleOpacity(), 0.0);

      await homePage.closeDialog();
      await clickOnClearButtonAndAssert(homePage);
    });

    testWidgets('behavior on value: 6', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      HomePage homePage = HomePage(tester);

      await homePage.setNumber(6);
      expect(await homePage.getAlertDialogFinder(), findsNothing);
      expect(await homePage.getTextResult(), '6');
      expect(await homePage.getTextDivisibleOpacity(), 0.0);

      await homePage.clickOnSubButton();
      expect(await homePage.getAlertDialogFinder(), findsOneWidget);
      expect(homePage.getDialogText(), 'The number is 5');
      expect(await homePage.getTextResult(), '5');
      expect(await homePage.getTextDivisibleOpacity(), 0.0);
    });

    testWidgets('behavior on value: 29; 30; 31; 32', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      HomePage homePage = HomePage(tester);

      await homePage.setNumber(29);
      expect(await homePage.getAlertDialogFinder(), findsNothing);
      expect(await homePage.getTextResult(), '29');
      expect(await homePage.getTextDivisibleOpacity(), 0.0);

      await homePage.clickOnAddButton();
      expect(await homePage.getAlertDialogFinder(), findsNothing);
      expect(await homePage.getTextResult(), '30');
      expect(await homePage.getTextDivisibleOpacity(), 1.0);

      await homePage.clickOnAddButton();
      expect(await homePage.getTextResult(), '31');
      expect(await homePage.getTextDivisibleOpacity(), 0.0);

      await homePage.clickOnAddButton();
      expect(await homePage.getTextResult(), '31');
      expect(await homePage.getAlertDialogFinder(), findsOneWidget);
      expect(homePage.getDialogText(), 'The number can\'t be above 31!!!');
    });
  });
}

Future<void> clickOnClearButtonAndAssert(HomePage homePage) async {
  await homePage.clickOnClearButton();
  await asserZeroValue(homePage);
}

Future<void> asserZeroValue(HomePage homePage) async {
  expect(await homePage.getTextResult(), '0');
  expect(await homePage.getTextDivisibleOpacity(), 0.0);
}

class HomePage {
  final WidgetTester _tester;

  final _addButton = find.byIcon(Icons.add);
  final _subButton = find.byIcon(Icons.remove);
  final _clearButton = find.byKey(const Key("clear_btn"));

  final _textResult = find.byKey(const Key("text_result"));
  final _alertDialog = find.byKey(const Key("alert_dialog"));
  final _okButton = find.byKey(const Key("text_ok"));

  final _textDialog = find.byKey(const Key("text_dialog"));

  final _textDivisibleAnimatedOpacity = find.byType(AnimatedOpacity);

  HomePage(this._tester);

  _clockOnWidgetNTimes(Finder finder, int times) async {
    for (var i = 0; i < times; i++) {
      await _tester.tap(finder);
    }
    await _tester.pump();
  }

  setNumber(int number) async {
    await clickOnClearButton();
    if (number <= 5) {
      await clickOnAddButton(number);
    } else {
      await clickOnAddButton(5);
      await closeDialog();
      await clickOnAddButton(number - 5);
    }
  }

  Future<String?> getTextResult() async {
    Text text = _tester.firstWidget(_textResult);
    return text.data;
  }

  Future<double> getTextDivisibleOpacity() async {
    AnimatedOpacity animatedOpacity =
        _tester.firstWidget(_textDivisibleAnimatedOpacity);
    return animatedOpacity.opacity;
  }

  Future<Finder> getAlertDialogFinder() async {
    return _alertDialog;
  }

  String? getDialogText() {
    Text text = _tester.firstWidget(_textDialog);
    return text.data;
  }

  clickOnAddButton([int times = 1]) async {
    await _clockOnWidgetNTimes(_addButton, times);
  }

  clickOnSubButton([int times = 1]) async {
    await _clockOnWidgetNTimes(_subButton, times);
  }

  clickOnClearButton() async {
    await _clockOnWidgetNTimes(_clearButton, 1);
  }

  closeDialog() async {
    await _tester.tap(_okButton);
    await _tester.pump();
  }
}
