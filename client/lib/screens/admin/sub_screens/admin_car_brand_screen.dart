import 'package:client/models/car_brand.dart';
import 'package:client/providers/admin_auth.dart';
import 'package:client/providers/admin_dashboard_actions.dart';
import 'package:client/providers/car_brands.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class AdminCarBrandScreen extends ConsumerWidget {
  const AdminCarBrandScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final carBrands = ref.watch(carBrandsProvider);
    final auth = ref.watch(adminAuthProvider);
    final refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
    Future<void> refresh() async {
      await ref.read(carBrandsProvider.notifier).refresh();
    }

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        final dashboardActions =
            ref.read(adminDashboardActionsProvider.notifier);

        final isLoadingCarBrandData = carBrands.maybeWhen(
          loading: () => true,
          orElse: () => false,
        );

        dashboardActions.setActions(
          isLoadingCarBrandData
              ? [
                  const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                ]
              : [_AddCarBrand()],
        );
      },
    );

    return carBrands.when(data: (data) {
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
                    ? _CarBrandActions(item)
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

class _CarBrandActions extends ConsumerWidget {
  const _CarBrandActions(this.carBrand);
  final CarBrand carBrand;

  void openEditDialog(BuildContext context, WidgetRef ref) {
    var nameController = TextEditingController(text: carBrand.name);

    void update() {
      ref.read(carBrandsProvider.notifier).put(
            CarBrand(
              id: carBrand.id,
              name: nameController.text,
            ),
          );

      ElegantNotification.success(
        title: const Text("Update"),
        description: Text("${carBrand.name} has been updated"),
        background: Theme.of(context).colorScheme.background,
      ).show(context);
      Navigator.of(context).pop();
    }

    showDialog(
      context: context,
      builder: (ctx) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Edit Car Brand'),
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
      ref.read(carBrandsProvider.notifier).delete(carBrand);
      ElegantNotification.success(
        title: const Text("Delete"),
        description: Text("${carBrand.name} has been deleted"),
        background: Theme.of(context).colorScheme.background,
      ).show(context);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (carBrand.cars.isEmpty)
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

class _AddCarBrand extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void openAddDialog(BuildContext context, Function add) {
      var nameController = TextEditingController();

      void add() {
        final carBrands = ref.read(carBrandsProvider.notifier);
        carBrands.create(CarBrand(name: nameController.text));

        ElegantNotification.success(
          title: const Text("Create"),
          description: Text("${nameController.text} has been created"),
          background: Theme.of(context).colorScheme.background,
        ).show(context);

        Navigator.of(context).pop();
      }

      showDialog(
        context: context,
        builder: (ctx) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Add Car Brand'),
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
