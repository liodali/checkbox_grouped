import 'package:auto_size_text/auto_size_text.dart';
import './circulaire_checkbox.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import './item.dart';

typedef onChanged = Function(dynamic selected);

/// display  simple groupedCheckbox
/// [itemsTitle] :  (required) A list of strings that describes each checkbox button
/// [values] : list of values
/// [onItemSelected] : list of initial values that you want to be selected
/// [itemsSubTitle] : A list of strings that describes second Text
/// [groupTitle] : Text Widget that describe Title of group checkbox
/// [groupTitleStyle] : Text Style  that describe style of title of group checkbox
/// [activeColor] : the color to use when this checkbox button is selected
/// [disableItems] : specifies which item should be disabled
/// [preSelection] :  A list of values that you want to be initially selected
/// [checkFirstElement] : make first element in list checked
/// [isCirculaire] : enable to use circulaire checkbox
/// [isLeading] : same as [itemExtent] of [ListView]
/// [isExpandableTitle] : enable group checkbox to be expandable
/// [helperGroupTitle] : (bool) hide/show checkbox in title to help all selection or deselection,use it when you want to disable checkbox in groupTitle default:`true`
/// [groupTitleAlignment] : (Alignment) align title of checkbox group checkbox default:`Alignment.center`
/// [multiSelection] : enable multiple selection groupedCheckbox
class SimpleGroupedCheckbox<T> extends StatefulWidget {
  final List<String> itemsTitle;
  final onChanged onItemSelected;
  final String groupTitle;
  final AlignmentGeometry groupTitleAlignment;
  final TextStyle groupTitleStyle;
  final List<String> itemsSubTitle;
  final Color activeColor;
  final List<T> values;
  final List<String> disableItems;
  final List<T> preSelection;
  final bool checkFirstElement;
  final bool isCirculaire;
  final bool multiSelection;
  final bool isLeading;
  final bool isExpandableTitle;
  final bool helperGroupTitle;

  SimpleGroupedCheckbox({
    Key key,
    @required this.itemsTitle,
    @required this.values,
    this.onItemSelected,
    this.groupTitle,
    this.groupTitleAlignment =  Alignment.center,
    this.groupTitleStyle,
    this.itemsSubTitle,
    this.disableItems,
    this.activeColor,
    this.checkFirstElement = false,
    this.preSelection,
    this.isCirculaire = false,
    this.isLeading = false,
    this.multiSelection = false,
    this.isExpandableTitle = false,
    this.helperGroupTitle = true,
  })  : assert(values != null),
        assert(values.length == itemsTitle.length),
        assert(
            multiSelection == false &&
                    preSelection != null &&
                    (preSelection.length > 1 || checkFirstElement == true)
                ? false
                : true,
            "you cannot make multiple selection in single selection"),
        assert(itemsSubTitle != null
            ? itemsSubTitle.length == itemsTitle.length
            : true),
        assert(
            (groupTitle == null && !isExpandableTitle) ||
                (groupTitle != null && isExpandableTitle ||
                    groupTitle != null && !isExpandableTitle),
            "you cannot make isExpandable without textTitle"),
        assert(
            disableItems == null ||
                disableItems.isEmpty ||
                disableItems
                    .takeWhile((c) => itemsTitle.contains(c))
                    .isNotEmpty,
            "you cannot disable items doesn't exist in itemsTitle"),
        super(key: key);

