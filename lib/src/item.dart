abstract class BaseItem {
  bool checked;
  bool isDisabled;

  BaseItem({
    this.checked,
    this.isDisabled,
  });
}

class Item extends BaseItem {
  String title;

  Item({
    this.title,
    checked,
    isDisabled = false,
  }) : super(
          checked: checked,
          isDisabled: isDisabled,
        );
}

class CustomItem<T> extends BaseItem {
  final T data;

  CustomItem({
    this.data,
    checked,
    isDisabled = false,
  }) : super(
          checked: checked,
          isDisabled: isDisabled,
        );
}
