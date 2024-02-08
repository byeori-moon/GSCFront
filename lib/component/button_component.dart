import 'package:flutter/material.dart';
import '../constant/colors.dart';

class DefaultButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const DefaultButton(
      {super.key, required this.buttonText, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: BUTTON_BLUE,
            onPrimary: BUTTON_WHITE,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            )),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_fire_department_outlined,
              size: 20,
            ),
            SizedBox(
              width: 4,
            ),
            Text(
              buttonText,
              style: TextStyle(
                fontFamily: 'OHSQUARE',
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SecondButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const SecondButton(
      {super.key, required this.buttonText, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: Colors.white,
            onPrimary: BUTTON_BLUE,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
              side: BorderSide(
                color: BUTTON_BLUE,
                width: 1,
              )
            ),),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            buttonText,
            style: TextStyle(
              fontFamily: 'OHSQUARE',
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
