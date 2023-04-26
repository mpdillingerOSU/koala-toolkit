import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gaming_toolkit/components/tickers/aesthetics/ticker_lighting_theme.dart';
import 'package:gaming_toolkit/pages/koala_toolkit_pages/popups/koala_alert.dart';
import 'package:gaming_toolkit/user_preferences.dart';

import '../../components/general/koala_snack_bar.dart';

abstract class KoalaPage extends StatefulWidget {
  const KoalaPage({
    super.key,
  });
}

abstract class KoalaPageState<T extends KoalaPage> extends State<T> {
  late int _maxUndos;
  late int _dragScrollSpeed;
  late TickerLightingTheme _lightingTheme;

  bool _isLoading = false;

  @override
  initState() {
    super.initState();
    _maxUndos = UserPreferences.getMaxUndos();
    _dragScrollSpeed = UserPreferences.getDragScrollSpeed();
    _lightingTheme = UserPreferences.getLightingTheme();
  }

  @protected
  int get maxUndos => _maxUndos;

  @protected
  set maxUndos(int val) => setState(() {
        _maxUndos = val;
      });

  @protected
  int get dragScrollSpeed => _dragScrollSpeed;

  @protected
  set dragScrollSpeed(int val) => setState(() {
        _dragScrollSpeed = val;
      });

  @protected
  TickerLightingTheme get lightingTheme => _lightingTheme;

  @protected
  set lightingTheme(TickerLightingTheme theme) => setState(() {
        _lightingTheme = theme;
      });

  ///Returns whether or not changes have been made to any settings. Getter is
  ///used in place of a simple bool flag, to ensure that cases where values
  ///have been changed and then later reverted back to their original values
  ///results in the appropriate return value of false.
  @protected
  get haveBeenChanges =>
      _maxUndos != UserPreferences.getMaxUndos() ||
      _dragScrollSpeed != UserPreferences.getDragScrollSpeed() ||
      _lightingTheme != UserPreferences.getLightingTheme();

  @protected
  void applyNewSettings() {
    if (haveBeenChanges) {
      setState(() {
        _maxUndos = UserPreferences.getMaxUndos();
        _dragScrollSpeed = UserPreferences.getDragScrollSpeed();
        _lightingTheme = UserPreferences.getLightingTheme();
      });
    }
  }

  @protected
  set isLoading(bool val) => _isLoading = val;

  @protected
  bool get isLoading => _isLoading;

  @protected
  Future<dynamic> pushPage(KoalaPage page, {String? routeName}) async {
    dynamic result = await Navigator.push(
      context,
      MaterialPageRoute(
        settings: routeName != null ? RouteSettings(name: routeName) : null,
        builder: (context) => page,
      ),
    );

    applyNewSettings();

    return result;
  }

  @protected
  Future<dynamic> pushNamedPage(String routeName) async {
    dynamic result = await Navigator.pushNamed(context, routeName);
    applyNewSettings();
    return result;
  }

  @protected
  Future<void> popToLandingPage() async {
    final bool confirm = await showDialog(
          context: context,
          builder: (context) => const KoalaAlert(
            title: 'Close Project',
            text:
                'Do you wish to close the project and return to the landing page?',
          ),
        ) ??
        false;

    if (confirm && mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/projects',
        (route) => false,
      );
    }
  }

  @protected
  void displaySnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(KoalaSnackBar(context, message));
  }

  Future<void> subRefresh();

  @protected
  Future<void> refreshPage(
    Future<void> Function() operation,
  ) async {
    setState(() => isLoading = true);

    Stopwatch stopwatch = Stopwatch();
    int delayPriority = 1250;
    stopwatch.start();

    await operation();
    await subRefresh();

    if (stopwatch.elapsedMilliseconds > delayPriority) {
      setState(() => isLoading = false);
    } else {
      await Future.delayed(
        Duration(milliseconds: delayPriority - stopwatch.elapsedMilliseconds),
        () {
          setState(() => isLoading = false);
        },
      );
    }
  }

  @protected
  Widget loadingScreen() {
    double screenHeight = MediaQuery.of(context).size.height;
    return Visibility(
      visible: _isLoading,
      child: Container(
        color: Colors.black54,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SpinKitCircle(
                size: screenHeight * .15,
                color: Colors.white,
              ),
              Text(
                'Loading...',
                style: TextStyle(
                  fontFamily: 'Sans Source Pro',
                  color: Colors.white,
                  fontSize: screenHeight * .0375,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
