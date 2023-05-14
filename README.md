# checkbox_grouped
![pub](https://img.shields.io/badge/pub-v1.9.0-blue) ![GitHub](https://img.shields.io/github/license/liodali/checkbox_grouped)

    * grouped (checkbox/radioButton)
    * customisable grouped checkbox
    * grouped chips
    * grouped switch
    * recuperate the actual selection
    * make multiple selection
    * dialogGroupedCheckbox
    * list of groupedCheckbox
    * list of customisable groupedCheckbox
    * select/deselect items pragrammatically

## Getting Started
<img src="https://github.com/liodali/checkbox_grouped/blob/master/exampleCheckbox.gif?raw=true" alt="checkboxGrouped examples"><br>


## Installing

Add the following to your `pubspec.yaml` file:

    dependencies:
		checkbox_grouped: ^1.9.0



## Simple Usage
#### Creating a basic `SimpleGroupedCheckbox`

```dart
    SimpleGroupedCheckbox<int>(
            controller: controller,
            itemsTitle: ["1" ,"2","4","5"],
            values: [1,2,4,5],
            groupStyle: GroupStyle(
                  activeColor: Colors.red,
                  itemTitleStyle: TextStyle(
                  fontSize: 13
                 )
               ),
            checkFirstElement: false,
    )
```
### Declare GroupController to get selection and enabled/disabled Items

```dart
GroupController controller = GroupController();
```

####  `GroupController`
|   Properties          |  Description |
|-----------------------|--------------|
|`isMultipleSelection`  | (bool) enable multiple selection  in grouped checkbox (default:false).  |
|`initSelectedItem`     | (List) A Initialize list of values that will be selected in grouped.   |


### Get current selection

```dart
final selectedItems = controller.selectedItem;
```
### enable items

```dart
    controller.enableAll();
```
### disable all items

```dart
    controller.disableAll();
```

### enabled items

```dart
controller.enabledItemsByValues(List<T> values); 
```
----------
```dart
controller.enabledItemsByTitles(List<String> itemsTitles); 
```

### disable item

```dart
controller.disabledItemsByValues(List<T> values);
```

```dart
controller.disabledItemsByTitles(List<String> items)
```

### listener to changed values
> listener will be removed automatically when widget call dispose

```dart
controller.listen((v) {
      print("$v");
    });
```
### select/selectValues
> select one item in single selection or multiple selection

> selectValues work only in group when isMultiSelection is true

```dart
controller.select(value);
or
controller.selectValues([value]);
```

### selectAll/selectValues
> select all or some items in multiple selection group
```dart
controller.selectAll();
or
controller.selectValues([values]);
```
### deselectAll/deselectValues
> deselect all or some items in multiple selection group
```dart
controller.deselectAll();
or
controller.deselectValues([values]);
```


#### NOTICE

* those method `disabledItems` and `enabledItems` has been removed
* if you are using complex object in values , you need to implement operator == and hashcode

####  `SimpleGroupedCheckbox`
|   Properties          |  Description |
|-----------------------|--------------|
|`controller`           | (required)  Group Controller to recuperate selectionItems and disable or enableItems.  |
|`activeColor`          | (deprecated) The color to use when a CheckBox is checked.  |
|`itemsTitle`           | (required) A list of strings that describes each checkbox button. Each label must be distinct.   |
|`itemsSubTitle`        | A list of strings that describes second Text.   |
|`onItemSelected`       | Callback fire when the user make  selection    |
|`disableItems`         | Specifies which item should be disabled. The strings passed to this must match the Titles  |
|`values`               | (required) Values contains in each element.   |
|`checkFirstElement`    | `make first element in list checked`.  |
|`isExpandableTitle`    | `enable group checkbox to be expandable `.  |
|`groupTitle`           | `Text title for group checkbox`.  |
|`groupTitleStyle`      | (deprecated) `TextStyle of title for group checkbox`.  |
|`helperGroupTitle`     | `(bool) hide/show checkbox in title to help all selection or de-selection,use it when you want to disable checkbox in groupTitle default:true `.  |
|`groupTitleAlignment`  | `(Alignment) alignment of group title in group checkbox`.  |
|`groupStyle`           | `(GroupStyle) the style that should be applied on GroupedTitle,ItemTile,SubTitle`.  |

## Customisable Checkbox Grouped

#### Creating a basic `CustomGroupedCheckbox`

```dart
    CustomGroupedCheckbox<int>(
            controller:customController,
            groupTitle: "Custom GroupedCheckbox",
            itemBuilder: (ctx,index,value,isDisabled){
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
        )
```

### Declare CustomGroupController to get selection ,enabled/disable items

```dart
 CustomGroupController controller = CustomGroupController();
```

### Get current selection

```dart
final selectedItem = controller.selectedItem;
```

### enable items

```dart
    controller.enabledItems([value]);
```

### disable items

```dart
    controller.disabledItems([value]);

```
### listen to changed values

```dart
controller.listen((value){
 print(value);
})
```

####  `CustomGroupedCheckbox`
|   Properties          |  Description |
|-----------------------|--------------|
|`controller`           | (required) Custom Group Controller to recuperate selectionItems and disable or enableItems.  |
|`groupTitle`           | `widget title for group checkbox`.              |
|`itemBuilder`          | (required) `Called to build children.`          |
|`values`               | (required) `Values contains in each element.`   |
|`itemExtent`           | ` The extent the children are forced to have in the main axis`  |
|`isScroll`             | (bool) ` To make list of item scrollable `  |


####  `CustomGroupedCheckbox.grid`
|   Properties          |  Description |
|-----------------------|--------------|
|`controller`           | (required) Custom Group Controller to recuperate selectionItems and disable or enableItems.  |
|`groupTitle`           | `widget title for group checkbox`.              |
|`itemBuilder`          | (required) `Called to build children.`          |
|`values`               | (required) `Values contains in each element.`   |
|`isScroll`             | (bool) ` To indicate that the  list of children scrollable `  |
|`gridDelegate`         | (SliverGridDelegate) `a delegate that controls the layout of the children`   | 


## Chip grouped Usage

#### Creating a basic `SimpleGroupedChips`

```dart
SimpleGroupedChips<int>(
                    controller: controller,
                    values: [1,2,3,4,5,6,7],
                    itemTitle: ["1" ,"2","4","5","6","7"],
                    chipGroupStyle: ChipGroupStyle.minimize(
                         backgroundColorItem: Colors.red[400],
                         itemTitleStyle: TextStyle(
                         fontSize: 14,
                      ),
                    ),
                  )
```
### Declare GroupController to get selection and enabled/disabled Items

```dart
GroupController controller = GroupController();
```

####  `GroupController`
|   Properties          |  Description |
|-----------------------|--------------|
|`isMultipleSelection`  | (bool) enable multiple selection  in grouped checkbox (default:false).  |
|`initSelectedItem`     | (List) A Initialize list of values that will be selected in grouped.   |
|`chipGroupStyle`       | (ChipGroupStyle) A Initialize list of values that will be selected in grouped.   |


### Get current selection

```dart
final selectedItems = controller.selectedItem;
```
### enabled items

```dart
controller.enabledItemsByValues(List<T> values); 
```
----------
```dart
controller.enabledItemsByTitles(List<String> itemsTitles); 
```

### disable item

```dart
controller.disabledItemsByValues(List<T> values);
```

```dart
controller.disabledItemsByTitles(List<String> items)
```

####  `SimpleGroupedChip`
|   Properties          |  Description |
|-----------------------|--------------|
|`controller`           | (required) `controller to recuperate selectionItems and disable or enableItems.`  |
|`itemsTitle`           | (required) `A list of strings that describes each chip button. Each label must be distinct.`   |
|`disabledItems`        | `Specifies which item should be disabled. The strings passed to this must match the Titles`  |
|`values`               | (required) Values contains in each element.   |
|`onItemSelected`       | `Callback when users make  selection  or deselection`  |
|`backgroundColorItem`  | (deprecated) `the background color for each item`.  |
|`selectedColorItem`    | (deprecated) `the background color to use when item is  selected`.  |
|`textColor`            | (deprecated) `the color to use for each text of item `.  |
|`selectedTextColor`    | (deprecated) `the color to use for the selected text of item`.  |
|`selectedIcon`         | (deprecated) `the icon to use when item is selected`.  |
|`disabledColor`         | (deprecated) `the Color that uses when the item is disabled`  |
|`isScrolling`          |`enable horizontal scrolling`.  |
|`chipGroupStyle`       | (ChipGroupStyle) `the style that uses to customize  item chip `  |

## Switch grouped Usage

#### Creating a basic `SimpleGroupedSwitch`

```dart
SimpleGroupedSwitch<int>(
                    controller: controller,
                    values: [1,2,4,5],
                    itemsTitle: ["1 " ,"2 ","4 ","5 ","6","7"],
                    groupStyle: SwitchGroupStyle(
                        itemTitleStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                       ),
                     activeColor: Colors.red,
                  ),  
             )
```
### Declare GroupController to get selection and enabled/disabled Items

```dart
GroupController controller = GroupController();
```

####  `GroupController`
|   Properties          |  Description |
|-----------------------|--------------|
|`isMultipleSelection`  | (bool) enable multiple selection  in grouped checkbox (default:false).  |
|`initSelectedItem`     | (List) A Initialize list of values that will be selected in grouped.   |


### Get current selection

```dart
final selectedItems = controller.selectedItem;
```
### enabled items

```dart
controller.enabledItemsByValues(List<T> values); 
```
----------
```dart
controller.enabledItemsByTitles(List<String> itemsTitles); 
```

### disable item

```dart
controller.disabledItemsByValues(List<T> values);
```

```dart
controller.disabledItemsByTitles(List<String> items)
```

####  `SimpleGroupedSwitch`
|   Properties          |  Description |
|-----------------------|--------------|
|`controller`           | (required) Group Controller to recuperate selectionItems and disable or enableItems.  |
|`itemsTitle`           | (required) A list of strings that describes each chip button. Each label must be distinct.   |
|`values`               | (required) Values contains in each element.   |
|`disableItems`         | Specifies which item should be disabled. The value passed to this must match the values list |
|`onItemSelected`       | Call when users make  selection  or deselection  |
|`groupStyle`           | (SwitchGroupStyle) the style that will customize text,switch  |


## showDialogGroupedCheckbox

> display  groupedCheckbox inside dialog
> return values selected

#### Creating a basic `showDialogGroupedCheckbox`

```dart
showDialogGroupedCheckbox(
                        context: context,
                        cancelDialogText: "cancel",
                        isMultiSelection: true,
                        itemsTitle: List.generate(15, (index) => "$index"),
                        submitDialogText: "select",
                        dialogTitle:Text("example dialog") ,
                        values: List.generate(15, (index) => index)
                      )
```


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

## ListGroupedCheckbox

> display  list of groupedCheckbox
> return all values selected
>
### Declare ListGroupController to get all item selected or get item selected by group index

```dart
ListGroupController controller = ListGroupController();
```

####  `ListGroupController`
|   Properties                  |  Description |
|------------------------------ |--------------|
|`isMultipleSelectionPerGroup`  | (List<bool>)  enable multiple selection  in each grouped checkbox. |
|`initSelectedValues`           | (List) A Initialize list of values on each group of checkbox that will be selected in group.   |


### Get current selection
* get all selection

```dart
final selectedItems = controller.allSelectedItems;
```
* get all selection by group

```dart
final selectedItems = controller.selectedItemsByGroupIndex(indexGroup);
```
### enable items

```dart
    controller.enableAll(int indexGroup);
```
### disable all items

```dart
    controller.disableAll(int indexGroup);
```
### enabled items

```dart
controller.enabledItemsByValues(int indexGroup,List<T> values); 
```
----------
```dart
controller.enabledItemsByTitles(int indexGroup,List<String> itemsTitles); 
```

### disable item

```dart
controller.disabledItemsByValues(int indexGroup,List<T> values);
```

```dart
controller.disabledItemsByTitles(int indexGroup,List<String> items)
```



#### Creating a basic `ListGroupedCheckbox`


```dart
                ListGroupedCheckbox(
                        controller: listController,
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
                        mapItemGroupedType: {
                          1: GroupedType.Chips,
                        },
                      )
```


####  `ListGroupedCheckbox`
|   Properties                        |  Description |
|-------------------------------------|--------------------------------------------------------------------------------------------------|
|`controller`                         | (required) manage the ListGroupedCheckbox.  |
|`groupTitles`                        | (required)Text title for group checkbox in each groupedCheckbox.  |
|`titles`                             | (required) A list of list of strings that describes each checkbox button. Each label must be distinct in groupedCheckbox.   |
|`values`                             | (required) Values contains in each element in each groupedCheckbox.   |
|`subTitles`                          | A list of list strings that describes second Text in each groupedChckbox.   |
|`isScrollable`                       | (bool) make the parent widget scrollable or disable it (default:true).   |
|`onSelectedGroupChanged`             | CallBack to get all selected items when users  make select new items or deselect items  |
|`disabledValues`                     | A nested list of string ,specifies which item should be disabled in each groupedCheckbox. The strings passed to this must match the Titles  |
|`titleGroupedAlignment`              | (Alignment) align text title of each group of checkbox  |
|`titleGroupedTextStyle`              | (TextStyle) style text title of each group   |
|`mapItemGroupedType`                 | (Map) define type of each group can be chips/switch/(checkbox or radio)  |

------------------

##ListCustomGroupedCheckbox
> display  list of groupedCheckbox
> return all values selected
>
### Declare ListGroupController to get all item selected or get item selected by group index

```dart
ListGroupController controller = ListGroupController();
```

####  `ListCustomGroupController`
|   Properties                  |  Description |
|------------------------------ |--------------|
|`isMultipleSelectionPerGroup`  | (List<bool>)  enable multiple selection  in each grouped checkbox. |
|`initSelectedValuesByGroup`    | (List) A Initialize list of values on each group of checkbox that will be selected in group.   |


### Get current selection
* get all selection
1) list
```dart
final selectedItems = controller.allSelectedItems;
```
2) map
```dart
final selectedItems = controller.mapSelectedItems;
```
* get all selection by group

