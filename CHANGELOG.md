## [1.4.1] - fix bugs 
*  fix bugs in simple grouped 
*  fix bugs in init selected of custom grouped 
## [1.4.0] - add new method in `BaseController` and `BaseListController`
* add `enabledAll` and `disabledAll` in `BaseController` and `BaseListController`
* add unit test  for `enabledAll` and `disabledAll`
* fix bug
## [1.3.0] - show different type of group checkbox in list grouped
* show  multiple type (chips,switch,(radio/checkbox)) inside list of grouped
* fix bugs
## [1.2.0-nullsafety.0] - add listener to groupController
* create new method `listen` to get selected value from controller out side of widget
## [1.1.0-nullsafety.1] - change gif example
## [1.1.0-nullsafety.0] - grid custom grouped checkbox
* add grid custom grouped checkbox
* add `listen` method to add listener in changed data in real time
* add `isScroll` attribute in custom grouped checkbox
* fix bugs
## [1.0.1-nullsafety.0] - fix bugs,refactoring code 
*  fix bugs in chips grouped 
*  ameliorate null safety generated code 
*  fix bugs unit test 
## [1.0.0-nullsafety.1] - remove unnecessary files
* change gis example 
* remove asset of flare 
## [1.0.0-nullsafety.0] -nullsafety migration
* remove dependencies that doesn't support null safety
* remove circulaire checkbox for now until will reimplemented 
* nullsafety migration
## [0.8.1] -improve readme 
* change example 
* fix bug
## [0.8.0+1] -improve readme 
*  add docs,fix readme 
## [0.8.0] -improve readability of the code and  remove working with globalKey 
*  add GroupController to control simple grouped checkbox/switch/chips 
*  add CustomGroupController to control custom grouped checkbox 
*  add ListGroupController to control list grouped checkbox 
*  add enable/disable items in all groups checkbox 
*  modify example with new changes 
*  add and update widget unit tests 
## [0.7.0+1] - add groupTitleAlignment,helperGroupTitle checkbox 
*  add helperGroupTitle to show or hid checkbox in groupTile 
*  add groupTitleAlignment to change alignment of groupTitle  of 2 new method disableItemsByTitles 
## [0.7.0] - add new method to disable and enabled checkbox 
*  deprecation of the method disabledItems and enabledItems
*  creation  of 2 new method disabledItemsByTitles and disabledItemsByValues to disable checkbox items
*  creation  of 2 new method enabledItemsByTitles and enabledItemsByValues to enable checkbox items
## [0.6.3] - fix null exception 
*  fix selection method in custom_grouped_checkbox
* fix url gif in readme
## [0.6.2] - add gif to readme 
*  add new gif to show basics examples of the library 
## [0.6.2] - pre-selection in single choice 
*  add possibility to pre-selection any element in single chice 
## [0.6.1+1] - fix color of groupTitle in dark mode 
*  remove color in textStyle of groupTitle 
*  add textStyle to modify Style of groupTitle 
## [0.6.1] - add callback to collect data from list of grouped widget 
*  create typedef onGroupChanged and add it to widget to collect data inside widget 
## [0.6.0+1] - fix bug 
*  fix bug of unchanged state of checkbox in titleGrouped 
*  remove widget in simpleGroupedCheckbox (example 1) 
## [0.6.0] - add new widget:ListGroupedCheckbox 
*  ListGroupedCheckbox to manage list of groupedCheckbox,retrieve selected data in one call 
*  add example for ListGroupedCheckbox 
*  add test widget for ListGroupedCheckbox 
## [0.5.2] - optimize simple grouped switch
*  use valueNotifier to manage selection in simple grouped switch 
*  make physics of ListView non Scrollable 
*  update kotlin version in android project of the example  
## [0.5.1] - optimize simple grouped chips 
*  use valueNotifier to manage selection in simple grouped chips 
*  change main example  
*  fix bug in test simple grouped chips 
*  add test in multiple choice for simple grouped chips 
## [0.5.0+1] - fix bug in simple grouped chips 
*  fix bug related to assert 
## [0.5.0] - improve performance and create testsWidget 
*  improve performance of simple groupedCheckbox:use valueNotifier,remove setState 
*  fix and recreate test widget of simple groupedCheckbox 
## [0.4.5+7] - fix issues 
*  update dependencies 
*  remove scrollable listview in expanded  simple checkbox 
*  add docs api 
## [0.4.5+6] - fix issues 
*  change column in customGroupedCheckbox to improve performance if you have long list to be checked 
*  change column in simpleGroupedswitch to improve performance if you have long list to be checked 
*  add docs api 
## [0.4.5+3] - fix issues 
*  change column in expansionPanelList to improve performance if you have long list to be checked 
## [0.4.5+2] - fix issues 
*  when simpleGroupedCheckbox isExpandable,make isExpand = true as default behavior 
*  fix selection in circulaire SimpleCheckbox 
## [0.4.5+1] - fix issues 
*  remove some deprecated api 
## [0.4.5] - make grouped checkbox dialog 
* create function to show groupedcheckbox inside dialog
## [0.4.1] - changing single selection in grouped checkbox to radioButton  
* change checkbox to radiobutton for singleselection
* create new typedef CustomIndexedWidgetBuilder
* change type groupTitle from String to Widget
## [0.4.0] - changing custom grouped checkbox 
*  change CustomScrollView with simple Column
*  create new typedef CustomIndexedWidgetBuilder
*  change type groupTitle from String to Widget
## [0.3.5] - custom grouped checkbox 
* create customisable grouped checkbox
* fix error
## [0.3.2] - refactoring code 
## [0.3.1+3] - fix errors 
## [0.3.1+2] - remove direction groupedcheckbox 
* make groupedcheckbox vertical by default
* change wrap  widget by column
## [0.3.1+1] - change name textTitle to groupTitle, 
## [0.3.1] - initialise an disabled items, 
* you can make item disabled
## [0.3.0+1] -  modify readme, 
## [0.3.0] -  simple grouped switch, 
* preselection items 
* enable multi selection 
* callback when user click 
## [0.2.7+1] -  remove duplicated code, 
## [0.2.7] -  callback to disable/enable items in checkbox  grouped 
## [0.2.6] -  disabled items in grouped chip 
## [0.2.5+1] - fix error in pubspec
## [0.2.5] - add new feature to chip grouped 
    *  onItemSelected Call when users make  selection
 
