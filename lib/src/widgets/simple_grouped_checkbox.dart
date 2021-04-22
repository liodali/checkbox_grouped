import 'package:auto_size_text/auto_size_text.dart';
import 'package:checkbox_grouped/src/controller/group_controller.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../common/item.dart';
import '../common/state_group.dart';

typedef onChanged = Function(dynamic selected);

/// display  simple groupedCheckbox
/// [controller] :  (required) Group Controller to recuperate selection Items and disable or enableItems
/// [itemsTitle] :  (required) A list of strings that describes each checkbox button
/// [values] : list of values
/// [onItemSelected] :(callback) callback to receive item selected when it selected directly(callback) callback to receive item selected when it selected directly
/// [itemsSubTitle] : A list of strings that describes second Text
/// [groupTitle] : Text Widget that describe Title of group checkbox
/// [groupTitleStyle] : Text Style  that describe style of title of group checkbox
/// [activeColor] : the color to use when this checkbox button is selected
/// [disableItems] : specifies which item should be disabled
/// [checkFirstElement] : make first element in list checked
/// [isLeading] : same as [itemExtent] of [ListView]
/// [isExpandableTitle] : enable group checkbox to be expandable
/// [helperGroupTitle] : (bool) hide/show checkbox in title to help all selection or deselection,use it when you want to disable checkbox in groupTitle default:`true`
/// [groupTitleAlignment] : (Alignment) align title of checkbox group checkbox default:`Alignment.center`
class SimpleGroupedCheckbox<T> extends StatefulWidget {
  final GroupController controller;
  final List<String> itemsTitle;
  final onChanged? onItemSelected;
  final String? groupTitle;
  final AlignmentGeometry groupTitleAlignment;
  final TextStyle? groupTitleStyle;
  final List<String> itemsSubTitle;
  final Color? activeColor;
  final List<T> values;
  final List<String> disableItems;
  final bool checkFirstElement;
  final bool isLeading;
  final bool isExpandableTitle;
  final bool helperGroupTitle;

  SimpleGroupedCheckbox({
    Key? key,
    required this.controller,
    required this.itemsTitle,
    required this.values,
    this.onItemSelected,
    this.groupTitle,
    this.groupTitleAlignment = Alignment.center,
    this.groupTitleStyle,
    this.itemsSubTitle = const [],
    this.disableItems = const [],
    this.activeColor,
    this.checkFirstElement = false,
    this.isLeading = false,
    this.isExpandableTitle = false,
    this.helperGroupTitle = true,
  })  : assert(values.length == itemsTitle.length),
        assert(itemsSubTitle.isNotEmpty
            ? itemsSubTitle.length == itemsTitle.length
            : true),
        assert(
            (groupTitle == null && !isExpandableTitle) ||
                (groupTitle != null &&
                        groupTitle.isNotEmpty &&
                        isExpandableTitle ||
                    groupTitle != null &&
                        groupTitle.isNotEmpty &&
                        !isExpandableTitle),
            "you cannot make isExpandable without textTitle"),
        assert(
            disableItems.isEmpty ||
                disableItems
                    .takeWhile((c) => itemsTitle.contains(c))
                    .isNotEmpty,
            "you cannot disable items doesn't exist in itemsTitle"),
        super(key: key);

  static SimpleGroupedCheckboxState? of<T>(BuildContext context,
      {bool nullOk = false}) {
    final SimpleGroupedCheckboxState<T>? result =
        context.findAncestorStateOfType<SimpleGroupedCheckboxState<T>>();
    if (nullOk || result != null) return result;
    throw FlutterError.fromParts(<DiagnosticsNode>[
      ErrorSummary(
          'SimpleGroupedCheckbox.of() called with a context that does not contain an SimpleGroupedCheckbox.'),
      ErrorDescription(
          'No SimpleGroupedCheckbox ancestor could be found starting from the context that was passed to SimpleGroupedCheckbox.of().'),
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
  void initState() {
    super.initState();
    init(
      values: widget.values as List<T>,
      checkFirstElement: widget.checkFirstElement,
      disableItems: widget.disableItems,
      itemsTitle: widget.itemsTitle,
      multiSelection: widget.controller.isMultipleSelection,
      preSelection: widget.controller.initSelectedItem?.cast<T>(),
    );
    widget.controller.init(this);
  }

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
              activeColor: widget.activeColor,
              isLeading: widget.isLeading,
              itemSubTitle: widget.itemsSubTitle.isNotEmpty
                  ? widget.itemsSubTitle[i]
                  : null,
              isMultipleSelection: widget.controller.isMultipleSelection,
            );
          },
        );
      },
    );
    if (widget.groupTitle != null && widget.isExpandableTitle) {
      return _ExpansionCheckBoxList(
        listChild: childListChecks,
        titleWidget: _TitleGroupedCheckbox(
          title: widget.groupTitle,
          titleStyle: widget.groupTitleStyle,
          isMultiSelection: widget.controller.isMultipleSelection,
          alignment: widget.groupTitleAlignment,
          checkboxTitle: widget.helperGroupTitle
              ? ValueListenableBuilder(
                  valueListenable: valueTitle,
                  builder: (ctx, dynamic selected, _) {
                    return Checkbox(
                      tristate: true,
                      value: selected,
                      activeColor: widget.activeColor,
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
            titleStyle: widget.groupTitleStyle,
            isMultiSelection: widget.controller.isMultipleSelection,
            alignment: widget.groupTitleAlignment,
            checkboxTitle: widget.helperGroupTitle
                ? ValueListenableBuilder(
                    valueListenable: valueTitle,
                    builder: (ctx, dynamic selected, _) {
                      return Checkbox(
                        tristate: true,
                        value: selected,
                        activeColor: widget.activeColor,
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
    return selectedValue.value as T;
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
  final Function(int i, dynamic v) onChangedCheckBox;

  _CheckboxItem({
    this.isMultipleSelection = false,
    this.isLeading = false,
    this.activeColor,
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
          minFontSize: 12,
        ),
        subtitle: itemSubTitle != null
            ? AutoSizeText(
                itemSubTitle!,
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
        minFontSize: 12,
      ),
      subtitle: itemSubTitle != null
          ? AutoSizeText(
              itemSubTitle!,
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
    return ExpansionPanelList(
      expansionCallback: (index, value) {
        setState(() {
          isExpanded = !value;
        });
      },
      children: [
        ExpansionPanel(
          isExpanded: isExpanded,
          headerBuilder: (ctx, value) {
            return widget.titleWidget!;
          },
          body: widget.listChild!,
        ),
      ],
    );
  }
}
