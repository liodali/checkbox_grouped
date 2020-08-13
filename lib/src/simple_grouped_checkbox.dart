import 'package:auto_size_text/auto_size_text.dart';
import 'package:checkbox_grouped/src/circulaire_checkbox.dart';
import 'package:checkbox_grouped/src/item.dart';
import 'package:flutter/material.dart';

import './item.dart';

typedef onChanged = Function(dynamic selected);
/// display  simple groupedCheckbox
/// [groupTitle] : Text Widget that describe Title of group checkbox
/// [itemsTitle] :  (required) A list of strings that describes each checkbox button
/// [values] : list of values
/// [onItemSelected] : list of initial values that you want to be selected
/// [itemsSubTitle] : A list of strings that describes second Text
/// [activeColor] : the color to use when this checkbox button is selected
/// [disableItems] : pecifies which item should be disabled
/// [preSelection] :  A list of values that you want to be initially selected
/// [checkFirstElement] : make first element in list checked
/// [isCirculaire] : enable to use circulaire checkbox
/// [isLeading] : same as [itemExtent] of [ListView]
/// [isExpandableTitle] : enable group checkbox to be expandable
/// [multiSelection] : enable mutli selection groupedCheckbox
class SimpleGroupedCheckbox<T> extends StatefulWidget {
  final List<String> itemsTitle;
  final onChanged onItemSelected;
  final String groupTitle;
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

  SimpleGroupedCheckbox({
    Key key,
    @required this.itemsTitle,
    @required this.values,
    this.onItemSelected,
    this.groupTitle,
    this.itemsSubTitle,
    this.disableItems,
    this.activeColor,
    this.checkFirstElement = false,
    this.preSelection,
    this.isCirculaire = false,
    this.isLeading = false,
    this.multiSelection = false,
    this.isExpandableTitle = false,
  })  : assert(values != null),
        assert(values.length == itemsTitle.length),
        assert(multiSelection == false &&
                preSelection != null &&
                preSelection.length > 0
            ? false
            : true),
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
                disableItems == [] ||
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
  Item _previousActive;
  T _selectedValue;
  List<T> _selectionsValue = [];
  List<Item> _items = [];
  bool valueTitle = false;
  bool isExpanded = true;

  @override
  void initState() {
    super.initState();
    for (String title in widget.itemsTitle) {
      _items.add(Item(
          title: title,
          checked: false,
          isDisabled: widget.disableItems?.contains(title) ?? false));
    }

    if (widget.multiSelection && widget.checkFirstElement) {
      _selectionsValue.add(widget.values[0]);
    }
    if (widget.multiSelection &&
        widget.preSelection != null &&
        widget.preSelection.length > 0) {
      valueTitle = null;
      for (int i = 0; i < widget.values.length; i++) {
        if (widget.preSelection.contains(widget.values[i])) {
          _items[i].checked = true;
          _selectionsValue.add(widget.values[i]);
        }
      }
    }

    if (widget.checkFirstElement) {
      _items[0].checked = true;
      _previousActive = _items[0];
      _selectionsValue = widget.values[0];
    }
  }

  selection() {
    if (widget.multiSelection) {
      return _selectionsValue;
    }
    return _selectedValue;
  }

  disabledItems(List<String> items) {
    assert(items.takeWhile((c) => !widget.itemsTitle.contains(c)).isEmpty,
        "some of items doen't exist");
    setState(() {
      itemStatus(items, true);
    });
  }

  enabledItems(List<String> items) {
    assert(items.takeWhile((c) => !widget.itemsTitle.contains(c)).isEmpty,
        "some of items doen't exist");
    setState(() {
      itemStatus(items, false);
    });
  }

