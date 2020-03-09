# checkbox_grouped
![pub](https://img.shields.io/badge/pub-v0.2.6-orange) ![GitHub](https://img.shields.io/github/license/liodali/checkbox_grouped)

    * grouping checkbox
    * grouping chips
    * recuperate the actual selection
    * make multiple selection

## Getting Started

## Installing

Add the following to your `pubspec.yaml` file:

    dependencies:
		checkbox_grouped: ^0.2.6



## Simple Usage
#### Creating a basic `SimpleGroupedCheckbox`

    SimpleGroupedCheckbox<int>(
                    key: checkboxKey,
                    itemsTitle: ["1 " ,"2 ","4 ","5 "],
                    values: [1,2,4,5],
                    activeColor: Colors.red,
                    direction: Direction.Horizontal,
                    checkFirstElement: false,
                    multiSelection: false,
                  );
### Declare GlobalKey to get selection

`  GlobalKey<SimpleGroupedCheckboxState<int>> checkboxKey = GlobalKey<SimpleGroupedCheckboxState<int>>();`

### Get current selection

` checkboxKey.currentState.selection() `

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
|`direction`            |Specifies the direction to display elements. Either `Direction.Horizontal` or `Direction.Vertical`.  |
|`checkFirstElement`    |`make first element in list checked`.  |
|`multiSelection`       |`enable multiple selection`.  |
|`isCirculaire`         |`enable to use circulaire checkbox`.  |
|`isExpandableTitle`    |`enable group checkbox to be expandable `.  |
|`textTitle`            |`Text title for group checkbox`.  |

## Chip grouped Usage

#### Creating a basic `SimpleGroupedChips`

    SimpleGroupedChips<int>(
                    key: chipKey,
                    values: [1,2,4,5],
                    values: [1,2,3,4,5,6,7],
                    itemTitle: ["1 " ,"2 ","4 ","5 ","6","7"],
                    backgroundColorItem: Colors.black26,
                  );
### Declare GlobalKey to get selection

`  GlobalKey<SimpleGroupedChipsState<int>> chipKey = GlobalKey<SimpleGroupedChipsState<int>>();`

### Get current selection

` chipKey.currentState.selection() `

####  `SimpleGroupedCheckbox`
|   Properties          |  Description |
|-----------------------|--------------|
|`itemsTitle`           |(required) A list of strings that describes each chip button. Each label must be distinct.   |
|`disabledItems`        | Specifies which item should be disabled. The strings passed to this must match the Titles  |
|`preSelection`         | A list of values that you want to be initially selected.   |
|`values`               |(required) Values contains in each element.   |
|`onItemSelected`       | Call when users make  selection    |
|`backgroundColorItem`  |`the background color for each item`.  |
|`selectedColorItem`    |`the background color to use when item is  selected`.  |
|`textColor`            |`the color to use for each text of item `.  |
|`selectedTextColor`    |`the color to use for the selected text of item`.  |
|`selectedIcon`         |`the icon to use when item is selected`.  |
|`isScrolling`          |`enable horizontal scrolling`.  |
|`isMultiple`           |`enable multiple selection`.  |
			     

