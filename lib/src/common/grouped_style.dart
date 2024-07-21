import 'package:flutter/material.dart';

enum ChipsDirection {
  horizontal,
  vertical,
  wrap,
}

/// class [_BaseGroupedStyle]  base class for style groupedCheckbox,Switch,Chips
///
/// [activeColor]        : (Color) choose the color to use when this checkbox button is selected
///
/// [groupTitleStyle]    : (TextStyle) Text Style  that describe style of group title of group checkbox
///
/// [itemTitleStyle]     : (TextStyle) Text Style  that describe style of title of each item in  group checkbox
///
/// [subItemTitleStyle]  : (TextStyle) Text Style  that describe style of subtitle of each item in  group checkbox
abstract class _BaseGroupStyle {
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
/// class [GroupedStyle]   for styling class for  [SimpleGroupedCheckbox]
///
/// [isLeading] : (bool) put check zone on left of item
///
/// [helperGroupTitle] : (bool) hide/show checkbox in title to help all selection or deselection,use it when you want to disable checkbox in groupTitle default:`true`
///
/// [groupTitleAlignment] : (Alignment) align title of checkbox group checkbox default:`Alignment.center`

class GroupStyle extends _BaseGroupStyle {
  final AlignmentGeometry groupTitleAlignment;
  final bool isLeading;
  final bool helperGroupTitle;
  const GroupStyle({
    super.activeColor,
    super.groupTitleStyle,
    super.itemTitleStyle,
    super.subItemTitleStyle,
    this.groupTitleAlignment = Alignment.center,
    this.isLeading = false,
    this.helperGroupTitle = true,
  });
}

class ExpandableGroupStyle extends GroupStyle {
  final bool canTapOnHeader;
  final Duration animationDuration;
  final EdgeInsets expandedHeaderPadding;
  final Color? dividerColor;
  final double elevation;
  final Color? expandIconColor;
  final double materialGapSize;
  const ExpandableGroupStyle({
    super.activeColor,
    super.groupTitleStyle,
    super.itemTitleStyle,
    super.subItemTitleStyle,
    super.groupTitleAlignment,
    super.helperGroupTitle,
    super.isLeading,
    this.canTapOnHeader = false,
    this.animationDuration = const Duration(milliseconds: 200),
    this.expandedHeaderPadding = const EdgeInsets.symmetric(
      vertical: 16,
    ),
    this.dividerColor,
    this.elevation = 2,
    this.expandIconColor,
    this.materialGapSize = 16.0,
  });
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
  final ChipsDirection direction;
  final bool isScrolling;
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
    this.isScrolling = false,
    this.direction = ChipsDirection.wrap,
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
    this.isScrolling = false,
    this.direction = ChipsDirection.wrap,
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
  const SwitchGroupStyle({
    Color? activeColor,
    TextStyle? itemTitleStyle,
  }) : super(
          activeColor: activeColor,
          itemTitleStyle: itemTitleStyle,
        );
}