  void itemStatus(List<String> items, bool isDisabled) {
    for (String item in items) {
      _items.firstWhere((c) => c.title == item, orElse: () => null).isDisabled =
          isDisabled;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.groupTitle != null && widget.isExpandableTitle) {
      return ExpansionPanelList(
        expansionCallback: (index, value) {
          setState(() {
            isExpanded = !value;
          });
        },
        children: [
          ExpansionPanel(
            canTapOnHeader: true,
            isExpanded: isExpanded,
            headerBuilder: (ctx, value) {
              return _TitleGroupedCheckbox(
                title: widget.groupTitle,
                isMultiSelection: widget.multiSelection,
                checkboxTitle: Checkbox(
                  tristate: true,
                  value: valueTitle,
                  activeColor: widget.activeColor,
                  onChanged: (v) {
                    setState(() {
                      if (v != null) valueTitle = v;
                    });
                  },
                ),
                callback: setChangedCallback,
              );
            },
            body: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
              //itemExtent: 75,
              itemBuilder: (ctx, i) {
                return Container(
                  child: checkBoxItem(i),
                );
              },
              itemCount: _items.length,
              addRepaintBoundaries: true,
            ),
          ),
        ],
      );
    }
    if(widget.groupTitle != null){
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _TitleGroupedCheckbox(
            title: widget.groupTitle,
            isMultiSelection: widget.multiSelection,
            checkboxTitle: Checkbox(
              tristate: true,
              value: valueTitle,
              activeColor: widget.activeColor,
              onChanged: (v) {
                setState(() {
                  if (v != null) valueTitle = v;
                });
              },
            ),
            callback: setChangedCallback,
          ),
          ListView.builder(
            itemCount: _items.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemBuilder: (ctx, i) {
              return Container(
                child: checkBoxItem(i),
              );
            },
          )
        ],
      );
    }
    return ListView.builder(
      itemCount: _items.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemBuilder: (ctx, i) {
        return Container(
          child: checkBoxItem(i),
        );
      },
    );
  }

  void setChangedCallback() {
    setState(() {
      if (valueTitle == null) {
        valueTitle = true;
        _selectionsValue.addAll(widget.values
            .where((elem) => _selectionsValue.contains(elem) == false));
      } else if (valueTitle) {
        valueTitle = false;
        _selectionsValue.clear();
      } else if (!valueTitle) {
        valueTitle = true;
        _selectionsValue.addAll(widget.values as List<T>);
      } else {
        valueTitle = true;
      }
      //callback
      if (widget.onItemSelected != null)
        widget.onItemSelected(_selectionsValue);

      _items
          .where((elem) => elem.checked != valueTitle)
          .forEach((i) => i.checked = valueTitle);
    });
  }

  void onChanged(int i, dynamic v) {
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
        valueTitle = true;
      } else if (_selectionsValue.length == 0) {
        valueTitle = false;
      } else {
        valueTitle = null;
      }
      _items[i].checked = v;

      if (widget.onItemSelected != null)
        widget.onItemSelected(_selectionsValue);
    } else {
      _selectedValue = v;
      if (_previousActive != null) {
        _previousActive.checked = false;
      }
      _items[i].checked = true;
      _previousActive = _items[i];
      if (widget.onItemSelected != null) widget.onItemSelected(_selectedValue);
    }
  }

  Widget checkBoxItem(int i) {
    if (widget.isCirculaire) {
      Widget circulaireWidget = CirculaireCheckbox(
        isChecked: _items[i].checked,
        color: widget.activeColor,
      );
      return ListTile(
        onTap: _items[i].isDisabled
            ? null
            : () {
                setState(() {
                  onChanged(i, widget.values[i]);
                });
              },
        title: AutoSizeText(
          "${_items[i].title}",
          minFontSize: 12,
        ),
        subtitle: widget.itemsSubTitle != null
            ? AutoSizeText(
                "${widget.itemsSubTitle[i]}",
                minFontSize: 11,
              )
            : null,
        leading: widget.isLeading ? circulaireWidget : null,
        trailing: !widget.isLeading ? circulaireWidget : null,
      );
    }
    if (!widget.multiSelection) {
      return RadioListTile<T>(
        groupValue: _selectedValue,
        onChanged: _items[i].isDisabled
            ? null
            : (v) {
                setState(() {
                  onChanged(i, v);
                });
              },
        activeColor: widget.activeColor ?? Theme.of(context).primaryColor,
        title: AutoSizeText(
          "${_items[i].title}",
          minFontSize: 12,
        ),
        subtitle: widget.itemsSubTitle != null
            ? AutoSizeText(
                "${widget.itemsSubTitle[i]}",
                minFontSize: 11,
              )
            : null,
        value: widget.values[i],
        selected: _items[i].checked,
        dense: widget.itemsSubTitle != null ? true : false,
        isThreeLine: widget.itemsSubTitle != null ? true : false,
        controlAffinity: widget.isLeading
            ? ListTileControlAffinity.leading
            : ListTileControlAffinity.trailing,
      );
    }
    return CheckboxListTile(
      onChanged: _items[i].isDisabled
          ? null
          : (v) {
              setState(() {
                onChanged(i, v);
              });
            },
      activeColor: widget.activeColor ?? Theme.of(context).primaryColor,
      title: AutoSizeText(
        "${_items[i].title}",
        minFontSize: 12,
      ),
      subtitle: widget.itemsSubTitle != null
          ? AutoSizeText(
              "${widget.itemsSubTitle[i]}",
              minFontSize: 11,
            )
          : null,
      value: _items[i].checked,
      selected: _items[i].checked,
      dense: widget.itemsSubTitle != null ? true : false,
      isThreeLine: widget.itemsSubTitle != null ? true : false,
      controlAffinity: widget.isLeading
          ? ListTileControlAffinity.leading
          : ListTileControlAffinity.trailing,
    );
  }
}

class _TitleGroupedCheckbox extends StatelessWidget {
  final String title;
  final bool isMultiSelection;
  final VoidCallback callback;
  final Widget checkboxTitle;

  _TitleGroupedCheckbox(
      {this.title, this.isMultiSelection, this.callback, this.checkboxTitle});

  @override
  Widget build(BuildContext context) {
    if (isMultiSelection && title != null) {
      return ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
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
      return Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      );

    return Container();
  }
}
