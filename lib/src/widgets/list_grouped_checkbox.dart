import 'package:checkbox_grouped/src/common/grouped_style.dart';
import 'package:checkbox_grouped/src/common/utilities.dart';
import 'package:checkbox_grouped/src/controller/group_controller.dart';
import 'package:checkbox_grouped/src/controller/list_group_controller.dart';
import 'package:checkbox_grouped/src/widgets/simple_grouped_checkbox.dart';
import 'package:checkbox_grouped/src/widgets/simple_grouped_chips.dart';
import 'package:checkbox_grouped/src/widgets/simple_grouped_switch.dart';
import 'package:flutter/material.dart';

/// [ListGroupedCheckbox]
///
///
/// this widget display list of simple widget of groupedCheckbox
///
///
/// [controller]              :  (required) List Group Controller to recuperate selection
///
/// [titles]                  :  (required) A list of strings that describes each checkbox group
///
/// [values]                  : list of values in each group
///
/// [onSelectedGroupChanged]  : callback to get selected items,it fred when the user selected items or deselect items
///
/// [subTitles]               : A list of strings that describes second Text
///
/// [groupTitles]             : Text Widget that describe Title of group checkbox
///
/// [disabledValues]          : specifies which item should be disabled
///
/// [titleGroupedTextStyle]   : (TextStyle) style title text of each group
///
/// [titleGroupedAlignment]   : (Alignment) Alignment of  title text of each group
///
/// [mapItemGroupedType]      : (Map) to define type each item in list (chip,switch,default)
class ListGroupedCheckbox<T> extends StatefulWidget {
  final ListGroupController controller;
  final bool isScrollable;
  final List<List<T>> values;
  final List<List<String>> titles;
  final List<String> groupTitles;
  final List<String> subTitles;
  final List<List<T>> disabledValues;
  final TextStyle? titleGroupedTextStyle;
  final Alignment titleGroupedAlignment;
  final OnGroupChanged<T>? onSelectedGroupChanged;
  final Map<int, GroupedType>? mapItemGroupedType;
  final ChipGroupStyle chipsStyle;

  ListGroupedCheckbox({
    required this.controller,
    required this.titles,
    required this.groupTitles,
    required this.values,
    this.isScrollable = true,
    this.titleGroupedTextStyle,
    this.titleGroupedAlignment = Alignment.centerLeft,
    this.chipsStyle = const ChipGroupStyle.minimize(),
    this.mapItemGroupedType,
    this.subTitles = const [],
    this.onSelectedGroupChanged,
    this.disabledValues = const [],
    Key? key,
  })  : assert(values.length == titles.length),
        assert(groupTitles.length == titles.length),
        assert(controller.isMultipleSelectionPerGroup.isEmpty ||
            controller.isMultipleSelectionPerGroup.length == titles.length),
        super(key: key);

  @override
  ListGroupedCheckboxState<T> createState() => ListGroupedCheckboxState<T>();
}

class ListGroupedCheckboxState<T> extends State<ListGroupedCheckbox> {
  int len = 0;
  List<GroupController> listControllers = [];

  @override
  void initState() {
    super.initState();
    len = widget.values.length;
    widget.controller.init(this);
    listControllers.addAll(
      List.generate(
        widget.values.length,
        (index) => GroupController(
          initSelectedItem: widget.controller.initSelectedValues.isNotEmpty
              ? widget.controller.initSelectedValues[index]
              : [],
          isMultipleSelection:
              widget.controller.isMultipleSelectionPerGroup.isNotEmpty
                  ? widget.controller.isMultipleSelectionPerGroup[index]
                  : false,
        ),
      ),
    );
  }

  Future<List<T>> getAllValues() async {
    List<T> resultList = List.empty(growable: true);
    var values = listControllers.map((e) => e.selectedItem).where((v) {
      if (v != null) {
        if (v is List && v.isNotEmpty) {
          return true;
        } else if (v is T) {
          return true;
        }
      }
      return false;
    }).toList();
    for (var v in values) {
      if (v is List)
        resultList.addAll(v.cast<T>());
      else {
        if (v != null) resultList.add(v);
      }
    }

    return resultList;
  }

