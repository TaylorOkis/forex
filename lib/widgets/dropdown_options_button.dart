import 'package:flutter/material.dart';

import '../colors.dart';
import '../data models/dropdown_button_data.dart';

class DropDownOptionsButton extends StatefulWidget {
  final Function(String?) onChanged;
  final String value;
  final String? errorText;
  final Alignment textAlignment;
  const DropDownOptionsButton({
    super.key,
    required this.errorText,
    required this.onChanged,
    required this.value,
    required this.textAlignment,
  });

  @override
  State<DropDownOptionsButton> createState() => _DropDownOptionsButtonState();
}

class _DropDownOptionsButtonState extends State<DropDownOptionsButton> {
  final DropdownData _dropdownData = DropdownData();
  @override
  void initState() {
    // TODO: implement initState
    _dropdownData.convertItemsToString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField(
          alignment: widget.textAlignment,
          isDense: true,
          value: widget.value,
          dropdownColor: Colors.black,
          style: const TextStyle(color: AppColor.textColor, fontSize: 16),
          decoration: InputDecoration(
            errorText: widget.errorText,
          ),
          iconEnabledColor: AppColor.textColor,
          borderRadius: BorderRadius.circular(5),
          elevation: 10,
          items: _dropdownData.currencies.map((currency) {
            return DropdownMenuItem(
              value: currency,
              child: Text(currency),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              widget.onChanged(newValue);
            });
          },
        ),
      ),
    );
  }
}
