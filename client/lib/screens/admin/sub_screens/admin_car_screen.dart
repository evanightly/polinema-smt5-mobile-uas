import 'package:client/helpers/decimal_formatter.dart';
import 'package:client/providers/admin_dashboard_actions.dart';
import 'package:client/providers/cars.dart';
import 'package:client/screens/admin/sub_screens/widgets/admin_car/add_car.dart';
import 'package:client/screens/admin/sub_screens/widgets/admin_car/car_details.dart';
import 'package:client/screens/admin/sub_screens/widgets/admin_car/delete_car.dart';
import 'package:client/screens/admin/sub_screens/widgets/admin_car/edit_car.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

const double _circularRadius = 6;

class AdminCarScreen extends ConsumerWidget {
  const AdminCarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cars = ref.watch(carsProvider);
    final refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

    Future<void> refresh() async {
      await ref.read(carsProvider.notifier).refresh();
    }

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        final dashboardActions = ref.read(
          adminDashboardActionsProvider.notifier,
        );

        final isLoadingCarData = cars.maybeWhen(
          loading: () => true,
          orElse: () => false,
        );

        dashboardActions.setActions(
          isLoadingCarData
              ? [
                  const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                ]
              : [const AddCar()],
        );
      },
    );

    return cars.when(
      data: (data) {
        return LiquidPullToRefresh(
          key: refreshIndicatorKey,
          onRefresh: refresh,
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (ctx, index) {
              final car = data[index];

              return Dismissible(
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.endToStart) {
                    editCar(context, car);
                    return false;
                  } else {
                    deleteCar(context, ref, car);
                    return false;
                  }
                },
                background: Container(
                  padding: const EdgeInsets.only(left: 20),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.red.withOpacity(.2),
                        Colors.red,
                      ],
                    ),
                  ),
                  child: const Icon(Icons.delete),
                ),
                secondaryBackground: Container(
                  padding: const EdgeInsets.only(right: 20),
                  alignment: Alignment.centerRight,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue,
                        Colors.blue.withOpacity(.2),
                      ],
                    ),
                  ),
                  child: const Icon(Icons.edit),
                ),
                key: Key(car.name),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () => carDetails(context, car),
                    child: Card(
                      margin: const EdgeInsets.all(0),
                      surfaceTintColor: Theme.of(context)
                          .colorScheme
                          .inverseSurface
                          .withOpacity(.08),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(_circularRadius),
                          right: Radius.circular(_circularRadius),
                        ),
                      ),
                      child: Flex(
                        direction: Axis.horizontal,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(_circularRadius),
                              bottomLeft: Radius.circular(_circularRadius),
                            ),
                            child: Image(
                              image: car.imageProviderWidget,
                              fit: BoxFit.cover,
                              width: 120,
                              height: 80,
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(car.name),
                              const SizedBox(height: 4),
                              Text('\$ ${formatNumber(car.price)}'),
                            ],
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.only(right: 8),
                            child: car.stock <= 0
                                ? Text(
                                    'No Stock',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .error),
                                  )
                                : Text('${car.stock.toString()} left'),
                          )
                        ],
                      ),
                    ),
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
