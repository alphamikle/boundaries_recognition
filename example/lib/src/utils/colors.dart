import 'package:flutter/material.dart';

extension ExtendedBuildContext on BuildContext {
  ThemeData get theme => Theme.of(this);

  ColorScheme get colors => theme.colorScheme;

  MediaQueryData get query => MediaQuery.of(this);
}
