import 'package:flutter/material.dart';
import 'package:wine_app/const/app_strings.dart';
import 'package:wine_app/const/app_values.dart';

class AppDatePicker extends StatefulWidget {
  final TextEditingController controller;
  final String? label;
  final DateTime? initDate;
  final bool? isRequired;
  final bool? setIcon;
  const AppDatePicker({
    Key? key,
    required this.controller,
    this.label,
    this.initDate,
    this.isRequired,
    this.setIcon,
  }) : super(key: key);

  @override
  State<AppDatePicker> createState() => _AppDatePickerState();
}

class _AppDatePickerState extends State<AppDatePicker> {
  late DateTime selectedDate;
  DateTime firstDate = DateTime(1900);
  DateTime lastDate = DateTime(2100);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        prefixIcon: widget.setIcon != null ? const Icon(Icons.calendar_today, size: 20) : null,
        labelText: widget.label != null ? widget.label! : AppStrings.date,
        border: const OutlineInputBorder(),
      ),
      readOnly: true,
      onTap: () async {
        setState(() {
          if (widget.controller.text != AppConstant.EMPTY && widget.controller.text.isNotEmpty) {
            selectedDate = DateTime.parse(widget.controller.text);
          } else {
            selectedDate = DateTime.now();
          }
        });

        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: firstDate,
          lastDate: lastDate,
          confirmText: AppStrings.ok,
          cancelText: AppStrings.cancel,
          helpText: AppStrings.selectDate,
        );

        if (pickedDate != null) {
          setState(() {
            widget.controller.text = pickedDate.toString();
          });
        }
      },
    );
  }
}
