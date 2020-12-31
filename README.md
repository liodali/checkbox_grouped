# checkbox_grouped
![pub](https://img.shields.io/badge/pub-v0.6.3-orange) ![GitHub](https://img.shields.io/github/license/liodali/checkbox_grouped)

    * grouped (checkbox/radioButton)
    * customisable grouped checkbox
    * grouped chips
    * grouped switch
    * recuperate the actual selection
    * make multiple selection
    * dialogGroupedCheckbox
    * lit of groupedCheckbox

## Getting Started
<img src="https://github.com/liodali/checkbox_grouped/blob/master/CheckboxGroupExamples.gif" alt="checkboxGrouped examples">
## Installing

Add the following to your `pubspec.yaml` file:

    dependencies:
		checkbox_grouped: ^0.6.3



## Simple Usage
#### Creating a basic `SimpleGroupedCheckbox`

    SimpleGroupedCheckbox<int>(
                    key: checkboxKey,
                    itemsTitle: ["1" ,"2","4","5"],
                    values: [1,2,4,5],
                    activeColor: Colors.red,
                    checkFirstElement: false,
                    multiSelection: false,
                  );
### Declare GlobalKey to get selection

`  GlobalKey<SimpleGroupedCheckboxState<int>> checkboxKey = GlobalKey<SimpleGroupedCheckboxState<int>>();`

### Get current selection

` checkboxKey.currentState.selection() `
### enabled items

` checkboxKey.currentState.enabledItems(List<String> items) `
### disable item

` checkboxKey.currentState.disabledItems(List<String> items) `

####  `SimpleGroupedCheckbox`
|   Properties          |  Description |
|-----------------------|--------------|
|`activeColor`          |The color to use when a CheckBox is checked.  |
|`itemsTitle`           |(required) A list of strings that describes each checkbox button. Each label must be distinct.   |
|`itemsSubTitle`        | A list of strings that describes second Text.   |
|`onItemSelected`       | Call when users make  selection    |
|`disableItems`         | Specifies which item should be disabled. The strings passed to this must match the Titles  |
|`preSelection`         | A list of values that you want to be initially selected.   |
|`values`               |(required) Values contains in each element.   |
|`checkFirstElement`    |`make first element in list checked`.  |
|`multiSelection`       |`enable multiple selection`.  |
|`isCirculaire`         |`enable to use circulaire checkbox`.  |
|`isExpandableTitle`    |`enable group checkbox to be expandable `.  |
|`groupTitle`           |`Text title for group checkbox`.  |
|`groupTitleStyle`      |`TextStyle of title for group checkbox`.  |

## Customisable Checkbox Grouped

#### Creating a basic `CustomGroupedCheckbox`

    CustomGroupedCheckbox<int>(
            groupTitle: "Custom GroupedCheckbox",
            itemBuilder: (ctx,index,v){
            return Card(
                child: Row(
                    children: <Widget>[
                        Expanded(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text("$index"),
                            ),
                        ),
                        Opacity(
                              opacity: v?1:0,
                              child: Icon(Icons.check,
                                color: Colors.green,
                                size: 24,
                              ),
                         ),
                      ],
                   ),
                );
            },
            itemCount: 10,
            values: List<int>.generate(10, (i)=>i),
        ),

### Declare GlobalKey to get selection

`  GlobalKey<CustomGroupedCheckboxState<int>> _customCheckBoxKey = GlobalKey<CustomGroupedCheckboxState<int>>();`

### Get current selection

` _customCheckBoxKey.currentState.selection() `

####  `CustomGroupedCheckbox`
|   Properties          |  Description |
|-----------------------|--------------|
|`groupTitle`           |`widget title for group checkbox`.              |
|`itemBuilder`          |(required) `Called to build children.`          |
|`values`               |(required) `Values contains in each element.`   |
|`itemCount`            |(required)` The total number of children `      |
|`itemExtent`           |` The extent the children are forced to have in the main axis`  |
|`isMultipleSelection`  |`enable multiple selection`.                    |


## Chip grouped Usage

#### Creating a basic `SimpleGroupedChips`

    SimpleGroupedChips<int>(
                    key: chipKey,
                    values: [1,2,3,4,5,6,7],
                    itemTitle: ["1" ,"2","4","5","6","7"],
                    backgroundColorItem: Colors.black26,
                  );
### Declare GlobalKey to get selection

`  GlobalKey<SimpleGroupedChipsState<int>> chipKey = GlobalKey<SimpleGroupedChipsState<int>>();`

### Get current selection

` chipKey.currentState.selection() `

