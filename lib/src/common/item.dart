/// base class item
/// [checked] : bool to get if item checked or not
/// [isDisabled] : bool to disabled or enable item to be selected or not
abstract class BaseItem {
  bool? checked;
  bool? isDisabled;

  BaseItem({
    this.checked,
    this.isDisabled,
  });
}

/// item class use it to build items in groupedCheckbox
/// [title] : string use it to sepecifie title of checkbox item
class Item extends BaseItem {
  final String? title;

  Item({
    this.title,
    checked,
    isDisabled = false,
  }) : super(
          checked: checked,
          isDisabled: isDisabled,
        );

  Item copy({
    title,
    checked,
    isDisabled = false,
  }) {
    return Item(
        title: title ?? this.title,
        checked: checked ?? this.checked,
        isDisabled: isDisabled ?? this.isDisabled);
  }
}

/// custom item class use it to build items in custom groupedCheckbox
/// [data] : generic variable to recuperate value of item
class CustomItem<T> extends BaseItem {
  final T? data;

  CustomItem({
    this.data,
    checked,
    isDisabled = false,
  }) : super(
          checked: checked,
          isDisabled: isDisabled,
        );

  CustomItem<T> copy({
    T? data,
    checked,
    isDisabled = false,
  }) {
    return CustomItem(
        data: data ?? this.data,
        checked: checked ?? this.checked,
        isDisabled: isDisabled ?? this.isDisabled);
  }
}
