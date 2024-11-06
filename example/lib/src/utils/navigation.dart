import 'package:flutter/material.dart';

extension NavigationContext on BuildContext {
  Future<T?> pushScreen<T>(WidgetBuilder screen) async {
    final T? result = await nav.push(
      MaterialPageRoute<T>(
        builder: screen,
      ),
    );
    return result;
  }

  NavigatorState get nav => Navigator.of(this);

  void pop<T>([T? value]) => nav.pop<T>(value);
}
