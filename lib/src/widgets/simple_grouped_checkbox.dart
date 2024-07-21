import 'package:auto_size_text/auto_size_text.dart';
import 'package:checkbox_grouped/src/common/base_grouped_widget.dart';
import 'package:checkbox_grouped/src/common/grouped_style.dart';
import 'package:checkbox_grouped/src/controller/group_controller.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';

import '../common/item.dart';
import '../common/state_group.dart';

typedef OnChanged = Function(dynamic selected);

/// [SimpleGroupedCheckbox]
///
///
/// This widget responsible to display a simple Checkboxs grouped,where [GroupController]
/// responsible to retrieve the selection
/// and configure the grouped is mutliChoice ot single choice.
///
/// Using [disableItems] we can disable items from beginning
/// and we can use API  [GroupController.enabledItemsByValues]
/// or [GroupController.enabledItemsByTitles]
/// to undisable them depend on the use case wanted
///
///
/// [controller] :  (required) Group Controller to recuperate selection Items and disable or enableItems
///
/// [itemsTitle] :  (required) A list of strings that describes each checkbox button
///
/// [values] : list of values
///
/// [onItemSelected] :(callback) callback to receive item selected when it selected directly(callback) callback to receive item selected when it selected directly
///
/// [itemsSubTitle] : A list of strings that describes second Text
///
/// [groupTitle] : Text Widget that describe Title of group checkbox
///
/// [groupStyle] : (GroupStyle) the style that should be applied on GroupedTitle,ItemTile,SubTitle
///
/// [disableItems] : specifies which item should be disabled, we use title to disable items, if items are not in [itemsTitle], will be ignored
///
class SimpleGroupedCheckbox<T> extends BaseSimpleGrouped<T> {
  final OnChanged? onItemSelected;
  final String? groupTitle;
  final List<String> itemsSubTitle;
  final GroupStyle groupStyle;

  SimpleGroupedCheckbox({
    super.key,
    required super.controller,
    required super.itemsTitle,
    required super.values,
    this.groupStyle = const GroupStyle(),
    this.onItemSelected,
    this.groupTitle,
    this.itemsSubTitle = const [],
    super.disableItems = const [],
  })  : assert(values.length == itemsTitle.length),
        assert(itemsSubTitle.isNotEmpty
            ? itemsSubTitle.length == itemsTitle.length
            : true),
        assert(
            (groupTitle == null && groupStyle is! ExpandableGroupStyle) ^
                (groupTitle != null &&
                    groupTitle.isNotEmpty &&
                    groupStyle is ExpandableGroupStyle) ^
                (groupTitle != null &&
                    groupTitle.isNotEmpty &&
                    groupStyle is! ExpandableGroupStyle) ,
               
            "you cannot make isExpandable without textTitle");

  static GroupController? of<T>(BuildContext context, {bool nullOk = false}) {
    final SimpleGroupedCheckboxState<T>? result =
        context.findAncestorStateOfType<SimpleGroupedCheckboxState<T>>();
    if (nullOk || result != null) return result!.widget.controller;
    throw FlutterError.fromParts(<DiagnosticsNode>[
      ErrorSummary(
          'SimpleGroupedCheckbox.of() called with a context that does not contain an SimpleGroupedCheckbox.'),
      ErrorDescription(
          'No SimpleGroupedCheckbox ancestor could be found starting from the context that was passed to SimpleGroupedCheckbox.of().'),
      context.describeElement('The context used was')
    ]);
  }

  static GroupStyle? groupStyleOf<T>(BuildContext context,
      {bool nullOk = false}) {
    final SimpleGroupedCheckboxState<T>? result =
        context.findAncestorStateOfType<SimpleGroupedCheckboxState<T>>();
    if (nullOk || result != null) return result!.widget.groupStyle;
    throw FlutterError.fromParts(<DiagnosticsNode>[
      ErrorSummary(
          'SimpleGroupedCheckbox.groupStyleOf() called with a context that does not contain an SimpleGroupedCheckbox.'),
      ErrorDescription(
          'No SimpleGroupedCheckbox ancestor could be found starting from the context that was passed to SimpleGroupedCheckbox.groupStyleOf().'),
      context.describeElement('The context used was')
    ]);
  }

  @override
  SimpleGroupedCheckboxState<T> createState() =>
      SimpleGroupedCheckboxState<T>();
}

