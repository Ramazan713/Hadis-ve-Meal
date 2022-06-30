import 'package:flutter/material.dart';

class CustomRadio<T> extends StatelessWidget {
  final String label;
  final T value;
  final T selectedValue;
  final void Function(T selected) onClick;

  const CustomRadio(
      {Key? key,
      required this.label,
      required this.value,
      required this.selectedValue,
      required this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label),
      leading: Radio<T>(
        value: value,
        groupValue: selectedValue,
        onChanged: (newVal) {
          if (newVal != null) {
            onClick.call(newVal);
          }
        },
      ),
      onTap: () {
        onClick.call(value);
      },
    );
  }
}
