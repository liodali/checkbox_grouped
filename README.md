# checkbox_grouped

grouping checkbox, recuperate the actual selection,make multiple selection

## Getting Started

## Installing

Add the following to your `pubspec.yaml` file:

    dependencies:
      checkbox_grouped: ^0.1.2+12

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
|`itemsTitle`           |(required) A list of strings that describes each Radio button. Each label must be distinct.   |
|`values`               |Values contains in each element.   |
|`direction`            |Specifies the direction to display elements. Either `Direction.Horizontal` or `Direction.Vertical`.  |
|`checkFirstElement`    |`make first element in list checked`.  |
|`multiSelection`       |`enable multiple selection`.  |
