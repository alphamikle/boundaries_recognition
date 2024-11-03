import '../edge_vision/settings.dart';

extension ExtendedSettingsList on List<Settings> {
  Settings average() => fold(Settings.zero(), (Settings sum, Settings current) => sum + current) / length;
}