```dart
final selectedItems = controller.selectedItemsByGroupIndex(indexGroup);
```

####  `ListCustomGroupedCheckbox`
|   Properties                        |  Description |
|-------------------------------------|--------------------------------------------------------------------------------------------------|
|`controller`                         | (required) manage the ListGroupedCheckbox.  |
|`children`                           | (required) list of CustomIndexedWidgetBuilder to return widget of items for each group,should be non null widgets  |
|`groupTitles`                        | A list of String for group checkbox in each CustomGrouped.  |
|`groupTitlesWidget`                  | A list of list of widgets that describes custom Title for each group.   |
|`listValuesByGroup`                  | (required) Values contains in each element in each CustomGroupedCheckbox.   |
|`isScrollable`                       | (bool) make the parent widget scrollable or disable it (default:true).   |
|`onSelectedGroupChanged`             | CallBack to get all selected items when one of item hit it make select new items or deselect items  |
|`titleGroupedAlignment`              | (Alignment) align text title of each group  |
|`titleGroupedTextStyle`              | (TextStyle) style text for title of each group   |


### basic example 
```dart
final controller =
ListCustomGroupController(isMultipleSelectionPerGroup: [true, false]);
final data = [
  List<_User>.generate(
    10,
        (i) => _User(
      name: faker.person.name(),
      email: faker.internet.email(),
    ),
  ),
  List<String>.generate(
    10,
        (i) => faker.person.name(),
  )
]
ListCustomGroupedCheckbox(
      controller: controller,
      onSelectedGroupChanged: (values) {
        print(values);
      },
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
                (data[0][index] as _User).name,
              ),
              subtitle: Text(
                (data[0][index] as _User).email,
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
        }),
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
                        data[1][index],
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
                      crossAxisCount: 3, 
                      crossAxisSpacing: 5.0,
                  )
              ),
      ],
      listValuesByGroup: data,
    )


```

MIT Licences