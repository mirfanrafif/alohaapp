import 'package:flutter/material.dart';

InputDecoration alohaInputDecoration(String hintText) {
  return InputDecoration(
    hintText: hintText,
    filled: true,
    fillColor: alohaInputColor,
    contentPadding: const EdgeInsets.all(16),
    border: const OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.all(
        Radius.circular(16),
      ),
    ),
  );
}

SizedBox height16 = const SizedBox(
  height: 16,
);

const alohaInputColor = Color(0xFFF5F5F5);

const alohaRadius = BorderRadius.all(Radius.circular(16));
