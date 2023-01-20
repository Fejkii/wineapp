import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wine_app/app/dependency_injection.dart';
import 'package:wine_app/bloc/vineyard/vineyard_cubit.dart';
import 'package:wine_app/const/app_strings.dart';
import 'package:wine_app/const/app_values.dart';

import 'package:wine_app/model/base/vineyard_model.dart';
import 'package:wine_app/ui/vineyard/vineyard_detail_view.dart';
import 'package:wine_app/ui/vineyard/vineyard_record_detail_view.dart';
import 'package:wine_app/ui/vineyard/vineyard_record_list_view.dart';
import 'package:wine_app/ui/widgets/app_buttons.dart';
import 'package:wine_app/ui/widgets/app_scaffold_layout.dart';

class VineyardView extends StatefulWidget {
  final VineyardModel vineyard;
  const VineyardView({
    Key? key,
    required this.vineyard,
  }) : super(key: key);

  @override
  State<VineyardView> createState() => _VineyardViewState();
}

class _VineyardViewState extends State<VineyardView> {
  final VineyardCubit vineyardCubit = instance<VineyardCubit>();
  late VineyardModel vineyard;

  @override
  void initState() {
    vineyard = widget.vineyard;
    super.initState();
  }

  void _getData() {
    vineyardCubit.getVineyard(vineyard.id);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VineyardCubit, VineyardState>(
      builder: (context, state) {
        return AppScaffoldLayout(
          body: _bodyWidget(),
          appBar: AppBar(
            title: Text(vineyard.title),
            actions: [
              AppIconButton(
                iconButtonType: IconButtonType.edit,
                onPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VineyardDetailView(vineyard: vineyard),
                    ),
                  ).then((value) => _getData());
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _bodyWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppLoginButton(
          title: AppStrings.addRecord,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VineyardRecordDetailView(vineyardId: vineyard.id),
              ),
            ).then((value) => _getData());
          },
        ),
        const SizedBox(height: AppMargin.m10),
        VineyardRecordListView(vineyardId: vineyard.id),
        const SizedBox(height: AppMargin.m20),
      ],
    );
  }
}
