import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:checkbox_grouped/src/widgets/custom_grouped_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  testWidgets(" test list custom grouped ", (tester) async {
    final controller =
        ListCustomGroupController(isMultipleSelectionPerGroup: [true, false]);
    final datas = [
      List<int>.generate(
        3,
        (i) => i + 1,
      ),
      List<String>.generate(
        3,
        (i) => "name-${i + 1}",
      )
    ];
    await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListCustomGroupedCheckbox(
              controller: controller,
              isScrollable: true,
              titleGroupedAlignment: Alignment.centerLeft,
              groupTitles: ["Users", "Names"],
              children: [
                CustomIndexedWidgetBuilder(
                  itemBuilder: (ctx, index, selected, isDisabled) {
                    return Card(
                      margin: EdgeInsets.only(
                        top: 5.0,
                        bottom: 5.0,
                      ),
                      child: ListTile(
                        tileColor: selected ? Colors.green[300] : Colors.white,
                        title: Text(
                          "${datas[0][index]}",
                        ),
                        trailing: Opacity(
                          opacity: selected ? 1 : 0,
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                CustomGridIndexedWidgetBuilder(
                    itemBuilder: (ctx, index, selected, isDisabled) {
                      return Card(
                        color: selected ? Colors.green[300] : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            12.0,
                          ),
                        ),
                        margin: EdgeInsets.only(
                          top: 5.0,
                          bottom: 5.0,
                        ),
                        child: Stack(
                          children: [
                            Center(
                              child: Text(
                                datas[1][index] as String,
                                maxLines: 3,
                                overflow: TextOverflow.fade,
                              ),
                            ),
                            Positioned(
                              top: 5,
                              right: 8,
                              child: Opacity(
                                opacity: selected ? 1 : 0,
                                child: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, crossAxisSpacing: 5.0)),
              ],
              listValuesByGroup: datas,
            ),
          ),
        ),
        Duration(seconds: 30));

    await tester.pump();

    await tester.tap(find.byType(ItemWidget).first);

    await tester.pump(Duration(seconds: 10));
    await tester.tap(find.byType(ItemWidget).at(3));
    await tester.pump(Duration(seconds: 10));

    var result = await controller.allSelectedItemsGrouped;
    var actualResult = [
      [1],
      "name-1"
    ];
    expect(result.length, 2);
    expect(result, actualResult);
    await tester.tap(find.byType(ItemWidget).first);
    await tester.pump(Duration(seconds: 10));
    result = await controller.allSelectedItemsGrouped;
    actualResult = [[], "name-1"];
    expect(result, actualResult);
  });
}
