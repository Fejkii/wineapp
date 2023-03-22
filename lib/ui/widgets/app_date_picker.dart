import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  DateTime firstDate = DateTime(2000);
  DateTime lastDate = DateTime(2100);

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    if (widget.initDate != null) {
      selectedDate = widget.initDate!;
    }
    widget.controller.text = selectedDate.toString();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        prefixIcon: widget.setIcon != null ? const Icon(Icons.calendar_today, size: 20) : null,
        labelText: widget.label != null ? widget.label! : AppLocalizations.of(context)!.date,
        border: const OutlineInputBorder(),
      ),
      readOnly: true,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: firstDate,
          lastDate: lastDate,
          confirmText: AppLocalizations.of(context)!.ok,
          cancelText: AppLocalizations.of(context)!.cancel,
          helpText: AppLocalizations.of(context)!.selectDate,
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
