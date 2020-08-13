import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/provider/asset_flare.dart';
import 'package:flutter/material.dart';

/// CirculaireCheckbox is item to make checkbox circulaire
class CirculaireCheckbox extends StatelessWidget {
  final String _circulaireCheckbox =
      "packages/checkbox_grouped/assets/check.flr";
  final String _circulaireBackgroundCheckbox =
      "packages/checkbox_grouped/assets/background_check.flr";
  final bool isChecked;
  final Color color;

  CirculaireCheckbox({this.isChecked, this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 32,
      child: Stack(
        children: <Widget>[
          FlareActor.asset(
            AssetFlare(
                name: _circulaireBackgroundCheckbox,
                bundle: DefaultAssetBundle.of(context)),
            animation: isChecked ? "To_Checked" : "To_Unchecked",
            snapToEnd: false,
            color: !isChecked ? Colors.grey[300] : color,
          ),
          FlareActor.asset(
            AssetFlare(
                name: _circulaireCheckbox,
                bundle: DefaultAssetBundle.of(context)),
            animation: isChecked ? "To_Checked" : "To_Unchecked",
            snapToEnd: false,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