class SimpleGroupedCheckboxState<T>
    extends StateGroup<T, SimpleGroupedCheckbox> {
  @override
  Widget build(BuildContext context) {
    Widget childListChecks = ListView.builder(
      itemCount: notifierItems.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemBuilder: (ctx, i) {
        return ValueListenableBuilder<Item>(
          valueListenable: notifierItems[i],
          builder: (ctx, item, child) {
            return _CheckboxItem<T?>(
              index: i,
              item: item,
              onChangedCheckBox: (index, v) {
                changeSelection(i, v);
              },
              selectedValue: selectedValue.value,
              value: widget.values[i],
              activeColor: widget.groupStyle.activeColor,
              itemStyle: widget.groupStyle.itemTitleStyle?.copyWith(
                color: item.checked!
                    ? widget.groupStyle.activeColor
                    : widget.groupStyle.itemTitleStyle?.color,
              ),
              isLeading: widget.groupStyle.isLeading,
              itemSubTitle: widget.itemsSubTitle.isNotEmpty
                  ? widget.itemsSubTitle[i]
                  : null,
              itemSubStyle: widget.groupStyle.subItemTitleStyle,
              isMultipleSelection: widget.controller.isMultipleSelection,
            );
          },
        );
      },
    );
    if (widget.groupTitle != null &&
        widget.groupStyle is ExpandableGroupStyle) {
      return _ExpansionCheckBoxList(
        listChild: childListChecks,
        titleWidget: _TitleGroupedCheckbox(
          title: widget.groupTitle,
          titleStyle: widget.groupStyle.groupTitleStyle,
          isMultiSelection: widget.controller.isMultipleSelection,
          alignment: widget.groupStyle.groupTitleAlignment,
          checkboxTitle: widget.groupStyle.helperGroupTitle
              ? ValueListenableBuilder(
                  valueListenable: valueTitle,
                  builder: (ctx, dynamic selected, _) {
                    return Checkbox(
                      tristate: true,
                      value: selected,
                      activeColor: widget.groupStyle.activeColor,
                      onChanged: (v) {
                        setState(() {
                          if (v != null) valueTitle.value = v;
                        });
                      },
                    );
                  },
                )
              : null,
          callback: setChangedAllItemsCallback,
        ),
      );
    }
    if (widget.groupTitle != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _TitleGroupedCheckbox(
            title: widget.groupTitle,
            titleStyle: widget.groupStyle.groupTitleStyle,
            isMultiSelection: widget.controller.isMultipleSelection,
            alignment: widget.groupStyle.groupTitleAlignment,
            checkboxTitle: widget.groupStyle.helperGroupTitle
                ? ValueListenableBuilder(
                    valueListenable: valueTitle,
                    builder: (ctx, dynamic selected, _) {
                      return Checkbox(
                        tristate: true,
                        value: selected,
                        activeColor: widget.groupStyle.activeColor,
                        onChanged: (v) {
                          if (v != null) valueTitle.value = v;
                        },
                      );
                    },
                  )
                : null,
            callback: setChangedAllItemsCallback,
          ),
          childListChecks,
        ],
      );
    }
    return childListChecks;
  }

  /// callback title grouped when clicked it disabled all selected or select all elements
  void setChangedAllItemsCallback() {
    if (valueTitle.value == null) {
      valueTitle.value = true;
      selectionsValue.value = List.from(selectionsValue.value)
        ..addAll(widget.values
                .where((elem) => selectionsValue.value.contains(elem) == false)
            as Iterable<T>);
    } else if (valueTitle.value!) {
      valueTitle.value = false;
      selectionsValue.value = [];
    } else if (!valueTitle.value!) {
      valueTitle.value = true;
      selectionsValue.value = List.from(selectionsValue.value)
        ..addAll(widget.values as List<T>);
    } else {
      valueTitle.value = true;
    }
    //callback
    if (widget.onItemSelected != null) widget.onItemSelected!(selection());
    notifierItems
        .where((e) => e.value.checked != valueTitle.value)
        .toList()
        .forEach((element) {
      int index = widget.itemsTitle.indexOf(element.value.title);
      Item item = element.value;
      item.checked = valueTitle.value;
      notifierItems[index].value = item.copy();
    });
  }

  @override
  selection() {
    if (widget.controller.isMultipleSelection) {
      return selectionsValue.value;
    }
    return selectedValue.value;
  }

  @override
  void changeSelection(int index, value) {
    Item item = Item(
      title: notifierItems[index].value.title,
      checked: notifierItems[index].value.checked,
      isDisabled: notifierItems[index].value.isDisabled,
    );
    if (widget.controller.isMultipleSelection) {
      if (!selectionsValue.value.contains(widget.values[index])) {
        if (value) {
          selectionsValue.value = List.from(selectionsValue.value)
            ..add(widget.values[index]);
        }
      } else {
        if (!value) {
          selectionsValue.value = List.from(selectionsValue.value)
            ..remove(widget.values[index]);
        }
      }
      if (selectionsValue.value.length == widget.values.length) {
        valueTitle.value = true;
      } else if (selectionsValue.value.length == 0) {
        valueTitle.value = false;
      } else {
        valueTitle.value = null;
      }
      //_items[index].checked = v;

      item.checked = value;
      if (streamListValues.hasListener) {
        streamListValues.add(selection());
      }
    } else {
      selectedValue.value = value;
      var notifierPrevious =
          notifierItems.firstWhereOrNull((element) => element.value.checked!);
      if (notifierPrevious != null) {
        var indexPrevious = notifierItems.indexOf(notifierPrevious);
        var previous = Item(
          title: notifierPrevious.value.title,
          checked: notifierPrevious.value.checked,
          isDisabled: notifierPrevious.value.isDisabled,
        );
        previous.checked = false;
        notifierItems[indexPrevious].value = previous;
      }
      item.checked = true;
      notifierItems[index].value = item;
    }
    notifierItems[index].value = item;
    if (widget.onItemSelected != null) widget.onItemSelected!(selection());
    if (streamOneValue.hasListener) {
      streamOneValue.add(selection());
    }
  }
}

