import '../edge_vision/settings.dart';

extension ExtendedSettingsList on List<EdgeVisionSettings> {
  EdgeVisionSettings average() => fold(EdgeVisionSettings.zero(), (EdgeVisionSettings sum, EdgeVisionSettings current) => sum + current) / length;
}