  Future<List<T>> getValuesByIndex(int index) async {
    assert(index < len);
    List<T> resultList = List.empty();
    resultList.addAll(listControllers[index].selectedItem);
    return resultList;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: widget.isScrollable
          ? AlwaysScrollableScrollPhysics()
          : NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          for (var index = 0; index < len; index++) ...[
            if (widget.mapItemGroupedType != null &&
                widget.mapItemGroupedType!.isNotEmpty) ...[
              if (widget.mapItemGroupedType!.containsKey(index)) ...[
                switch (widget.mapItemGroupedType![index]) {
                  (GroupedType.Chips) => Column(
                      children: [
                        ListTile(
                          title: Text(
                            widget.groupTitles[index],
                            style: widget.titleGroupedTextStyle ??
                                Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      fontSize: 16,
                                    ),
                          ),
                        ),
                        SimpleGroupedChips<T>(
                          controller: listControllers[index],
                          itemsTitle: widget.titles[index],
                          values: widget.values[index] as List<T>,
                          chipGroupStyle: widget.chipsStyle,
                          onItemSelected: widget.onSelectedGroupChanged != null
                              ? (selection) async {
                                  final list = await getAllValues();
                                  widget.onSelectedGroupChanged!(list);
                                }
                              : null,
                        )
                      ],
                    ),
                  (GroupedType.Switch) => Column(
                      children: [
                        ListTile(
                          title: Text(
                            widget.groupTitles[index],
                            style: widget.titleGroupedTextStyle ??
                                Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontSize: 16,
                                    ),
                          ),
                        ),
                        SimpleGroupedSwitch<T>(
                          controller: listControllers[index],
                          itemsTitle: widget.titles[index],
                          values: widget.values[index] as List<T>,
                          activeColor: Theme.of(context).primaryColor,
                          onItemSelected: widget.onSelectedGroupChanged != null
                              ? (selection) async {
                                  final list = await getAllValues();
                                  widget.onSelectedGroupChanged!(list);
                                }
                              : null,
                        ),
                      ],
                    ),
                  _ => SimpleGroupedCheckbox<T>(
                      controller: listControllers[index],
                      itemsTitle: widget.titles[index],
                      values: widget.values[index] as List<T>,
                      disableItems: widget.disabledValues.isNotEmpty
                          ? widget.disabledValues[index] as List<T>
                          : [],
                      groupTitle: widget.groupTitles[index],
                      groupTitleAlignment: widget.titleGroupedAlignment,
                      onItemSelected: widget.onSelectedGroupChanged != null
                          ? (selection) async {
                              final list = await getAllValues();
                              widget.onSelectedGroupChanged!(list);
                            }
                          : null,
                    )
                }
              ] else ...[
                SimpleGroupedCheckbox<T>(
                  controller: listControllers[index],
                  itemsTitle: widget.titles[index],
                  values: widget.values[index] as List<T>,
                  disableItems: widget.disabledValues.isNotEmpty
                      ? widget.disabledValues[index] as List<T>
                      : [],
                  groupTitle: widget.groupTitles[index],
                  groupTitleAlignment: widget.titleGroupedAlignment,
                  onItemSelected: widget.onSelectedGroupChanged != null
                      ? (selection) async {
                          final list = await getAllValues();
                          widget.onSelectedGroupChanged!(list);
                        }
                      : null,
                ),
              ],
            ] else ...[
              SimpleGroupedCheckbox<T>(
                controller: listControllers[index],
                itemsTitle: widget.titles[index],
                values: widget.values[index] as List<T>,
                disableItems: widget.disabledValues.isNotEmpty
                    ? widget.disabledValues[index] as List<T>
                    : [],
                groupTitle: widget.groupTitles[index],
                groupTitleAlignment: widget.titleGroupedAlignment,
                onItemSelected: widget.onSelectedGroupChanged != null
                    ? (selection) async {
                        final list = await getAllValues();
                        widget.onSelectedGroupChanged!(list);
                      }
                    : null,
              ),
            ],
          ],
        ],
      ),
    );
  }
}
