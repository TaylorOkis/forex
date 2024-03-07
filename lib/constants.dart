import 'package:flutter/material.dart';

import 'colors.dart';

final kButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.green.shade700,
  textStyle: const TextStyle(
    color: AppColor.textColor,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ),
  fixedSize: const Size(500, 60),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(50),
  ),
);

const kTextStyle = TextStyle(
  color: AppColor.textColor,
  fontSize: 20,
  fontStyle: FontStyle.italic,
  fontWeight: FontWeight.bold,
);
