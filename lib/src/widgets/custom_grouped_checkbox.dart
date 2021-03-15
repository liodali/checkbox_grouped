import '../controller/custom_group_controller.dart';
import '../common/item.dart';
import 'package:flutter/material.dart';

import '../common/custom_state_group.dart';

/// Signature for a function that creates a widget for a given index,isChecked and disabled, e.g., in a
/// list.
typedef CustomIndexedWidgetBuilder = Widget Function(
  BuildContext builder,
  int index,
  bool? checked,
  bool? isDisabled,
);

/// display  custom groupedCheckbox with your custom check behavior and custom child widget
/// [controller] : Text Widget that describe Title of group checkbox
/// [groupTitle] : Text Widget that describe Title of group checkbox
/// [itemBuilder] :  builder function  takes an index and checked state of widget
/// [values] : list of values
/// [itemCount] : list of initial values that you want to be selected
/// [itemExtent] : same as [itemExtent] of [ListView]
class CustomGroupedCheckbox<T> extends StatefulWidget {
  final CustomGroupController controller;
  final Widget? groupTitle;
  final CustomIndexedWidgetBuilder itemBuilder;
  final int itemCount;
  final double itemExtent;
  final List<T> values;

  CustomGroupedCheckbox({
    Key? key,
    required this.controller,
    this.groupTitle,
    required this.itemBuilder,
    required this.itemCount,
    required this.values,
    this.itemExtent = 50.0,
  })  : assert(itemCount > 0),
        super(key: key);

  @override
  CustomGroupedCheckboxState createState() => CustomGroupedCheckboxState();

  static CustomGroupedCheckboxState? of<T>(BuildContext context,
      {bool nullOk = false}) {
    assert(context != null);
    assert(nullOk != null);
    final CustomGroupedCheckboxState<T>? result =
        context.findAncestorStateOfType<CustomGroupedCheckboxState<T>>();
    if (nullOk || result != null) return result;
    throw FlutterError.fromParts(<DiagnosticsNode>[
      ErrorSummary(
          'CustomGroupedCheckbox.of() called with a context that does not contain an CustomGroupedCheckbox.'),
      ErrorDescription(
          'No CustomGroupedCheckbox ancestor could be found starting from the context that was passed to CustomGroupedCheckbox.of().'),
      context.describeElement('The context used was')
    ]);
  }
}

class CustomGroupedCheckboxState<T>
    extends CustomStateGroup<T?, CustomGroupedCheckbox> {
  SliverChildBuilderDelegate? childrenDelegate;

  @override
  void initState() {
    super.initState();
    itemsSelections = ValueNotifier([]);
    items = [];
    widget.values.forEach((v) {
      items.add(ValueNotifier(
          (CustomItem(data: v, checked: false, isDisabled: false))));
    });
    widget.controller.init(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        widget.groupTitle ?? Container(),
        Expanded(
          child: ScrollConfiguration(
            behavior: ScrollBehavior(),
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (ctx, index) {
                return ValueListenableBuilder<CustomItem<T?>>(
                  valueListenable: items[index],
                  builder: (ctx, value, child) {
                    return _ItemWidget(
                      child: widget.itemBuilder(
                        context,
                        index,
                        items[index].value.checked,
                        items[index].value.isDisabled,
                      ),
                      value: items[index].value.checked,
                      callback: (v) {
                        if (!items[index].value.isDisabled)
                          changeSelection(index, v);
                      },
                    );
                  },
                );
              },
              itemCount: items.length,
              itemExtent: widget.itemExtent,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void changeSelection(int index, dynamic value) {
    if (widget.controller.isMultipleSelection) {
      if (!itemsSelections.value.contains(widget.values[index])) {
        if (value) {
          itemsSelections.value = List.from(itemsSelections.value)
            ..add(widget.values[index]);
        }
      } else {
        if (!value) {
          itemsSelections.value = List.from(itemsSelections.value)
            ..remove(widget.values[index]);
        }
      }
      items[index].value = items[index].value.copy(checked: value);
    } else {
      if (value) {
        if (itemSelected.value != null) {
          if (itemSelected.value != items[index].value.data) {
            int indexPrevious = widget.values.indexOf(itemSelected.value);
            items[indexPrevious].value =
                items[indexPrevious].value.copy(checked: false);
          }
        }
        itemSelected.value = widget.values[index];
        items[index].value = items[index].value.copy(checked: value);
      }
    }
  }

  @override
  dynamic selection() {
    if (widget.controller.isMultipleSelection) {
      return itemsSelections.value;
    }
    return itemSelected.value;
  }
}

class _ItemWidget extends StatelessWidget {
  final Widget? child;
  final Function(bool)? callback;
  final bool? value;

  _ItemWidget({
    this.child,
    this.callback,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        callback!(!value!);
      },
      child: child,
    );
  }
}
