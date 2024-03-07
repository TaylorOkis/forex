import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../colors.dart';

class NumberField extends StatelessWidget {
  final TextEditingController? textEditingController;
  final String? hintText;
  final bool enabled;
  final String? errorText;
  const NumberField({
    super.key,
    this.hintText,
    required this.textEditingController,
    required this.enabled,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      keyboardType: TextInputType.number,
      cursorWidth: 3,
      cursorHeight: 25,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$'))
      ],
      enabled: enabled,
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      style: const TextStyle(
        color: AppColor.textColor,
        fontSize: 19,
      ),
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            width: 3.0,
            color: AppColor.secondaryColor,
          ),
        ),
        disabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            width: 3.0,
            color: AppColor.secondaryColor,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
          borderSide: BorderSide(
            width: 3.0,
            color: AppColor.highLightColor,
          ),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(color: AppColor.textColor),
        errorText: errorText,
      ),
    );
  }
}
