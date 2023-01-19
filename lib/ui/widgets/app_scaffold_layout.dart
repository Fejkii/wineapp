import 'package:flutter/material.dart';
import 'package:wine_app/const/app_values.dart';
import 'package:wine_app/ui/widgets/app_sidebar.dart';

class AppScaffoldLayout extends StatefulWidget {
  final Widget body;
  final AppBar? appBar;
  final bool? hasSidebar;
  const AppScaffoldLayout({
    Key? key,
    required this.body,
    this.appBar,
    this.hasSidebar,
  }) : super(key: key);

  @override
  State<AppScaffoldLayout> createState() => _AppScaffoldLayoutState();
}

class _AppScaffoldLayoutState extends State<AppScaffoldLayout> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        drawer: widget.hasSidebar != null && widget.hasSidebar == true ? AppSidebar() : null,
        appBar: widget.appBar,
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppPadding.p20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                widget.body,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
