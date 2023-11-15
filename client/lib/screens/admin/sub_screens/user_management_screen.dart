import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:client/models/user.dart';
import 'package:client/providers/admin_dashboard_actions.dart';
import 'package:client/providers/cars.dart';
import 'package:client/providers/users.dart';
import 'package:client/screens/admin/sub_screens/widgets/admin_user/add_user.dart';
import 'package:client/screens/admin/sub_screens/widgets/admin_user/edit_user.dart';
import 'package:elegant_notification/elegant_notification.dart';
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
                  leading: _UserAvatar(data[index]),
                  title: Text(
                    data[index].name,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                  trailing: _UserActions(data[index]),
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

class _UserAvatar extends StatelessWidget {
  const _UserAvatar(this.user);
  final User user;

  @override
  Widget build(BuildContext context) {
    Widget image = const SizedBox.shrink();
    if (user.image!.isNotEmpty) {
      image = CircleAvatar(
        backgroundImage: user.imageProviderWidget,
      );
    }
    return image;
  }
}

class _UserActions extends ConsumerWidget {
  const _UserActions(this.user);
  final User user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void delete() {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.rightSlide,
        title: 'Are you sure?',
        desc:
            'You are about to delete ${user.name}\n\nWarning: this operation will delete all data related to this user',
        btnCancelOnPress: () {},
        btnOkOnPress: () async {
          try {
            await ref.read(usersProvider.notifier).delete(user.id!);
            if (context.mounted) {
              ElegantNotification.success(
                title: const Text("delete"),
                description: Text("${user.name} has been deleted"),
                background: Theme.of(context).colorScheme.background,
              ).show(context);
            }
          } catch (e) {
            if (context.mounted) {
              ElegantNotification.error(
                title: const Text("Failed"),
                description: Text("Failed to delete ${user.name}"),
                background: Theme.of(context).colorScheme.background,
              ).show(context);
            }
          }
        },
      ).show();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: delete,
          icon: const Icon(Icons.delete),
          color: Colors.red.shade400,
        ),
        IconButton(
          onPressed: () => openEditUserDialog(context, user),
          icon: const Icon(Icons.edit),
          color: Colors.blue.shade400,
        )
      ],
    );
  }
}
