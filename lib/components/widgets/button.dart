import 'package:flutter/material.dart';

Widget alohaButton(String text, Function() onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      height: 48,
      decoration: const BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.all(Radius.circular(16))),
      alignment: Alignment.center,
      child: Text(text),
    ),
  );
}