class _TitleGroupedCheckbox extends StatelessWidget {
  final String? title;
  final TextStyle? titleStyle;
  final AlignmentGeometry alignment;
  final bool isMultiSelection;
  final VoidCallback? callback;
  final Widget? checkboxTitle;

  _TitleGroupedCheckbox({
    this.title,
    this.titleStyle,
    required this.isMultiSelection,
    this.callback,
    this.checkboxTitle,
    this.alignment = Alignment.center,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isMultiSelection && title != null && checkboxTitle != null) {
      return ListTile(
        title: Text(
          title!,
          style: titleStyle ??
              TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
        ),
        onTap: () {
          callback!();
        },
        leading: AbsorbPointer(
          child: Container(
            width: 32,
            height: 32,
            child: checkboxTitle,
          ),
        ),
      );
    }
    if (title != null)
      return ListTile(
        title: Align(
          alignment: alignment,
          child: Text(
            title!,
            style: titleStyle ??
                TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      );

    return SizedBox.shrink();
  }
}

class _CheckboxItem<T> extends StatelessWidget {
  final bool isMultipleSelection;
  final bool isLeading;
  final T value;
  final T selectedValue;
  final Item item;
  final String? itemSubTitle;
  final int index;
  final Color? activeColor;
  final TextStyle? itemStyle;
  final TextStyle? itemSubStyle;
  final Function(int i, dynamic v) onChangedCheckBox;

  _CheckboxItem({
    this.isMultipleSelection = false,
    this.isLeading = false,
    this.activeColor,
    this.itemStyle,
    this.itemSubStyle,
    required this.item,
    this.itemSubTitle,
    required this.value,
    required this.selectedValue,
    required this.index,
    required this.onChangedCheckBox,
  });

  @override
  Widget build(BuildContext context) {
    if (!isMultipleSelection) {
      return RadioListTile<T>(
        groupValue: selectedValue,
        onChanged: item.isDisabled
            ? null
            : (v) {
                onChangedCheckBox(index, v);
              },
        activeColor: activeColor ?? Theme.of(context).primaryColor,
        title: AutoSizeText(
          "${item.title}",
          style: itemStyle,
          minFontSize: 9,
        ),
        subtitle: itemSubTitle != null
            ? AutoSizeText(
                itemSubTitle!,
                style: itemSubStyle,
                minFontSize: 11,
              )
            : null,
        value: value,
        selected: item.checked!,
        dense: itemSubTitle != null ? true : false,
        isThreeLine: itemSubTitle != null ? true : false,
        controlAffinity: isLeading
            ? ListTileControlAffinity.leading
            : ListTileControlAffinity.trailing,
      );
    }

    return CheckboxListTile(
      onChanged: item.isDisabled
          ? null
          : (v) {
              //setState(() {
              onChangedCheckBox(index, v);
              //});
            },
      activeColor: activeColor ?? Theme.of(context).primaryColor,
      title: AutoSizeText(
        item.title,
        style: itemStyle,
        minFontSize: 9,
      ),
      subtitle: itemSubTitle != null
          ? AutoSizeText(
              itemSubTitle!,
              style: itemSubStyle,
              minFontSize: 11,
            )
          : null,
      value: item.checked,
      dense: itemSubTitle != null ? true : false,
      isThreeLine: itemSubTitle != null ? true : false,
      controlAffinity: isLeading
          ? ListTileControlAffinity.leading
          : ListTileControlAffinity.trailing,
    );
  }
}

class _ExpansionCheckBoxList extends StatefulWidget {
  final Widget? listChild;
  final Widget? titleWidget;

  _ExpansionCheckBoxList({
    this.listChild,
    this.titleWidget,
  });

  @override
  State<StatefulWidget> createState() => _ExpansionCheckBoxListState();
}

class _ExpansionCheckBoxListState extends State<_ExpansionCheckBoxList> {
  late bool isExpanded;

  @override
  void initState() {
    super.initState();
    isExpanded = false;
  }

  @override
  void didUpdateWidget(_ExpansionCheckBoxList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.listChild != widget.listChild) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final groupStyle = SimpleGroupedCheckbox.groupStyleOf(context);
    return ExpansionPanelList(
      expansionCallback: (index, value) {
        setState(() {
          isExpanded = value;
        });
      },
      children: [
        ExpansionPanel(
          isExpanded: isExpanded,
          canTapOnHeader: groupStyle != null &&
              groupStyle is ExpandableGroupStyle &&
              groupStyle.canTapOnHeader,
          headerBuilder: (ctx, value) {
            return widget.titleWidget!;
          },
          body: widget.listChild!,
        ),
      ],
    );
  }
}
