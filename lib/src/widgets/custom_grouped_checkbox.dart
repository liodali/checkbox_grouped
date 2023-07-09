import 'package:checkbox_grouped/src/common/base_grouped_widget.dart';
import 'package:flutter/material.dart';

import 'package:checkbox_grouped/src/common/custom_state_group.dart';
import 'package:checkbox_grouped/src/common/item.dart';
import 'package:checkbox_grouped/src/common/utilities.dart';
import 'package:checkbox_grouped/src/controller/custom_group_controller.dart';

/// display  custom groupedCheckbox with your custom check behavior and custom child widget
///
/// [controller] : Text Widget that describe Title of group checkbox
///
/// [groupTitle] : Text Widget that describe Title of group checkbox
///
/// [itemBuilder] :  builder function  takes an index and checked state of widget
///
/// [values] : list of values
///
/// [itemExtent] : same as [itemExtent] of [ListView]
///
class CustomGroupedCheckbox<T> extends BaeCustomGrouped {
  final Widget? groupTitle;
  final CustomItemIndexedWidgetBuilder itemBuilder;
  final double? itemExtent;
  final bool _isGrid;
  final bool isScroll;
  final SliverGridDelegate? gridDelegate;

  CustomGroupedCheckbox({
    super.key,
    required super.controller,
    this.groupTitle,
    required this.itemBuilder,
    required super.values,
    this.isScroll = false,
    this.itemExtent,
  })  : this._isGrid = false,
        this.gridDelegate = null;

  CustomGroupedCheckbox.grid({
    super.key,
    required super.controller,
    this.groupTitle,
    SliverGridDelegate gridDelegate = const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
    ),
    this.isScroll = false,
    required this.itemBuilder,
    required super.values,
  })  : this._isGrid = true,
        this.gridDelegate = gridDelegate,
        this.itemExtent = 0.0;

  @override
  CustomGroupedCheckboxState createState() => CustomGroupedCheckboxState();

  static CustomGroupController of<T>(
    BuildContext context, {
    bool nullOk = false,
  }) {
    final CustomGroupedCheckboxState<T>? result =
        context.findAncestorStateOfType<CustomGroupedCheckboxState<T>>();
    if (nullOk || result != null) return result!.widget.controller;
    throw FlutterError.fromParts(<DiagnosticsNode>[
      ErrorSummary(
          'CustomGroupedCheckbox.of() called with a context that does not contain an CustomGroupedCheckbox.'),
      ErrorDescription(
          'No CustomGroupedCheckbox ancestor could be found starting from the context that was passed to CustomGroupedCheckbox.of().'),
      context.describeElement('The context used was')
    ]);
  }
}

class CustomGroupedCheckboxState<T> extends CustomStateGroup<T?, CustomGroupedCheckbox> {
  SliverChildBuilderDelegate? childrenDelegate;



  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final builder = (ctx, index) {
      return ValueListenableBuilder<CustomItem<T?>>(
        valueListenable: items[index],
        builder: (ctx, value, child) {
          return ItemWidget(
            child: widget.itemBuilder(
              context,
              index,
              items[index].value.checked!,
              items[index].value.isDisabled,
            ),
            value: items[index].value.checked,
            callback: (v) {
              if (!items[index].value.isDisabled) changeSelection(index, v);
            },
          );
        },
      );
    };
    Widget child = ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemBuilder: builder,
      itemCount: items.length,
      itemExtent: widget.itemExtent,
    );
    Axis axisScroll = Axis.vertical;
    if (widget._isGrid) {
      child = GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: widget.gridDelegate!,
        itemBuilder: builder,
        itemCount: items.length,
        shrinkWrap: true,
      );
      //axisScroll = Axis.horizontal;
    }
    final customWidget = ScrollConfiguration(
      behavior: ScrollBehavior(),
      child: child,
    );
    return widget.groupTitle != null
        ? SingleChildScrollView(
            scrollDirection: axisScroll,
            physics:
                widget.isScroll ? AlwaysScrollableScrollPhysics() : NeverScrollableScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                widget.groupTitle!,
                customWidget,
              ],
            ),
          )
        : customWidget;
  }

  @override
  void changeSelection(int index, bool value) {
    if (widget.controller.isMultipleSelection) {
      if (!itemsSelections.value.contains(widget.values[index])) {
        if (value) {
          itemsSelections.value = List.from(itemsSelections.value)..add(widget.values[index]);
        }
      } else {
        if (!value) {
          itemsSelections.value = List.from(itemsSelections.value)..remove(widget.values[index]);
        }
      }
      items[index].value = items[index].value.copy(checked: value);
      if (streamListValues.hasListener) streamListValues.add(itemsSelections.value);
    } else {
      if (value) {
        if (itemSelected.value != null) {
          if (itemSelected.value != items[index].value.data) {
            int indexPrevious = widget.values.indexOf(itemSelected.value);
            items[indexPrevious].value = items[indexPrevious].value.copy(checked: false);
          }
        }
        itemSelected.value = widget.values[index];
        items[index].value = items[index].value.copy(checked: value);
      }
      if (streamOneValue.hasListener) streamOneValue.add(itemSelected.value);
    }
  }

  @override
  dynamic selection() {
    if (widget.controller.isMultipleSelection) {
      return itemsSelections.value;
    }
    return itemSelected.value;
  }

  @override
  void reset() {
    items.forEach((element) {
      final item = element;
      item.value = element.value.copy(checked: false);
    });
    if (widget.controller.isMultipleSelection) {
      itemsSelections.value.clear();

      if (streamOneValue.hasListener) streamListValues.add(itemsSelections.value);
    } else {
      itemSelected.value = null;
      if (streamOneValue.hasListener) streamOneValue.add(itemSelected.value);
    }
  }
}

@visibleForTesting
class ItemWidget extends StatelessWidget {
  final Widget? child;
  final Function(bool)? callback;
  final bool? value;

  ItemWidget({
    this.child,
    this.callback,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => callback!(!value!),
      child: AbsorbPointer(
        absorbing: true,
        child: child,
      ),
    );
  }
}
