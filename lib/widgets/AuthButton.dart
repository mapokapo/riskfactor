import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final String title;
  final Function onClick;
  final bool rounded;

  AuthButton({this.title, this.onClick, this.rounded = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: OutlinedButton(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Center(
            child: Text(
              title.toUpperCase(),
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
            ),
          ),
        ),
        onPressed: () {
          if (onClick != null) onClick();
        },
        style: OutlinedButton.styleFrom(
          elevation: 4,
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey.shade900
              : Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.all(Radius.circular(this.rounded ? 25.0 : 5.0))),
        ),
      ),
    );
  }
}
