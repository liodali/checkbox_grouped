import 'package:auto_size_text/auto_size_text.dart';
import 'package:checkbox_grouped/src/circulaire_checkbox.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:checkbox_grouped/src/item.dart';
import './item.dart';

enum Direction { Horizontal, Vertical }

class SimpleGroupedCheckbox<T> extends StatefulWidget {
  final Direction direction;
  final List<String> itemsTitle;
  final List<String> itemsSubTitle;
  final Color activeColor;
  final List<T> values;
  final List<T> preSelection;
  final bool checkFirstElement;
  final bool isCirculaire;
  final bool multiSelection;
  final bool isLeading;

  SimpleGroupedCheckbox({
    Key key,
    this.direction = Direction.Vertical,
    @required this.itemsTitle,
    @required this.values,
    this.itemsSubTitle,
    this.activeColor,
    this.checkFirstElement = false,
    this.preSelection ,
    this.isCirculaire=false ,
    this.isLeading=false ,
    this.multiSelection = false,
  })  : assert(values != null),
        assert(values.length == itemsTitle.length),
        assert(multiSelection==false && preSelection!=null && preSelection.length > 0 ?false:true),
        assert(itemsSubTitle != null
            ? itemsSubTitle.length == itemsTitle.length
            : true),
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
  @override
  void initState() {
    super.initState();
    for (String title in widget.itemsTitle) {
      _items.add(Item(title: title, checked: false));
    }

    if (widget.multiSelection && widget.checkFirstElement) {
      _selectionsValue.add(widget.values[0]);
    }
    if(widget.multiSelection && widget.preSelection.length>0){
      for(int i=0;i<widget.values.length;i++){
          if(widget.preSelection.contains(widget.values[i])){
              _items[i].checked=true;
              _selectionsValue.add(widget.values[i]);
          }
      }
    }


    if (widget.checkFirstElement) {
      _items[0].checked = true;
      _previousActive=_items[0];
      _selectionsValue=widget.values[0];
    }
  }

  Object selection() {
    if (widget.multiSelection) {
      return _selectionsValue;
    }
    return _selectedValue;
  }

  @override
  Widget build(BuildContext context) {
    Axis axis = widget.direction == Direction.Horizontal
        ? Axis.horizontal
        : Axis.vertical;
    return Wrap(
      direction: axis,
      verticalDirection: VerticalDirection.down,
      runSpacing: axis == Axis.horizontal ? 5.0 : 20.0,
      children: checkBoxList(axis),
    );
  }

  List<Widget> checkBoxList(Axis axis) {
    return [
      for (int i = 0; i < _items.length; i++) ...[
        if (axis == Axis.horizontal)
          SizedBox(
            width: 160,
            child: checkBoxItem(i),
          ),
        if (axis == Axis.vertical)
          SizedBox(
            width: 350,
            child: checkBoxItem(i),
          )
      ]
    ];
  }
  void onChanged(int i,bool v){
    if (widget.multiSelection) {
      if (!_selectionsValue.contains(widget.values[i])) {
        if (v) _selectionsValue.add(widget.values[i]);
      } else {
        if (!v) {
          _selectionsValue.remove(widget.values[i]);
        }
      }
      _items[i].checked = v;
    } else {
      if (v) {
        _items[i].checked = v;
        if (_previousActive != _items[i]) {
          if (_previousActive != null) {
            _previousActive.checked = false;
          } else {
            _previousActive = _items[i];
          }
        }
        _selectedValue = widget.values[i];
        _previousActive = _items[i];
      }
    }
  }
  Widget checkBoxItem(int i) {
    if(widget.isCirculaire){
      Widget circulaireWidget=CirculaireCheckbox(isChecked: _items[i].checked,color: widget.activeColor,);
      return ListTile(
        onTap: (){
          setState(() {
            onChanged(i, !_items[i].checked);
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
        leading: widget.isLeading?circulaireWidget:null,
        trailing: !widget.isLeading?circulaireWidget:null,
      );
    }
    return CheckboxListTile(
      onChanged: (v) {
        setState(() {
          onChanged(i,v);
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
      dense: widget.itemsSubTitle != null?true:false,
      isThreeLine: widget.itemsSubTitle != null?true:false,
      controlAffinity: widget.isLeading?ListTileControlAffinity.leading:ListTileControlAffinity.trailing,
    );
  }
}

