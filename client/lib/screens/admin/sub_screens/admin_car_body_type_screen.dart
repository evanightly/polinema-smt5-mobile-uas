import 'package:client/models/car_body_type.dart';
import 'package:client/providers/admin_auth.dart';
import 'package:client/providers/admin_dashboard_actions.dart';
import 'package:client/providers/car_body_types.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class AdminCarBodyTypeScreen extends ConsumerWidget {
  const AdminCarBodyTypeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final carBodyType = ref.watch(carBodyTypesProvider);
    final auth = ref.watch(adminAuthProvider);
    final refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
    Future<void> refresh() async {
      await ref.read(carBodyTypesProvider.notifier).refresh();
    }

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        final dashboardActions =
            ref.read(adminDashboardActionsProvider.notifier);

        final isLoadingCarBodyTypeData = carBodyType.maybeWhen(
          loading: () => true,
          orElse: () => false,
        );

        dashboardActions.setActions(
          isLoadingCarBodyTypeData
              ? [
                  const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                ]
              : [_AddCarBodyType()],
        );
      },
    );

    return carBodyType.when(data: (data) {
      return Padding(
        padding: const EdgeInsets.all(4),
        child: LiquidPullToRefresh(
          color: Theme.of(context).colorScheme.primary,
          key: refreshIndicatorKey,
          onRefresh: refresh,
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (ctx, index) {
              final item = data[index];
              return ListTile(
                title: Text(
                  item.name,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
                trailing: auth!.isSuperAdmin
                    ? _CarBodyTypeActions(item)
                    : const SizedBox.shrink(),
              );
            },
          ),
        ),
      );
    }, error: (error, stack) {
      return Center(child: Text('Something went wrong $error $stack'));
    }, loading: () {
      return const Center(child: CircularProgressIndicator());
    });
  }
}

class _CarBodyTypeActions extends ConsumerWidget {
  const _CarBodyTypeActions(this.carBodyType);
  final CarBodyType carBodyType;

  void openEditDialog(BuildContext context, WidgetRef ref) {
    var nameController = TextEditingController(text: carBodyType.name);

    void update() {
      ref.read(carBodyTypesProvider.notifier).put(
            CarBodyType(
              id: carBodyType.id,
              name: nameController.text,
            ),
          );
      Navigator.of(context).pop();
    }

    showDialog(
      context: context,
      builder: (ctx) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Edit Car Body Type'),
            actions: [
              IconButton(onPressed: update, icon: const Icon(Icons.check))
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 12),
            child: Form(
              child: Flex(
                direction: Axis.vertical,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: nameController,
                    autocorrect: false,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(hintText: 'Name'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void delete() {
      final carBodyTypes = ref.read(carBodyTypesProvider.notifier);
      carBodyTypes.delete(carBodyType);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (carBodyType.cars.isEmpty)
          IconButton(
            onPressed: delete,
            icon: const Icon(Icons.delete),
            color: Colors.red.shade400,
          ),
        IconButton(
          onPressed: () => openEditDialog(context, ref),
          icon: const Icon(Icons.edit),
          color: Colors.blue.shade400,
        )
      ],
    );
  }
}

class _AddCarBodyType extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void openAddDialog(BuildContext context, Function add) {
      var nameController = TextEditingController();

      void add() {
        final carBodyTypes = ref.read(carBodyTypesProvider.notifier);
        carBodyTypes.create(CarBodyType(name: nameController.text));
        Navigator.of(context).pop();
      }

      showDialog(
        context: context,
        builder: (ctx) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Add Car Body Type'),
              actions: [
                IconButton(onPressed: add, icon: const Icon(Icons.check))
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 12),
              child: Form(
                child: Flex(
                  direction: Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: nameController,
                      autocorrect: false,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(hintText: 'Name'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    return IconButton(
      onPressed: () => openAddDialog(context, () {}),
      icon: const Icon(Icons.add),
    );
  }
}
