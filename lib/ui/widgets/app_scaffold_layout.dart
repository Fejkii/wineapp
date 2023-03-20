import 'dart:async';
import 'dart:developer' as developer;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wine_app/const/app_strings.dart';
import 'package:wine_app/const/app_values.dart';
import 'package:wine_app/ui/theme/app_text_styles.dart';
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
  final Connectivity _connectivity = Connectivity();
  late ConnectivityResult _connectionStatus = ConnectivityResult.wifi;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  late bool _visible = false;

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }
    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
    if (result == ConnectivityResult.mobile || result == ConnectivityResult.wifi) {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _visible = false;
          });
        }
      });
    } else {
      setState(() {
        _visible = true;
      });
    }
  }

  Widget networkStatusBar() {
    return Visibility(
      visible: _visible,
      child: Container(
        width: double.infinity,
        color: _connectionStatus == ConnectivityResult.none ? Colors.red : Colors.green,
        height: 25,
        child: Center(
          child: Text(
            _connectionStatus == ConnectivityResult.none ? AppStrings.noInternetConnection : AppStrings.internetConnection,
            style: getBoldStyle(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        drawer: widget.hasSidebar != null && widget.hasSidebar == true ? AppSidebar() : null,
        appBar: widget.appBar,
        body: SingleChildScrollView(
          child: Column(
            children: [
              // networkStatusBar(),
              Container(
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
            ],
          ),
        ),
      ),
    );
  }
}
