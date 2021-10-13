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
  final EdgeInsets titlePadding;
  final List<Widget>? groupTitlesWidget;
  final TextStyle? titleGroupedTextStyle;
  final Alignment titleGroupedAlignment;
  final OnCustomGroupChanged? onSelectedGroupChanged;

  ListCustomGroupedCheckbox({
    required this.controller,
    this.groupTitles,
    this.groupTitlesWidget,
    required this.children,
    required this.listValuesByGroup,
    this.isScrollable = true,
    this.titlePadding = const EdgeInsets.all(5.0),
    this.titleGroupedTextStyle,
    this.titleGroupedAlignment = Alignment.centerLeft,
    this.onSelectedGroupChanged,
    Key? key,
  })  : assert(children.isNotEmpty),
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
        (index) {
          late CustomGroupController customGroupController;
          if (isMultipleSelections[index]) {
            customGroupController = CustomGroupController.multiple(
              initSelectedItem:
                  widget.controller.initSelectedValuesByGroup.isNotEmpty
                      ? widget.controller.initSelectedValuesByGroup
                              .containsKey(index)
                          ? widget.controller.initSelectedValuesByGroup[index]!
                              .toList()
                          : []
                      : [],
            )..listen((_) => _onSelected());
          } else {
            if (widget.controller.initSelectedValuesByGroup
                    .containsKey(index) &&
                widget
                    .controller.initSelectedValuesByGroup[index]!.isNotEmpty) {
              customGroupController = CustomGroupController(
                initSelectedItem:
                    widget.controller.initSelectedValuesByGroup[index]!.first,
                isMultipleSelection: false,
              )..listen((_) => _onSelected());
            } else {
              customGroupController = CustomGroupController()
                ..listen((_) => _onSelected());
            }
          }

          return customGroupController;
        },
      ),
    );
  }

  void _onSelected() async {
    final map = await getMapValues();
    if (widget.onSelectedGroupChanged != null) {
      widget.onSelectedGroupChanged!(map);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List> getAllValues({bool byGroup = true}) async {
    List resultList = List.empty(growable: true);
    var values = listControllers.map((e) {
      switch (e.isMultipleSelection && byGroup) {
        case true:
          return [e.selectedItem];
        default:
          return e.selectedItem;
      }
    }).where((v) {
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

  Future<Map<int, dynamic>> getMapValues() async {
    Map<int, dynamic> resultList = Map();
    listControllers.asMap().forEach((key, controller) {
      resultList.putIfAbsent(key, () => controller.selectedItem ?? null);
    });
    return resultList;
  }

  Future<List> getListValuesByIndex(int index) async {
    assert(index < len);
    List resultList = List.empty();
    resultList.addAll(listControllers[index].selectedItem ?? null);
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
        if (widget.children[index] is CustomGridIndexedWidgetBuilder) {
          return CustomGroupedCheckbox.grid(
            controller: listControllers[index],
            isScroll: false,
            groupTitle:
                widget.groupTitles != null && widget.groupTitles!.isNotEmpty
                    ? Container(
                        alignment: widget.titleGroupedAlignment,
                        padding: widget.titlePadding,
                        child: Text(
                          widget.groupTitles![index],
                          style: widget.titleGroupedTextStyle ??
                              Theme.of(context).textTheme.headline6,
                        ),
                      )
                    : null,
            itemBuilder: (innerCtx, indexInner, check, disabled) {
              return widget.children[index].itemBuilder(
                innerCtx,
                indexInner,
                check,
                disabled,
              );
            },
            values: widget.listValuesByGroup[index],
            gridDelegate:
                (widget.children[index] as CustomGridIndexedWidgetBuilder)
                    .gridDelegate,
          );
        }
        return CustomGroupedCheckbox(
          controller: listControllers[index],
          isScroll: false,
          groupTitle:
              widget.groupTitles != null && widget.groupTitles!.isNotEmpty
                  ? Container(
                      alignment: widget.titleGroupedAlignment,
                      padding: widget.titlePadding,
                      child: Text(
                        widget.groupTitles![index],
                        style: widget.titleGroupedTextStyle ??
                            Theme.of(context).textTheme.headline6,
                      ),
                    )
                  : null,
          itemBuilder: (innerCtx, indexInner, check, disabled) {
            return widget.children[index].itemBuilder(
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

class CustomIndexedWidgetBuilder {
  final CustomItemIndexedWidgetBuilder itemBuilder;

  CustomIndexedWidgetBuilder({
    required this.itemBuilder,
  });
}

class CustomGridIndexedWidgetBuilder extends CustomIndexedWidgetBuilder {
  final SliverGridDelegate gridDelegate;

  CustomGridIndexedWidgetBuilder({
    required CustomItemIndexedWidgetBuilder itemBuilder,
    this.gridDelegate = const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
    ),
  }) : super(
          itemBuilder: itemBuilder,
        );
}
