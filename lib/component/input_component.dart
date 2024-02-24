import 'package:camera_pj/constant/colors.dart';
import 'package:flutter/material.dart';

class InputComponent extends StatefulWidget {
  final String hintText;
  final Function(String) onSubmitted;

  InputComponent({Key? key, required this.hintText, required this.onSubmitted}) : super(key: key);

  @override
  _InputComponentState createState() => _InputComponentState();
}

class _InputComponentState extends State<InputComponent> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25),
      decoration: BoxDecoration(
        color: BACKGROUND_SECOND_COLOR,
        borderRadius: BorderRadius.circular(999),
      ),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
            fontFamily: 'OHSQUAREAIR'
          ),
          border: InputBorder.none,


        ),
        onSubmitted: (value) {
          widget.onSubmitted(value);
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