  static SimpleGroupedCheckboxState of<T>(BuildContext context,
      {bool nullOk = false}) {
    assert(context != null);
    assert(nullOk != null);
    final SimpleGroupedCheckboxState<T> result =
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

class SimpleGroupedCheckboxState<T> extends State<SimpleGroupedCheckbox> {
  ValueNotifier<T> _selectedValue;
  List<T> _selectionsValue = [];
  List<ValueNotifier<Item>> _notifierItems = [];
  List<Item> _items = [];
  ValueNotifier<bool> _valueTitle = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _selectedValue = ValueNotifier(null);
    if (widget.preSelection != null && widget.preSelection.isNotEmpty) {
      final cacheSelection = widget.preSelection.toList();
      cacheSelection.removeWhere((e) => widget.values.contains(e));
      if (cacheSelection.isNotEmpty) {
        assert(widget.values.contains(cacheSelection),
            "you want to activate selection of value doesn't exist");
      }
    }
    widget.itemsTitle.asMap().forEach((key, title) {
      bool checked = false;
      if (key == 0) {
        if (widget.multiSelection && widget.checkFirstElement) {
          _selectionsValue.add(widget.values[0]);
          checked = true;
        }
      }
      if (widget.multiSelection &&
          widget.preSelection != null &&
          widget.preSelection.length > 0) {
        _valueTitle.value = null;
        if (widget.preSelection.contains(widget.values[key])) {
          checked = true;
          _selectionsValue.add(widget.values[key]);
        }
      } else {
        if (!widget.multiSelection &&
            !widget.checkFirstElement &&
            widget.preSelection != null &&
            widget.preSelection.length == 1) {
          _valueTitle.value = null;
          if (widget.preSelection.contains(widget.values[key])) {
            checked = true;
            _selectedValue.value = widget.values[key];
          }
        }
      }
      Item item = Item(
          title: title,
          checked: checked,
          isDisabled: widget.disableItems?.contains(title) ?? false);
      _items.add(item);
      _notifierItems.add(ValueNotifier(item));
    });

    if (widget.checkFirstElement) {
      _items[0].checked = true;
      _notifierItems[0].value = Item(
        isDisabled: _items[0].isDisabled,
        checked: _items[0].checked,
        title: _items[0].title,
      );
      //_previousActive = _items[0];
      _selectedValue.value = widget.values[0];
    }
  }

  /// recuperate value selection if is not multi selection
  /// recuperate list of selection value if is multi selection
  dynamic selection() {
    if (widget.multiSelection) {
      return _selectionsValue;
    }
    return _selectedValue.value;
  }

  /// [items]: A list of values that you want to be disabled
  /// disable items that match with list of strings
  void disabledItemsByValues(List<T> itemsValues) {
    assert(itemsValues.takeWhile((c) => !widget.values.contains(c)).isEmpty,
        "some of items doesn't exist");
    var items = _recuperateTitleFromValues(itemsValues);
    _itemStatus(items, true);
  }

  /// [items]: A list of strings that describes titles
  /// disable items that match with list of strings
  disabledItemsByTitles(List<String> items) {
    assert(items.takeWhile((c) => !widget.itemsTitle.contains(c)).isEmpty,
        "some of items doesn't exist");
    _itemStatus(items, true);
  }

  /// [items]: A list of strings that describes titles
  /// disable items that match with list of strings
  @Deprecated("use disabledItemsByTitles,will be remove in future version")
  disabledItems(List<String> items) {
    assert(items.takeWhile((c) => !widget.itemsTitle.contains(c)).isEmpty,
        "some of items doesn't exist");
    _itemStatus(items, true);
  }

  /// [items]: A list of strings that describes titles
  /// enable items that match with list of strings
  @Deprecated("use enabledItemsByTitles,will be removed in future version")
  void enabledItems(List<String> items) {
    assert(items.takeWhile((c) => !widget.itemsTitle.contains(c)).isEmpty,
        "some of items doesn't exist");
    _itemStatus(items, false);
  }

  /// [items]: A list of values
  /// enable items that match with list of dynamics
  void enabledItemsByValues(List<T> itemsValues) {
    assert(itemsValues.takeWhile((c) => !widget.values.contains(c)).isEmpty,
        "some of items doesn't exist");
    var items = _recuperateTitleFromValues(itemsValues);
    _itemStatus(items, false);
  }

  /// [items]: A list of strings that describes titles
  /// enable items that match with list of strings
  void enabledItemsByTitles(List<String> items) {
    assert(items.takeWhile((c) => !widget.itemsTitle.contains(c)).isEmpty,
        "some of items doesn't exist");
    _itemStatus(items, false);
  }

  List<String> _recuperateTitleFromValues(List<T> itemsValues) {
    return itemsValues.map((e) {
      var indexOfItem = widget.values.indexOf(e);
      return widget.itemsTitle[indexOfItem];
    }).toList();
  }

  void _itemStatus(List<String> items, bool isDisabled) {
    _notifierItems
        .where((element) => items.contains(element.value.title))
        .toList()
        .asMap()
        .forEach((key, notifierItem) {
      var index = _notifierItems.indexOf(notifierItem);
      Item item = Item(
          isDisabled: notifierItem.value.isDisabled,
          checked: notifierItem.value.checked,
          title: notifierItem.value.title);
      item.isDisabled = isDisabled;
      _notifierItems[index].value = item;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget childListChecks = ListView.builder(
      itemCount: _notifierItems.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemBuilder: (ctx, i) {
        return ValueListenableBuilder<Item>(
          valueListenable: _notifierItems[i],
          builder: (ctx, item, child) {
            return _CheckboxItem<T>(
              index: i,
              item: item,
              onChangedCheckBox: (index, v) {
                onChanged(i, v);
              },
              selectedValue: _selectedValue.value,
              value: widget.values[i],
              activeColor: widget.activeColor,
              isCirculaire: widget.isCirculaire,
              isLeading: widget.isLeading,
              itemSubTitle: widget.itemsSubTitle != null &&
                      widget.itemsSubTitle.isNotEmpty
                  ? widget.itemsSubTitle[i]
                  : null,
              isMultpileSelection: widget.multiSelection,
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
          isMultiSelection: widget.multiSelection,
          alignment: widget.groupTitleAlignment,
          checkboxTitle: widget.helperGroupTitle
              ? ValueListenableBuilder(
                  valueListenable: _valueTitle,
                  builder: (ctx, selected, _) {
                    return Checkbox(
                      tristate: true,
                      value: selected,
                      activeColor: widget.activeColor,
                      onChanged: (v) {
                        setState(() {
                          if (v != null) _valueTitle.value = v;
                        });
                      },
                    );
                  },
                )
              : null,
          callback: setChangedCallback,
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
            isMultiSelection: widget.multiSelection,
            checkboxTitle: widget.helperGroupTitle
                ? ValueListenableBuilder(
                    valueListenable: _valueTitle,
                    builder: (ctx, selected, _) {
                      return Checkbox(
                        tristate: true,
                        value: selected,
                        activeColor: widget.activeColor,
                        onChanged: (v) {
                          setState(
                            () {
                              if (v != null) _valueTitle.value = v;
                            },
                          );
                        },
                      );
                    },
                  )
                : null,
            callback: setChangedCallback,
          ),
          childListChecks,
        ],
      );
    }
    return childListChecks;
  }

  /// callback title grouped when clicked it disabled all selected or select all elements
  void setChangedCallback() {
    setState(() {
      if (_valueTitle.value == null) {
        _valueTitle.value = true;
        _selectionsValue.addAll(widget.values
            .where((elem) => _selectionsValue.contains(elem) == false));
      } else if (_valueTitle.value) {
        _valueTitle.value = false;
        _selectionsValue.clear();
      } else if (!_valueTitle.value) {
        _valueTitle.value = true;
        _selectionsValue.addAll(widget.values as List<T>);
      } else {
        _valueTitle.value = true;
      }
      //callback
      if (widget.onItemSelected != null)
        widget.onItemSelected(_selectionsValue);
    });
    _notifierItems
        .where((e) => e.value.checked != _valueTitle.value)
        .toList()
        .forEach((element) {
      Item item = element.value;
      item.checked = _valueTitle.value;
      element.value = item;
    });
  }

  void onChanged(int i, dynamic v) {
    Item item = Item(
      title: _notifierItems[i].value.title,
      checked: _notifierItems[i].value.checked,
      isDisabled: _notifierItems[i].value.isDisabled,
    );
    if (widget.multiSelection) {
      if (!_selectionsValue.contains(widget.values[i])) {
        if (v) {
          _selectionsValue.add(widget.values[i]);
        }
      } else {
        if (!v) {
          _selectionsValue.remove(widget.values[i]);
        }
      }
      if (_selectionsValue.length == widget.values.length) {
        _valueTitle.value = true;
      } else if (_selectionsValue.length == 0) {
        _valueTitle.value = false;
      } else {
        _valueTitle.value = null;
      }
      //_items[i].checked = v;

      if (widget.onItemSelected != null)
        widget.onItemSelected(_selectionsValue);

      item.checked = v;
    } else {
      _selectedValue.value = v;
      /*if (_previousActive != null) {
        _previousActive.checked = false;
      }
      _items[i].checked = true;
      _previousActive = _items[i];*/
      var notifierPrevious = _notifierItems
          .firstWhere((element) => element.value.checked, orElse: () => null);
      if (notifierPrevious != null) {
        var indexPrevious = _notifierItems.indexOf(notifierPrevious);
        var previous = Item(
          title: notifierPrevious.value.title,
          checked: notifierPrevious.value.checked,
          isDisabled: notifierPrevious.value.isDisabled,
        );
        previous.checked = false;
        _notifierItems[indexPrevious].value = previous;
      }
      item.checked = true;
      _notifierItems[i].value = item;
      if (widget.onItemSelected != null)
        widget.onItemSelected(_selectedValue.value);
    }
    _notifierItems[i].value = item;
  }
}

class _TitleGroupedCheckbox extends StatelessWidget {
  final String title;
  final TextStyle titleStyle;
  final AlignmentGeometry alignment;
  final bool isMultiSelection;
  final VoidCallback callback;
  final Widget checkboxTitle;

  _TitleGroupedCheckbox({
    this.title,
    this.titleStyle,
    this.isMultiSelection,
    this.callback,
    this.checkboxTitle,
    this.alignment = Alignment.center,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final titleWidget = Text(
      title,
      style: titleStyle ??
          TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
    );
    if (isMultiSelection && title != null && checkboxTitle != null) {
      return ListTile(
        title: titleWidget,
        onTap: () {
          callback();
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
      return Align(
        alignment: alignment,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 5.0,
            right: 5.0,
          ),
          child: titleWidget,
        ),
      );

    return Container();
  }
}

class _CheckboxItem<T> extends StatelessWidget {
  final bool isCirculaire;
  final bool isMultpileSelection;
  final bool isLeading;
  final T value;
  final T selectedValue;
  final Item item;
  final String itemSubTitle;
  final int index;
  final Color activeColor;
  final Function(int i, dynamic v) onChangedCheckBox;

  _CheckboxItem({
    this.isCirculaire = false,
    this.isMultpileSelection = false,
    this.isLeading = false,
    this.activeColor,
    @required this.item,
    this.itemSubTitle,
    @required this.value,
    @required this.selectedValue,
    @required this.index,
    @required this.onChangedCheckBox,
  });

  @override
  Widget build(BuildContext context) {
    if (isCirculaire) {
      Widget circulaireWidget = CirculaireCheckbox(
        isChecked: item.checked,
        color: activeColor,
      );
      return ListTile(
        onTap: item.isDisabled
            ? null
            : () {
                onChangedCheckBox(index, value);
                /*setState(() {
            onChanged(i, widget.values[i]);
          });*/
              },
        title: AutoSizeText(
          "${item.title}",
          minFontSize: 12,
        ),
        subtitle: itemSubTitle != null
            ? AutoSizeText(
                itemSubTitle,
                minFontSize: 11,
              )
            : null,
        leading: isLeading ? circulaireWidget : null,
        trailing: !isLeading ? circulaireWidget : null,
      );
    }
    if (!isMultpileSelection) {
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
                itemSubTitle,
                minFontSize: 11,
              )
            : null,
        value: value,
        selected: item.checked,
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
              itemSubTitle,
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
  final Widget listChild;
  final Widget titleWidget;

  _ExpansionCheckBoxList({
    this.listChild,
    this.titleWidget,
  });

  @override
  State<StatefulWidget> createState() => _ExpansionCheckBoxListState();
}

class _ExpansionCheckBoxListState extends State<_ExpansionCheckBoxList> {
  bool isExpanded;

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
            return widget.titleWidget;
          },
          body: widget.listChild,
        ),
      ],
    );
  }
}
