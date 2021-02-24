import 'package:flutter/material.dart';
import 'package:iotbanknoteclassification/utils/size_helpers.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    Key key,
    this.btnText,
    this.btnColor,
    this.btnFunction,
    this.width,
  }) : super(key: key);

  final String btnText;
  final Color btnColor;
  final Function btnFunction;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: displayHeight(context) * 0.07,
      width: width,
      child: RaisedButton(
        color: btnColor,
        child: Text(
          btnText,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        padding: EdgeInsets.all(10),
        onPressed: btnFunction,
      ),
    );
  }
}