## [0.2.5] - add new feature to chip grouped 
    *  onItemSelected Call when users make  selection
 
## [0.2.5] - add new feature to chip grouped 
    *  onItemSelected Call when users make  selection
 
## [0.2.5] - add new feature to chip grouped 
    *  onItemSelected Call when users make  selection
 
## [0.2.5] - add new feature to chip grouped 
    *  onItemSelected Call when users make  selection
 
## [0.2.4+1] - fix error
## [0.2.4] - add new feature
    *  onItemSeelected Call when users make  selection
    *  disable item
## [0.2.2+1] - fix readme
## [0.2.2] - new feature
    * add isExpandable to make grouped checkbox expanded from title
## [0.2.1+1] - fix err

## [0.2.1] - fix err
    * add selection function in groupedchips that missed in previous version
## [0.2.0+1] - fix readme

## [0.2.0] - add new feature

    * add chip group

## [0.1.4] - add new feature

    * add Title for each group
    * make Title selected for multiple selection

## [0.1.3+1] - fix readme

## [0.1.3] - add new feature
  * circulaire checkbox

## [0.1.2+17] - fix CHANGELOG

## [0.1.2+16] - fix readme file

## [0.1.2+15] - add new feature

    * add pre-selection element for multiple selection
    * add example section

## [0.1.2+14] - fix First Element selection.

## [0.1.2+13] - fix README.

## [0.1.2+12] - fix CHANGELOG.

## [0.1.2+11] - fix errors.

## [0.1.2+1] -  fix errors.

## [0.1.2] -  fix errors.

## [0.1.1]

* Add example in example/

## [0.1.0] -  INITIAL RELEASE

* contain simple and basic widget to grouping checkbox.
