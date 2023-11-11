import 'package:client/components/admin_dashboard_appbar_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'admin_dashboard_actions.g.dart';

@riverpod
class AdminDashboardActions extends _$AdminDashboardActions {
  void reset(dynamic loggedUser) => state = [const AdminDashboardAppBarProfile()];
  void empty() => state = [];

  void setActions(List<Widget> widgets) => state = widgets;

  @override
  List<Widget> build() {
    return [];
  }
}
