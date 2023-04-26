import 'package:gaming_toolkit/components/drag_drop_column.dart';
import 'package:gaming_toolkit/components/tickers/aesthetics/ticker_lighting_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _kMaxUndosKey = 'maxUndos';
const int _kDefaultMaxUndos = 100;
const String _kDragScrollSpeedKey = 'dragScrollSpeed';
const int _kDefaultDragScroll = kDefaultDragScrollSpeed;
const String _kLightingThemeKey = 'lightingTheme';
const TickerLightingTheme _kDefaultLightingTheme =
    TickerLightingTheme.lightTheme;

class UserPreferences {
  static SharedPreferences? _preferences;

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
    if (_preferences!.get(_kMaxUndosKey) == null) {
      await setMaxUndos(_kDefaultMaxUndos);
    }
    if (_preferences!.get(_kDragScrollSpeedKey) == null) {
      await setDragScrollSpeed(_kDefaultDragScroll);
    }
    if (_preferences!.get(_kLightingThemeKey) == null) {
      await setLightingTheme(_kDefaultLightingTheme);
    }
  }

  static Future<void> setMaxUndos(int val) async =>
      await _preferences!.setInt(_kMaxUndosKey, val);

  static int getMaxUndos() {
    return _preferences!.getInt(_kMaxUndosKey)!;
  }

  static Future<void> setDragScrollSpeed(int val) async =>
      await _preferences!.setInt(_kDragScrollSpeedKey, val);

  static int getDragScrollSpeed() {
    return _preferences!.getInt(_kDragScrollSpeedKey)!;
  }

  static Future<void> setLightingTheme(
          TickerLightingTheme lightingTheme) async =>
      await _preferences!.setBool(
          _kLightingThemeKey, lightingTheme == TickerLightingTheme.darkTheme);

  static TickerLightingTheme getLightingTheme() {
    return _preferences!.getBool(_kLightingThemeKey)!
        ? TickerLightingTheme.darkTheme
        : TickerLightingTheme.lightTheme;
  }
}
