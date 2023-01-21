import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import 'package:wine_app/const/app_strings.dart';

// TODO Not used, not work yet!
class AppSelectBox extends StatefulWidget {
  final List<Object> list;
  final String Function(dynamic) item;
  final String label;
  final dynamic selectedItem;
  final String? labelInBox;
  final bool? showSearchBox;
  final bool? isRequired;
  final String? errorMessage;

  const AppSelectBox({
    Key? key,
    required this.list,
    required this.item,
    required this.label,
    this.selectedItem,
    this.labelInBox,
    this.showSearchBox,
    this.isRequired,
    this.errorMessage,
  }) : super(key: key);

  @override
  State<AppSelectBox> createState() => _AppSelectBoxState();
}

class _AppSelectBoxState extends State<AppSelectBox> {
  dynamic selectedItem;
  @override
  void initState() {
    selectedItem = widget.selectedItem;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<dynamic>(
      popupProps: PopupProps.menu(showSearchBox: widget.showSearchBox ?? false),
      items: widget.list,
      itemAsString: widget.item,
      validator: (value) {
        if (widget.isRequired == true) {
          if (value == null) {
            return widget.errorMessage ?? AppStrings.selectBoxEmpty;
          }
        }
        return null;
      },
      onChanged: (Object? value) {
        setState(() {
          selectedItem = value!;
        });
      },
      selectedItem: selectedItem,
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.labelInBox ?? AppStrings.selectInSelectBox,
        ),
      ),
      clearButtonProps: const ClearButtonProps(isVisible: true),
      autoValidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}

// class AppDropdownSearch extends StatelessWidget {
  // final List<Object> list;
  // final dynamic selectedItem;
  // final String label;
  // final String? labelInBox;
  // final bool? showSearchBox;
  // final bool? isRequired;
  // final String? errorMessage;

//   const AppDropdownSearch({
//     Key? key,
//     required this.list,
//     required this.selectedItem,
//     required this.label,
//     this.labelInBox,
//     this.showSearchBox,
//     this.isRequired,
//     this.errorMessage,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     Object? selectedItem;
    
//     return DropdownSearch<Object>(
//       popupProps: PopupProps.menu(showSearchBox: showSearchBox ?? false),
//       items: list,
//       itemAsString: ((item) => ""),
//       validator: (value) {
//         if (isRequired == true) {
//           if (value == null) {
//             return errorMessage ?? AppStrings.selectBoxEmpty;
//           }
//         }
//         return null;
//       },
//       onChanged: (Object? value) {
//         setState(() {
//           selectedItem = value!;
//         });
//       },
//       selectedItem: selectedItem,
//       dropdownDecoratorProps: DropDownDecoratorProps(
//         dropdownSearchDecoration: InputDecoration(
//           labelText: label,
//           hintText: labelInBox ?? AppStrings.selectInSelectBox,
//         ),
//       ),
//       clearButtonProps: const ClearButtonProps(isVisible: true),
//       autoValidateMode: AutovalidateMode.onUserInteraction,
//     );
//   }
// }
