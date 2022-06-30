import 'package:flutter/material.dart';

class TopicTextButton extends StatelessWidget {
  final void Function() onPressed;
  final String title;
  const TopicTextButton({Key? key,required this.title,required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        title,
        style: Theme.of(context).textTheme.headline6,
      ),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.secondary),
          shape: MaterialStateProperty.all(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(13)),
            ),
          ),
          padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 7,horizontal: 7))
      ),
    );
  }
}
