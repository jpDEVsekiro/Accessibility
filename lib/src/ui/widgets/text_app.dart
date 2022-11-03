import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class TextApp extends StatelessWidget {
  const TextApp(this.text,
      {this.minFontSize = 12,
      this.maxFontSize = double.infinity,
      this.textAlign,
      this.maxLines,
      this.style,
      this.group,
      Key? key})
      : super(key: key);

  final String text;
  final double minFontSize;
  final double maxFontSize;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextStyle? style;
  final AutoSizeGroup? group;

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      text,
      minFontSize: minFontSize,
      maxFontSize: maxFontSize,
      textAlign: textAlign,
      maxLines: maxLines,
      style: style,
      group: group,
    );
  }
}
