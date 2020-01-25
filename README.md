# checkbox_grouped

grouping checkbox, recuperate the actual selection,make multiple selection

## Getting Started

## Installing

Add the following to your `pubspec.yaml` file:

    dependencies:
      checkbox_grouped: ^0.1.2+17

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
|`preSelection`         | A list of values that you want to be initially selected.   |
|`values`               |(required) Values contains in each element.   |
|`direction`            |Specifies the direction to display elements. Either `Direction.Horizontal` or `Direction.Vertical`.  |
|`checkFirstElement`    |`make first element in list checked`.  |
|`multiSelection`       |`enable multiple selection`.  |
