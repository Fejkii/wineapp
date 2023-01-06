import 'package:flutter/material.dart';

import 'package:wine_app/const/app_strings.dart';
import 'package:wine_app/const/app_values.dart';
import 'package:wine_app/ui/widgets/app_texts.dart';

class AppListView extends StatelessWidget {
  final List listData;
  final IndexedWidgetBuilder itemBuilder;
  const AppListView({
    Key? key,
    required this.listData,
    required this.itemBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return listData.isNotEmpty
        ? ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: listData.length,
            itemBuilder: itemBuilder,
          )
        : Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                AppContentTitleText(text: AppStrings.emptyData, size: 20),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.search_off, size: 20),
                ),
              ],
            ),
          );
  }
}

class AppListViewItem extends StatelessWidget {
  final Widget itemBody;
  final Function()? onTap;
  const AppListViewItem({
    Key? key,
    required this.itemBody,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Center(
          heightFactor: 4,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.p20),
            child: itemBody,
          ),
        ),
      ),
    );
  }
}
