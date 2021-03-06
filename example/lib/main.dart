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
  TabController tabController;
  ValueNotifier<int> current = ValueNotifier(0);

  void tabChanged() {
    current.value = tabController.index;
  }

  @override
  void initState() {
    super.initState();
    tabController =
        TabController(initialIndex: current.value, length: 4, vsync: this);
    tabController.addListener(tabChanged);
  }

  @override
  void dispose() {
    tabController.removeListener(tabChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ValueListenableBuilder<int>(
          valueListenable: current,
          builder: (ctx, value, _) {
            return Column(
              children: [
                SizedBox(
                  height: 56,
                ),
                ListTile(
                  title: Text(
                    "basics",
                    style: TextStyle(
                      color: value == 0 ? Colors.blue : null,
                    ),
                  ),
                  onTap: () {
                    tabController.index = 0;
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text(
                    "customs",
                    style: TextStyle(
                      color: value == 1 ? Colors.blue : null,
                    ),
                  ),
                  onTap: () {
                    tabController.index = 1;
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text(
                    "dialog",
                    style: TextStyle(
                      color: value == 2 ? Colors.blue : null,
                    ),
                  ),
                  onTap: () {
                    tabController.index = 2;
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text(
                    "list of grouped",
                    style: TextStyle(
                      color: value == 3 ? Colors.blue : null,
                    ),
                  ),
                  onTap: () {
                    tabController.index = 3;
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        ),
      ),
      appBar: AppBar(
        title: Text("examples"),
      ),
      body: TabBarView(
        controller: tabController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          _SimpleGrouped(),
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

class _SimpleGrouped extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    GroupController controller = GroupController(initSelectedItem: [2]);
    GroupController circularController = GroupController();
    GroupController switchController = GroupController();
    GroupController chipsController =
        GroupController(isMultipleSelection: true);
    GroupController multipleCheckController = GroupController(
      isMultipleSelection: true,
      initSelectedItem: [2, 5, 4],
    );
    return SingleChildScrollView(
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
            controller: switchController,
            itemsTitle: List.generate(10, (index) => "$index"),
            values: List.generate(10, (index) => index),
            disableItems: [2],
            textStyle: TextStyle(fontSize: 16),
            activeColor: Colors.red,
            onItemSelected: (values) {
              print(values);
            },
          ),
        ],
      ),
    );
  }
}
