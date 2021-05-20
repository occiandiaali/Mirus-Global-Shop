import 'package:flutter/material.dart';

class RoundIconButton extends StatelessWidget {
  final IconData icon;
  final Function onPress;
  final double iconSize;

  //const RoundIconButton({Key key}) : super(key: key);
  RoundIconButton({
    this.icon,
    this.onPress,
    this.iconSize});

  @override
  Widget build(BuildContext context) {
    //return Container();
    return RawMaterialButton(
        onPressed: onPress,
        constraints: BoxConstraints.tightFor(width: iconSize, height: iconSize),
        elevation: 6.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(iconSize * 0.2)),
          fillColor: Colors.deepPurple,
          child: Icon(
            icon,
            color: Colors.white,
            size: iconSize * 0.8,
          ),
    );
  }
} // class
