import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wine_app/const/app_values.dart';
import 'package:wine_app/ui/theme/app_colors.dart';
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
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.search_off, size: 30),
                ),
                AppContentTitleText(text: AppLocalizations.of(context)!.emptyData),
              ],
            ),
          );
  }
}

class AppListViewItem extends StatelessWidget {
  final Widget itemBody;
  final Function()? onTap;
  final Function(BuildContext?)? onDelete;
  const AppListViewItem({
    Key? key,
    required this.itemBody,
    this.onTap,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      enabled: onDelete != null,
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: onDelete,
            backgroundColor: AppColors.red,
            foregroundColor: AppColors.white,
            icon: Icons.delete,
            label: AppLocalizations.of(context)!.delete,
            borderRadius: const BorderRadius.all(Radius.circular(AppRadius.r5)),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        child: Card(
          child: Center(
            heightFactor: 2.5,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppPadding.p20),
              child: itemBody,
            ),
          ),
        ),
      ),
    );
  }
}
