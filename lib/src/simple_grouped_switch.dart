import 'package:flutter/material.dart';

class SimpleGroupedSwitch<T> extends StatefulWidget {
  final List<String> itemsTitle;
  final List<String> preSelectionItems;
  final List<T> values;
  final bool isMutlipleSelection;

  SimpleGroupedSwitch({
    this.itemsTitle,
    this.values,
    this.preSelectionItems,
    this.isMutlipleSelection = true,
  });

  static SimpleGroupedSwitchState of<T>(BuildContext context,
      {bool nullOk = false}) {
    assert(context != null);
    assert(nullOk != null);
    final SimpleGroupedSwitchState<T> result =
        context.findAncestorStateOfType<SimpleGroupedSwitchState<T>>();
    if (nullOk || result != null) return result;
    throw FlutterError.fromParts(<DiagnosticsNode>[
      ErrorSummary(
          'SimpleGroupedSwitch.of() called with a context that does not contain an SimpleGroupedSwitch.'),
      ErrorDescription(
          'No SimpleGroupedSwitch ancestor could be found starting from the context that was passed to SimpleGroupedSwitch.of().'),
      context.describeElement('The context used was')
    ]);
  }

  @override
  State<StatefulWidget> createState() => SimpleGroupedSwitchState<T>();
}

class SimpleGroupedSwitchState<T> extends State<SimpleGroupedSwitch> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
