import 'package:flutter/material.dart';

class ErrorNotification extends StatelessWidget {
  String errorText;
  ErrorNotification({super.key, required this.errorText});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40,
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(7)),
        color: Colors.red.shade900,
      ),
      child: Text(
        errorText,
        style: const TextStyle(
            fontSize: 16.5, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}
