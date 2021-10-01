import 'package:flutter/material.dart';

import '../../checkbox_grouped.dart';
import '../common/item.dart';
import '../common/utilities.dart';
import '../controller/list_custom_group_controller.dart';

/// display  simple groupedCheckbox
/// [controller]              :  (required) List Group Controller to recuperate selection
///
/// [children]                  : list of widget for each group
///
/// [listValuesByGroup]         : list of values  for each group
///
/// [onSelectedGroupChanged]  : callback to get selected items,it fred when the user selected items or deselect items
///
/// [groupTitles]             : Text Widget that describe Title of group checkbox
///
/// [titleGroupedTextStyle]   : (TextStyle) style title text of each group
///
/// [titleGroupedAlignment]   : (Alignment) Alignment of  title text of each group
///
class ListCustomGroupedCheckbox extends StatefulWidget {
  final ListCustomGroupController controller;
  final bool isScrollable;
  final List<CustomIndexedWidgetBuilder> children;
  final List<List<dynamic>> listValuesByGroup;
  final List<String>? groupTitles;
  final List<Widget>? groupTitlesWidget;
  final TextStyle? titleGroupedTextStyle;
  final Alignment titleGroupedAlignment;
  final OnGroupChanged? onSelectedGroupChanged;

  ListCustomGroupedCheckbox({
    required this.controller,
    this.groupTitles,
    this.groupTitlesWidget,
    required this.children,
    required this.listValuesByGroup,
    this.isScrollable = true,
    this.titleGroupedTextStyle,
    this.titleGroupedAlignment = Alignment.centerLeft,
    this.onSelectedGroupChanged,
    Key? key,
  })  :
        //assert(controller.isMultipleSelectionPerGroup.isEmpty),
        assert((groupTitles == null &&
                (groupTitlesWidget != null && groupTitlesWidget.isNotEmpty)) ||
            (groupTitlesWidget == null &&
                (groupTitles != null && groupTitles.isNotEmpty))),
        super(key: key);

  static ListCustomGroupedCheckboxState? of(BuildContext context,
      {bool nullOk = false}) {
    final ListCustomGroupedCheckboxState? result =
        context.findAncestorStateOfType<ListCustomGroupedCheckboxState>();
    if (nullOk || result != null) return result;
    throw FlutterError.fromParts(<DiagnosticsNode>[
      ErrorSummary(
          'ListGroupedCheckboxState.of() called with a context that does not contain an CustomGroupedCheckbox.'),
      ErrorDescription(
          'No ListGroupedCheckboxState ancestor could be found starting from the context that was passed to CustomGroupedCheckbox.of().'),
      context.describeElement('The context used was')
    ]);
  }

  @override
  ListCustomGroupedCheckboxState createState() =>
      ListCustomGroupedCheckboxState();
}

class ListCustomGroupedCheckboxState extends State<ListCustomGroupedCheckbox> {
  int len = 0;
  List<CustomGroupController> listControllers = [];

  ValueNotifier<List<dynamic>> mapItemsSelections = ValueNotifier([]);

  late Map<int, List<ValueNotifier<CustomItem<dynamic>>>> mapItems;

  late List<bool> isMultipleSelections;

  @override
  void initState() {
    super.initState();
    len = widget.children.length;
    isMultipleSelections = List.generate(len, (index) => false);
    if (widget.controller.isMultipleSelectionPerGroup.isNotEmpty) {
      isMultipleSelections = widget.controller.isMultipleSelectionPerGroup;
    }
    widget.controller.init(this);
    listControllers.addAll(
      List.generate(
        len,
        (index) => isMultipleSelections[index]
            ? CustomGroupController.multiple(
                initSelectedItem: widget
                        .controller.initSelectedValuesByGroup.isNotEmpty
                    ? widget.controller.initSelectedValuesByGroup
                            .containsKey(index)
                        ? widget.controller.initSelectedValuesByGroup[index]!
                            .toList()
                        : []
                    : [],
              )
            : widget.controller.initSelectedValuesByGroup.containsKey(index) &&
                    widget
                        .controller.initSelectedValuesByGroup[index]!.isNotEmpty
                ? CustomGroupController(
                    initSelectedItem: widget
                        .controller.initSelectedValuesByGroup[index]!.first,
                    isMultipleSelection: false,
                  )
                : CustomGroupController(),
      ),
    );
  }

  Future<List> getAllValues() async {
    List resultList = List.empty(growable: true);
    var values = listControllers.map((e) => e.selectedItem).where((v) {
      if (v != null) {
        if (v is List && v.isNotEmpty) {
          return true;
        } else {
          return true;
        }
      }
      return false;
    }).toList();
    for (var v in values) {
      if (v is List)
        resultList.addAll(v);
      else {
        if (v != null) resultList.add(v);
      }
    }

    return resultList;
  }

  Future<List> getValuesByIndex(int index) async {
    assert(index < len);
    List resultList = List.empty();
    resultList.addAll(listControllers[index].selectedItem);
    return resultList;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      addAutomaticKeepAlives: true,
      physics: widget.isScrollable
          ? AlwaysScrollableScrollPhysics()
          : NeverScrollableScrollPhysics(),
      itemBuilder: (ctx, index) {
        return CustomGroupedCheckbox(
            controller: listControllers[index],
            isScroll: false,
            groupTitle: widget.groupTitles != null && widget.groupTitles!.isNotEmpty
                ? Text(widget.groupTitles![index])
                : null,
            itemBuilder: (innerCtx, indexInner, check, disabled) {
              return widget.children[index](
                innerCtx,
                indexInner,
                check,
                disabled,
              );
            },
            values: widget.listValuesByGroup[index],
          );
      },
      itemCount: len,
    );
  }
}
