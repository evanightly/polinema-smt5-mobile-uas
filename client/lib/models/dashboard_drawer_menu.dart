import 'package:flutter/material.dart';

enum DashboardDrawerMenuPosition { top, bottom }

class DashboardDrawerMenu {
  final IconData icon;
  final String title;
  final Widget? page;
  final void Function()? onTap;

  const DashboardDrawerMenu({
    required this.title,
    required this.icon,
    this.page,
    this.onTap,
  });
}