####  `SimpleGroupedChip`
|   Properties          |  Description |
|-----------------------|--------------|
|`itemsTitle`           |(required) A list of strings that describes each chip button. Each label must be distinct.   |
|`disabledItems`        | Specifies which item should be disabled. The strings passed to this must match the Titles  |
|`preSelection`         | A list of values that you want to be initially selected.   |
|`values`               |(required) Values contains in each element.   |
|`onItemSelected`       | Callback when users make  selection    |
|`backgroundColorItem`  |`the background color for each item`.  |
|`selectedColorItem`    |`the background color to use when item is  selected`.  |
|`textColor`            |`the color to use for each text of item `.  |
|`selectedTextColor`    |`the color to use for the selected text of item`.  |
|`selectedIcon`         |`the icon to use when item is selected`.  |
|`isScrolling`          |`enable horizontal scrolling`.  |
|`isMultiple`           |`enable multiple selection`.  |
			     
## Switch grouped Usage

#### Creating a basic `SimpleGroupedSwitch`

    SimpleGroupedSwitch<int>(
                    key: chipKey,
                    values: [1,2,4,5],
                    itemsTitle: ["1 " ,"2 ","4 ","5 ","6","7"],
                    isMutlipleSelection: false,
                  );
### Declare GlobalKey to get selection

`  GlobalKey<SimpleGroupedSwitchState<int>> switchKey = GlobalKey<SimpleGroupedSwitchState<int>>();`

### Get current selection

` switchKey.currentState.selection() `

####  `SimpleGroupedSwitch`
|   Properties          |  Description |
|-----------------------|--------------|
|`itemsTitle`           |(required) A list of strings that describes each chip button. Each label must be distinct.   |
|`preSelection`         | A list of values that you want to be initially selected.   |
|`values`               |(required) Values contains in each element.   |
|`disableItems`         | Specifies which item should be disabled. The value passed to this must match the values list |
|`onItemSelected`       | Call when users make  selection    |
|`isMutlipleSelection`  |`enable multiple selection`.  |


## showDialogGroupedCheckbox

> display  groupedCheckbox inside dialog
> return values selected

#### Creating a basic `showDialogGroupedCheckbox`

     showDialogGroupedCheckbox(
                        context: context,
                        cancelDialogText: "cancel",
                        isMultiSelection: true,
                        itemsTitle: List.generate(15, (index) => "$index"),
                        submitDialogText: "select",
                        dialogTitle:Text("example dialog") ,
                        values: List.generate(15, (index) => index)
                      );


####  `showDialogGroupedCheckbox`
|   Properties                  |  Description |
|-------------------------------|--------------|
|`dialogTitle`                  | `(required) Text Widget that describe Title of dialog`.  |
|`itemsTitle`                   | `(required) Values contains in each element`.   |
|`values`                       | `(required) list of values`. |
|`initialSelectedValues`        | `list of initial values that you want to be selected`.    |
|`isDismissible`                |`enable multiple selection`.  |
|`cancelDialogText`             |`(string) label for cancelButton`.  |
|`submitDialogText`             |`(string) label for submitButton`.  |
|`isMultiSelection`             |`enable multiple selection`.  |

## ListGroupedCheckbox  *(experimental)

> display  list of groupedCheckbox
> return all values selected

### Declare GlobalKey to get selected values

`  GlobalKey<ListGroupedCheckboxState> globalKey = GlobalKey<ListGroupedCheckboxState>();`

### Get all values selected

` await globalKey.currentState.getAllValues() `


#### Creating a basic `ListGroupedCheckbox`

     
            ListGroupedCheckbox(
                        key: globalKey,
                        groupTitles: List.generate(3, (index) => "groupe $index"),
                        values: List.generate(
                          3,
                          (i) =>
                              List.generate(5, (j) => "${(i + Random().nextInt(100)) * j}"),
                        ),
                        titles: List.generate(
                          3,
                          (i) => List.generate(5, (j) => "Title:$i-$j"),
                        ),
                        isMultipleSelectionPerGroup: [true, false, true],
                      ),


     


####  `showDialogGroupedCheckbox`
|   Properties                        |  Description |
|-------------------------------------|--------------------------------------------------------------------------------------------------|
|`groupTitles`                        | (required)Text title for group checkbox in each groupedCheckbox.  |
|`titles`                             | (required) A list of list of strings that describes each checkbox button. Each label must be distinct in groupedCheckbox.   |
|`values`                             | (required) Values contains in each element in each groupedCheckbox.   |
|`subTitles`                          | A list of list strings that describes second Text in each groupedChckbox.   |
|`onSelectedGroupChanged`             | CallBack to get all selected items when users  new   selection instantly  |
|`disabledValues`                     | A nested list of string ,specifies which item should be disabled in each groupedCheckbox. The strings passed to this must match the Titles  |
|`preSelectedValues`                  | A list of list values that you want to be initially selected of each groupedCheckbox.   |
|`isMultipleSelectionPerGroup`        | A list of boolean to enable multiple selection of each groupedCheckbox.  |
