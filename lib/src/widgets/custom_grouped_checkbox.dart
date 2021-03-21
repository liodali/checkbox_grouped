import 'package:flutter/material.dart';

import '../common/custom_state_group.dart';
import '../common/item.dart';
import '../controller/custom_group_controller.dart';

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
  final double? itemExtent;
  final List<T> values;
  final bool _isGrid;
  final bool isScroll;
  final SliverGridDelegate? gridDelegate;

  CustomGroupedCheckbox({
    Key? key,
    required this.controller,
    this.groupTitle,
    required this.itemBuilder,
    required this.values,
    this.isScroll = false,
    this.itemExtent,
  })  : this._isGrid = false,
        this.gridDelegate = null,
        super(key: key);

  CustomGroupedCheckbox.grid({
    Key? key,
    required this.controller,
    this.groupTitle,
    SliverGridDelegate gridDelegate =
        const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
    ),
    this.isScroll = false,
    required this.itemBuilder,
    required this.values,
  })   : this._isGrid = true,
        this.gridDelegate = gridDelegate,
        this.itemExtent = 0.0,
        super(key: key);

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
          return _ItemWidget(
            child: widget.itemBuilder(
              context,
              index,
              items[index].value.checked,
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
      physics: widget.isScroll
          ? AlwaysScrollableScrollPhysics()
          : NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemBuilder: builder,
      itemCount: items.length,
      itemExtent: widget.itemExtent,
    );
    if (widget._isGrid) {
      child = GridView.builder(
        physics: widget.isScroll
            ? AlwaysScrollableScrollPhysics()
            : NeverScrollableScrollPhysics(),
        gridDelegate: widget.gridDelegate!,
        itemBuilder: builder,
        itemCount: items.length,
        shrinkWrap: true,
      );
    }
    return Column(
      children: <Widget>[
        widget.groupTitle ?? Container(),
        Expanded(
          child: ScrollConfiguration(
            behavior: ScrollBehavior(),
            child: child,
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
     if(streamListValues.hasListener) streamListValues.add(itemsSelections.value);
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
      child: AbsorbPointer(
        absorbing: true,
        child: child,
      ),
    );
  }
}
