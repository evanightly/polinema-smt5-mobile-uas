import 'package:client/components/dashboard_appbar_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'admin_dashboard_actions.g.dart';

@riverpod
class AdminDashboardActions extends _$AdminDashboardActions {
  void reset() => state = [const DashboardAppBarUser()];
  void empty() => state = [];

  void setActions(List<Widget> widgets) => state = widgets;

  @override
  List<Widget> build() {
    return [];
  }
}
