import 'package:client/providers/admin_auth.dart';
import 'package:client/providers/admin_dashboard_actions.dart';
import 'package:client/providers/admins.dart';
import 'package:client/screens/admin/sub_screens/widgets/admin_car/admin_admin/add_admin.dart';
import 'package:client/screens/admin/sub_screens/widgets/admin_car/admin_admin/delete_admin.dart';
import 'package:client/screens/admin/sub_screens/widgets/admin_car/admin_admin/edit_admin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class AdminManagementScreen extends ConsumerWidget {
  const AdminManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final admins = ref.watch(adminsProvider);
    final auth = ref.watch(adminAuthProvider).valueOrNull;
    final refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

    Future<void> refresh() async {
      await ref.read(adminsProvider.notifier).refresh();
    }

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        final dashboardActions =
            ref.read(adminDashboardActionsProvider.notifier);

        final isLoadingAdminData = admins.maybeWhen(
          loading: () => true,
          orElse: () => false,
        );

        dashboardActions.setActions(
          isLoadingAdminData
              ? [
                  const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                ]
              : [const AddAdmin()],
        );
      },
    );

    return admins.when(
      data: (data) {
        return Padding(
          padding: const EdgeInsets.all(4),
          child: LiquidPullToRefresh(
            key: refreshIndicatorKey,
            onRefresh: refresh,
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (ctx, index) {
                final admin = data[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: admin.imageProviderWidget,
                  ),
                  title: Text(
                    admin.name,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                  subtitle: Text(
                    admin.isSuperAdmin ? 'Super Admin' : 'Admin',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: admin.isSuperAdmin
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.secondary,
                        ),
                  ),
                  trailing: auth!.isSuperAdmin &&
                          auth.id != admin.id &&
                          !admin.isSuperAdmin
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            DeleteAdmin(admin: admin),
                            IconButton(
                              onPressed: () =>
                                  openEditAdminDialog(context, admin),
                              icon: const Icon(Icons.edit),
                              color: Colors.blue.shade400,
                            )
                          ],
                        )
                      : const SizedBox.shrink(),
                );
              },
            ),
          ),
        );
      },
      error: (error, stack) {
        return Center(child: Text('Something went wrong $error $stack'));
      },
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
