import 'package:cached_network_image/cached_network_image.dart';
import 'package:client/providers/admin_dashboard_actions.dart';
import 'package:client/providers/cars.dart';
import 'package:client/providers/users.dart';
import 'package:client/screens/admin/sub_screens/widgets/admin_user/add_user.dart';
import 'package:client/screens/admin/sub_screens/widgets/admin_user/delete_user.dart';
import 'package:client/screens/admin/sub_screens/widgets/admin_user/edit_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class UserManagementScreen extends ConsumerWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(usersProvider);
    final refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

    Future<void> refresh() async {
      await ref.read(usersProvider.notifier).refresh();
      await ref.read(carsProvider.notifier).refresh();
    }

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        final dashboardActions =
            ref.read(adminDashboardActionsProvider.notifier);

        final isLoadingUserData = users.maybeWhen(
          loading: () => true,
          orElse: () => false,
        );

        dashboardActions.setActions(
          isLoadingUserData
              ? [
                  const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                ]
              : [const AddUser()],
        );
      },
    );

    return users.when(
      data: (data) {
        return LiquidPullToRefresh(
          key: refreshIndicatorKey,
          onRefresh: refresh,
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(4),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                        CachedNetworkImageProvider(data[index].image_url!),
                  ),
                  title: Text(
                    data[index].name,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DeleteUser(user: data[index]),
                      IconButton(
                        onPressed: () =>
                            openEditUserDialog(context, data[index]),
                        icon: const Icon(Icons.edit),
                        color: Colors.blue.shade400,
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
      error: (_, error) {
        return Center(child: Text(_.toString()));
      },
      loading: () {
        return const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text('Please Wait...'),
            ],
          ),
        );
      },
    );
  }
}
