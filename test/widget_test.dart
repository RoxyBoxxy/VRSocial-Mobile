// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:colibri/core/di/injection.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:intl/intl.dart';

void main() {
  setUp(() {
    configureDependencies();
  });
  // testWidgets("testing login", (widget)async{
  //   await widget.pumpWidget(LoginScreen());
  //   expect(findsNWidgets(), matcher)
  // });
  // test("testing validation", ()async{
  //
  //   var emailValidator=FieldValidators(validatePassword,null);
  //   emailValidator.stream.listen(expectAsync1((value){
  //     expect(value, "s2achin@gmail.com");
  //   }));
  //   emailValidator.onChange("s2achin@gmail.com");
  //
  //  //  await expectLater(emailValidator.stream, "sachin");
  // });
  test("date", () {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('{}');
    final String formatted = formatter.format(now);
    print(formatted);
  });

  test("check data", () {
    // print(text);
    // int timeInMili=1610762371000;
    // final DateFormat formatter = DateFormat.jms().add_MMMd().add_y();
    // final String formatted = formatter.format(DateTime.fromMillisecondsSinceEpoch(timeInMili,isUtc: false));
    // print(formatted);
  });
}
