import 'package:client/components/dashboard_appbar_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminDashboardActionsProviderNotifier
    extends StateNotifier<List<Widget>> {
  AdminDashboardActionsProviderNotifier() : super([]);

  void reset() => state = [const DashboardAppBarUser()];

  void setActions(List<Widget> widgets) => state = widgets;
}

final adminDashboardActionsProvider =
    StateNotifierProvider<AdminDashboardActionsProviderNotifier, List<Widget>>(
  (ref) => AdminDashboardActionsProviderNotifier(),
);
