import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:example/custom_grouped_example.dart';
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
      home:CustomGroupedExample(),
    );
  }
}
class MainExample extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _MainExampleState();
  }

}
class _MainExampleState extends State<MainExample>{

  GlobalKey<SimpleGroupedCheckboxState<int>> checkboxKey,
      circulairekey,
      mutlicheckboxKey;
  GlobalKey<SimpleGroupedChipsState<int>> mutliChipsKey;

  @override
  void initState() {
    super.initState();
    checkboxKey = GlobalKey<SimpleGroupedCheckboxState<int>>();
    circulairekey = GlobalKey<SimpleGroupedCheckboxState<int>>();
    mutlicheckboxKey = GlobalKey<SimpleGroupedCheckboxState<int>>();
    mutliChipsKey = GlobalKey<SimpleGroupedChipsState<int>>();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(

        body: NestedScrollView(
          headerSliverBuilder: (ctx,v){
            return [
              SliverAppBar(
                title: Text("SingleGroupedCheckbox"),
                floating: true,
                pinned: true,
              )
            ];
          },
          body: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SimpleGroupedCheckbox<int>(
                  key: checkboxKey,
                  groupTitle:"Basic",
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
                  checkFirstElement: false,
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
                  itemsTitle: ["1 ", "2 ", "4 ", "5 "],
                  values: [1, 2, 4, 5],
                  preSelection: [2, 5, 4],
                  activeColor: Colors.green,
                  groupTitle: "Mutiple selection",
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
                  values: [1, 2, 3, 4, 5, 6, 7],
                  itemTitle: [
                    "text1",
                    "text2",
                    "text3",
                    "text4",
                    "text5",
                    "text6",
                    "text7"
                  ],
                  backgroundColorItem: Colors.black26,
                  isScrolling: true,
                ),
                Text("grouped switch"),
                SimpleGroupedSwitch<int>(
                  itemsTitle: ["1","2","3"],
                  values: [1,2,3],
                  disableItems: [2],
                  textStyle: TextStyle(fontSize: 16),
                  activeColor:Colors.red,
                  isMutlipleSelection: false,
                ),
              ],
            ),
          ),
        )
    );
  }

}
