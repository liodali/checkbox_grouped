import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:example/custom_grid_grouped_example.dart';
import 'package:flutter/material.dart';

import 'custom_grouped_example.dart';
import 'grid_of_grouped_checkbox.dart';
import 'list_custom_group.dart';
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
        useMaterial3: true,
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
  late TabController tabController;
  ValueNotifier<int> current = ValueNotifier(0);
  final customController = CustomGroupController(
    isMultipleSelection: false,
    initSelectedItem: "basics",
  );
  final List<String> drawerItems = [
    "basics",
    "custom",
    "grid custom",
    "dialog",
    "list of group",
    "more example",
    "list of custom group"
  ];

  void tabChanged() {
    current.value = tabController.index;
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      initialIndex: current.value,
      length: drawerItems.length,
      vsync: this,
    );
    tabController.addListener(tabChanged);
    customController.listen((value) {
      final index = drawerItems.indexOf(value);
      if (index != -1) {
        tabController.index = index;
        Navigator.pop(context);
      }
    });
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
                Expanded(
                  child: CustomGroupedCheckbox<String>(
                    controller: customController,
                    itemBuilder: (ctx, index, isSelected, isDisabled) {
                      return ListTile(
                        title: Text(
                          drawerItems[index],
                          style: TextStyle(
                            color: value == index ? Colors.blue : null,
                          ),
                        ),
                      );
                    },
                    itemExtent: 64,
                    values: drawerItems,
                  ),
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
          CustomGridGroupedExample(),
          _DialogExample(),
          ListOfGrouped(),
          GridOfListGroupedCheckbox(),
          ListCustomGroup(),
        ],
      ),
    );
  }
}

class _SimpleGrouped extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SimpleGroupedState();
}

class _SimpleGroupedState extends State<_SimpleGrouped> {
  GroupController controller = GroupController(initSelectedItem: [2]);
  GroupController switchController = GroupController();
  GroupController chipsController = GroupController(isMultipleSelection: true);
  GroupController multipleCheckController = GroupController(
    isMultipleSelection: true,
    initSelectedItem: List.generate(10, (index) => index),
  );

  @override
  Widget build(BuildContext context) {
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
            disableItems: [5, 4],
            itemsTitle: ["1", "2", "4", "5", "6"],
            values: [1, 2, 4, 5, 6],
            groupStyle: GroupStyle(
              activeColor: Colors.red,
              itemTitleStyle: TextStyle(
                fontSize: 13,
              ),
            ),
          ),
          SimpleGroupedCheckbox<int>(
            controller: multipleCheckController,
            itemsTitle: List.generate(10, (index) => "$index"),
            values: List.generate(10, (index) => index),
            groupStyle: GroupStyle(
              activeColor: Colors.green,
              groupTitleStyle: TextStyle(
                color: Colors.orange,
              ),
            ),
            groupTitle: "expanded multiple checkbox selection",
            helperGroupTitle: true,
            onItemSelected: (data) {
              print(data);
            },
            isExpandableTitle: true,
          ),
          Divider(),
          SimpleGroupedChips<int>(
            controller: chipsController,
            values: List.generate(7, (index) => index),
            itemsTitle: List.generate(7, (index) => "chip_text_$index"),
            chipGroupStyle: ChipGroupStyle.minimize(
              isScrolling: true,
              backgroundColorItem: Colors.grey[400],
              selectedTextColor: Colors.amber,
              itemTitleStyle: TextStyle(
                fontSize: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide.none,
              ),
              checkedShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  width: 2,
                  color: Colors.grey,
                ),
              ),
              selectedIcon: Icons.check,
              direction: ChipsDirection.horizontal,
            ),
            onItemSelected: (values) {
              print(values);
            },
          ),
          Divider(),
          Text("grouped switch"),
          SimpleGroupedSwitch<int>(
            controller: switchController,
            itemsTitle: List.generate(7, (index) => "${index}"),
            values: List.generate(7, (index) => index),
            disableItems: [3],
            groupStyle: SwitchGroupStyle(
              itemTitleStyle: TextStyle(
                fontSize: 16,
                color: Colors.blue,
              ),
              activeColor: Colors.red,
            ),
            onItemSelected: (values) {
              print(values);
            },
          ),
        ],
      ),
    );
  }
}

class _DialogExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextButton(
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
    );
  }
}
