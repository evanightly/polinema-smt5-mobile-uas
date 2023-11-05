import 'package:client/components/dashboard_appbar_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminDashboardActionsProviderNotifier extends Notifier<List<Widget>> {
  void reset() => state = [const DashboardAppBarUser()];

  void setActions(List<Widget> widgets) => state = widgets;

  @override
  List<Widget> build() {
    return [];
  }
}

final adminDashboardActionsProvider =
    NotifierProvider<AdminDashboardActionsProviderNotifier, List<Widget>>(
  () => AdminDashboardActionsProviderNotifier(),
);
