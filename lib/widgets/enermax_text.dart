import 'package:flutter/material.dart';

class EnermaxText extends StatefulWidget {
  MainAxisAlignment? mainAxisAlignment;
  Color? colorEner;
  EnermaxText({super.key, this.mainAxisAlignment, this.colorEner});

  @override
  State<EnermaxText> createState() => _EnermaxTextState();
}

class _EnermaxTextState extends State<EnermaxText> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: widget.mainAxisAlignment ?? MainAxisAlignment.center,
      children: [
        Text(
          'ENER',
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              fontStyle: FontStyle.italic,
              color: widget.colorEner ?? Colors.black38,
              letterSpacing: .02,
              fontFamily: ''),
        ),
        Text(
          'MAX',
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              fontStyle: FontStyle.italic,
              color: Colors.red.shade800,
              letterSpacing: .02),
        ),
      ],
    );
  }
}
