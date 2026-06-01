import 'package:flutter/material.dart';
import 'package:todo_app/core/constants/app_breakpoints.dart';

enum ScreenSize { mobile, tablet, desktop }

ScreenSize screenSizeOf(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  if (AppBreakpoints.isDesktop(width)) return ScreenSize.desktop;
  if (AppBreakpoints.isTablet(width)) return ScreenSize.tablet;
  return ScreenSize.mobile;
}
