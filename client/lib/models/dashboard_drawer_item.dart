import 'package:flutter/material.dart';

class DashboardDrawerItem {
  final String title;
  final IconData icon;
  final Widget? component;

  const DashboardDrawerItem({required this.title, required this.icon, this.component});
}