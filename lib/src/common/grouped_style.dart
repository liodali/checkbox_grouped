import 'package:flutter/material.dart';

///
/// class [_BaseGroupedStyle]  base class for style groupedCheckbox,Switch,Chips
///
/// [activeColor]        : (Color) choose the color to use when this checkbox button is selected
///
/// [groupTitleStyle]    : (TextStyle) Text Style  that describe style of group title of group checkbox
///
/// [itemTitleStyle]     : (TextStyle) Text Style  that describe style of title of each item in  group checkbox
///
/// [subItemTitleStyle]  : (TextStyle) Text Style  that describe style of subtitle of each item in  group checkbox
class _BaseGroupStyle {
  final Color? activeColor;
  final TextStyle? groupTitleStyle;
  final TextStyle? itemTitleStyle;
  final TextStyle? subItemTitleStyle;

  const _BaseGroupStyle({
    this.activeColor,
    this.groupTitleStyle,
    this.itemTitleStyle,
    this.subItemTitleStyle,
  });
}

///
/// class [GroupedStyle]   for style text in  [SimpleGroupedCheckbox]
class GroupStyle extends _BaseGroupStyle {
  GroupStyle({
    Color? activeColor,
    TextStyle? groupTitleStyle,
    TextStyle? itemTitleStyle,
    TextStyle? subItemTitleStyle,
  }) : super(
          activeColor: activeColor,
          groupTitleStyle: groupTitleStyle,
          itemTitleStyle: itemTitleStyle,
          subItemTitleStyle: subItemTitleStyle,
        );
}

///
/// class [ChipGroupStyle]   for style text in  [SimpleGroupedCheckbox]
///
///  [backgroundColorItem]  : the background color for each item
///
///  [selectedColorItem]   : the background color to use when item is  selected
///
///  [textColor]          : the color to use for each text of item
///
///  [selectedTextColor] : the selected color to use for each text of item
///
///  [selectedIcon]     : the selected icon to use for each selected  item
///
/// [disabledColor]    : (Color) the Color that uses when the item is disabled
class ChipGroupStyle extends _BaseGroupStyle {
  final Color? backgroundColorItem;
  final Color? disabledColor;
  final Color? selectedColorItem;
  final Color? textColor;
  final Color? selectedTextColor;
  final IconData? selectedIcon;
  final OutlinedBorder? shape;
  final OutlinedBorder? checkedShape;
  
  const ChipGroupStyle({
    required this.backgroundColorItem,
    required this.selectedColorItem,
    required this.textColor,
    required this.selectedTextColor,
    this.selectedIcon,
    this.disabledColor,
    this.shape,
    this.checkedShape,
    TextStyle? itemTitleStyle,
  }) : super(
          activeColor: selectedColorItem,
          groupTitleStyle: null,
          itemTitleStyle: itemTitleStyle,
          subItemTitleStyle: null,
        );

  const ChipGroupStyle.minimize({
    this.backgroundColorItem = Colors.grey,
    this.selectedColorItem = Colors.black,
    this.textColor = Colors.black,
    this.selectedTextColor = Colors.white,
    this.selectedIcon = Icons.done,
    this.disabledColor = Colors.grey,
    this.shape,
    this.checkedShape,
    TextStyle? itemTitleStyle,
  }) : super(
          activeColor: selectedColorItem,
          groupTitleStyle: null,
          itemTitleStyle: itemTitleStyle,
          subItemTitleStyle: null,
        );
}

///
/// class [SwitchGroupStyle]   for style text in  [SimpleGroupedSwitch]
class SwitchGroupStyle extends _BaseGroupStyle {
  SwitchGroupStyle({
    Color? activeColor,
    TextStyle? itemTitleStyle,
  }) : super(
          activeColor: activeColor,
          itemTitleStyle: itemTitleStyle,
        );
}
