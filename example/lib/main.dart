import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'list_of_grouped.dart';
import 'custom_grouped_example.dart';
import 'package:flutter/material.dart';

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
      home:MainExample(),
    );
  }
}
class MainExample extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _MainExampleState();
  }

}
class _MainExampleState extends State<MainExample> with TickerProviderStateMixin{

  GlobalKey<SimpleGroupedCheckboxState<int>> checkboxKey,
      circulairekey,mutlipleKey,
      mutlicheckboxKey;
  GlobalKey<SimpleGroupedChipsState<int>> mutliChipsKey;
  TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController=TabController(initialIndex: 0,length: 4,vsync: this);
    checkboxKey = GlobalKey<SimpleGroupedCheckboxState<int>>();
    circulairekey = GlobalKey<SimpleGroupedCheckboxState<int>>();
    mutlicheckboxKey = GlobalKey<SimpleGroupedCheckboxState<int>>();
    mutliChipsKey = GlobalKey<SimpleGroupedChipsState<int>>();
    mutlipleKey = GlobalKey<SimpleGroupedCheckboxState<int>>();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          title: Text("examples"),
          bottom: TabBar(
            controller: tabController,
            onTap: (index){
              tabController.index=index;
            },
            tabs: <Widget>[
              Text("example 1"),
              Text("example 2"),
              Text("example 3"),
              Text("example 4"),
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
                    key: checkboxKey,
                    //groupTitle:"Basic",
                    onItemSelected: (data){
                      print(data);
                      if(data==1){
                        checkboxKey.currentState.disabledItems(["5"]);
                      }else if(data==4){
                        checkboxKey.currentState.enabledItems(["5","2"]);
                        checkboxKey.currentState.disabledItems(["1"]);
                      }else if(data == 2 ){
                        checkboxKey.currentState.enabledItems(["1"]);
                      }
                    },
                    disableItems: ["5"],
                    itemsTitle: ["1", "2", "4", "5"],
                    values: [1, 2, 4, 5],
                    activeColor: Colors.red,
                    checkFirstElement: true,
                    multiSelection: false,
                  ),
                  SimpleGroupedCheckbox<int>(
                    key: circulairekey,
                    groupTitle: "Circulaire Checkbox",
                    itemsTitle: ["1 ", "2 ", "4 ", "5 "],
                    values: [1, 2, 4, 5],
                    isCirculaire: true,
                    activeColor: Colors.blue,
                    isLeading: true,
                    checkFirstElement: false,
                    multiSelection: false,
                  ),
                  SimpleGroupedCheckbox<int>(
                    key: mutlicheckboxKey,
                    itemsTitle: List.generate(10, (index) => "$index"),
                    values: List.generate(10, (index) => index),
                    preSelection: [2, 5, 4],
                    activeColor: Colors.green,
                    groupTitle: "expanded multiple checkbox selection",
                    checkFirstElement: false,
                    multiSelection: true,
                    onItemSelected: (data){
                      print(data);
                    },
                    isExpandableTitle: true,
                  ),
                  Divider(),
                  SimpleGroupedCheckbox<int>(
                    key: mutlipleKey,
                    itemsTitle: List.generate(10, (index) => "$index"),
                    values: List.generate(10, (index) => index),
                    preSelection: [2, 5, 4],
                    activeColor: Colors.green,
                    checkFirstElement: false,
                    multiSelection: true,
                    onItemSelected: (data){
                      print(data);
                    },
                    isExpandableTitle: false,
                  ),
                  Divider(),
                  SimpleGroupedChips<int>(
                    key: mutliChipsKey,
                    values: List.generate(7, (index) => index),
                    itemTitle: List.generate(7, (index) => "chip_text_$index"),
                    backgroundColorItem: Colors.black26,
                    isScrolling: false,
                    isMultiple: false,
                    onItemSelected: (values){
                      print(values);
                    },
                  ),
                  Text("grouped switch"),
                  SimpleGroupedSwitch<int>(
                    itemsTitle: List.generate(10, (index) => "$index"),
                    values: List.generate(10, (index) => index),
                    disableItems: [2],
                    textStyle: TextStyle(fontSize: 16),
                    activeColor:Colors.red,
                    isMultipleSelection: false,
                    onItemSelected: (values){
                      print(values);
                    },
                  ),
                ],
              ),
            ),
            CustomGroupedExample(),
            Column(children: <Widget>[
              FlatButton(
                onPressed: ()async {
                 var values= await showDialogGroupedCheckbox(
                    context: context,
                    cancelDialogText: "cancel",
                    isMultiSelection: true,
                    itemsTitle: List.generate(15, (index) => "$index"),
                    submitDialogText: "select",
                    dialogTitle:Text("example dialog") ,
                    values: List.generate(15, (index) => index)
                  );
                 if(values!=null){
                   print(values);
                 }

                },
                child: Text("show dialog checkbox grouped"),
              ),
            ],),
            ListOfGrouped(),
          ],
        )
    );
  }

}
