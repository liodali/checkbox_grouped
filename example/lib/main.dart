import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:flutter/material.dart';

import 'custom_grouped_example.dart';
import 'list_of_grouped.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: MainExample(),
    );
  }
}

class MainExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainExampleState();
  }
}

class _MainExampleState extends State<MainExample>
    with TickerProviderStateMixin {
  GroupController controller,
      circularController,
      chipsController,
      multipleController,
      multipleCheckController;
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(initialIndex: 0, length: 4, vsync: this);
    controller = GroupController(initSelectedItem: [2]);
    circularController = GroupController();
    chipsController = GroupController(
      isMultipleSelection: true
    );
    multipleController = GroupController(isMultipleSelection: true);
    multipleCheckController = GroupController(
      isMultipleSelection: true,
      initSelectedItem: [2, 5, 4],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("examples"),
        bottom: TabBar(
          controller: tabController,
          onTap: (index) {
            tabController.index = index;
          },
          tabs: <Widget>[
            Text("basics"),
            Text("customs"),
            Text("dialog"),
            Text("list of grouped"),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: <Widget>[
          SingleChildScrollView(
            controller: ScrollController(),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SimpleGroupedCheckbox<int>(
                  controller: controller,
                  //groupTitle:"Basic",
                  onItemSelected: (data) {
                    print(data);
                    if (data == 1) {
                      controller.disabledItemsByTitles(["5"]);
                    } else if (data == 4) {
                      controller.enabledItemsByTitles(["5", "2"]);
                      controller.disabledItemsByTitles(["1"]);
                    } else if (data == 2) {
                      controller.enabledItemsByTitles(["1"]);
                    }
                  },
                  disableItems: ["5"],
                  itemsTitle: ["1", "2", "4", "5"],
                  values: [1, 2, 4, 5],
                  activeColor: Colors.red,
                  checkFirstElement: false,
                ),
                SimpleGroupedCheckbox<int>(
                  controller: circularController,
                  groupTitle: "Circulaire Checkbox",
                  itemsTitle: ["1 ", "2 ", "4 ", "5 "],
                  values: [1, 2, 4, 5],
                  isCirculaire: true,
                  activeColor: Colors.blue,
                  isLeading: true,
                  checkFirstElement: false,
                ),
                SimpleGroupedCheckbox<int>(
                  controller: multipleCheckController,
                  itemsTitle: List.generate(10, (index) => "$index"),
                  values: List.generate(10, (index) => index),
                  activeColor: Colors.green,
                  groupTitle: "expanded multiple checkbox selection",
                  groupTitleStyle: TextStyle(color: Colors.orange),
                  checkFirstElement: false,
                  helperGroupTitle: false,
                  onItemSelected: (data) {
                    print(data);
                  },
                  isExpandableTitle: true,
                ),
                Divider(),
                SimpleGroupedChips<int>(
                  controller: chipsController,
                  values: List.generate(7, (index) => index),
                  itemTitle: List.generate(7, (index) => "chip_text_$index"),
                  backgroundColorItem: Colors.black26,
                  isScrolling: false,
                  onItemSelected: (values) {
                    print(values);
                  },
                ),
                Divider(),
                Text("grouped switch"),
                SimpleGroupedSwitch<int>(
                  itemsTitle: List.generate(10, (index) => "$index"),
                  values: List.generate(10, (index) => index),
                  disableItems: [2],
                  textStyle: TextStyle(fontSize: 16),
                  activeColor: Colors.red,
                  isMultipleSelection: false,
                  onItemSelected: (values) {
                    print(values);
                  },
                ),
              ],
            ),
          ),
          CustomGroupedExample(),
          Column(
            children: <Widget>[
              FlatButton(
                onPressed: () async {
                  var values = await showDialogGroupedCheckbox(
                      context: context,
                      cancelDialogText: "cancel",
                      isMultiSelection: true,
                      itemsTitle: List.generate(15, (index) => "$index"),
                      submitDialogText: "select",
                      dialogTitle: Text("example dialog"),
                      values: List.generate(15, (index) => index));
                  if (values != null) {
                    print(values);
                  }
                },
                child: Text("show dialog checkbox grouped"),
              ),
            ],
          ),
          ListOfGrouped(),
        ],
      ),
    );
  }
}
