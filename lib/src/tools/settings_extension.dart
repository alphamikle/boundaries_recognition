import '../edge_vision/edge_vision_settings.dart';

extension ExtendedSettingsList on List<EdgeVisionSettings> {
  EdgeVisionSettings average() => fold(EdgeVisionSettings.zero(), (EdgeVisionSettings sum, EdgeVisionSettings current) => sum + current) / length;
}
