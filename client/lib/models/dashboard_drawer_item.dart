import 'package:flutter/material.dart';

class DashboardDrawerItem {
  final String title;
  final IconData icon;
  final Widget? component;
  final Function()? onTap; // Override onTap function

  const DashboardDrawerItem({
    required this.title,
    required this.icon,
    this.component,
    this.onTap,
  });
}
