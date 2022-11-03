import 'package:aps_dsd/src/ui/widgets/text_app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ButtonApp extends StatelessWidget {
  const ButtonApp({
    Key? key,
    this.width = 300,
    this.height = 200,
    this.onTap,
    this.text = 'Avaliar',
  }) : super(key: key);

  final double width;
  final double height;
  final String text;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(context.width * 0.1), color: Colors.blueAccent),
          child: Center(
              child: TextApp(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: context.width * 0.05,
              decoration: TextDecoration.none,
            ),
          ))),
    );
  }
}
