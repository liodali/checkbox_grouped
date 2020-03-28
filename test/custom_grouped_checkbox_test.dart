import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:checkbox_grouped/src/custom_grouped_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  testWidgets("test CustomGroupedCheckbox ", (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (ctx){
            return CustomGroupedCheckbox<int>(
              itemBuilder: (ctx,index,v){
                return Text("$index");
              },
              itemCount: 10,
              values: List<int>.generate(10, (i)=>i),
            );
          },
        ),
      ),
    ),);
    expect(find.byType(Text), findsNWidgets(10));
    expect(find.text("11"), findsNothing);
    await tester.pump();

  });
}