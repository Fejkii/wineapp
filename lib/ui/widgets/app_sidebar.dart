import 'package:flutter/material.dart';
import 'package:wine_app/const/app_routes.dart';
import 'package:wine_app/const/app_strings.dart';

class AppSidebar extends StatelessWidget {
  const AppSidebar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            child: Text(
              AppStrings.appName,
              style: TextStyle(fontSize: 25),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.verified_user),
            title: const Text(AppStrings.profile),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text(AppStrings.settings),
            onTap: () {
              Navigator.popAndPushNamed(context, AppRoutes.settingsRoute);
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text(AppStrings.logout),
            onTap: () {
              // TODO: logout State - delete preferences, user token etc..
              Navigator.pushReplacementNamed(context, AppRoutes.loginRoute);
            },
          ),
        ],
      ),
    );
  }
}
