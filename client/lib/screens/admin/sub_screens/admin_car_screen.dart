import 'package:client/helpers/decimal_formatter.dart';
import 'package:client/providers/admin_dashboard_actions.dart';
import 'package:client/providers/cars.dart';
import 'package:client/providers/diohttp.dart';
import 'package:client/screens/admin/sub_screens/widgets/admin_car/add_car.dart';
import 'package:client/screens/admin/sub_screens/widgets/admin_car/car_details.dart';
import 'package:client/screens/admin/sub_screens/widgets/admin_car/delete_car.dart';
import 'package:client/screens/admin/sub_screens/widgets/admin_car/edit_car.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const double _circularRadius = 6;

class AdminCarScreen extends ConsumerWidget {
  const AdminCarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cars = ref.watch(carsProvider);

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        final dashboardActions =
            ref.read(adminDashboardActionsProvider.notifier);

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
        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (ctx, index) {
            final car = data[index];

            return Dismissible(
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.endToStart) {
                  editCar(context, car);
                  return false;
                } else {
                  final isConfirmed = await deleteCar(context);
                  if (isConfirmed) {
                    final isDeleted =
                        await ref.read(carsProvider.notifier).delete(car.id!);
                    if (isDeleted) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${car.name} deleted'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    } else {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to delete ${car.name}'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    }
                  }
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
                        car.imagePath != null
                            ? _CarImage(car.imagePath!)
                            : const SizedBox.shrink(),
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
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
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

class _CarImage extends StatelessWidget {
  const _CarImage(this.imageUrl);

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    Widget image = const SizedBox.shrink();

    if (imageUrl.isNotEmpty) {
      image = ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(_circularRadius),
          bottomLeft: Radius.circular(_circularRadius),
        ),
        child: Image.network(
          imageUrl.startsWith('http')
              ? imageUrl
              : 'http://$ipv4/polinema-smt5-mobile-uas/server/public/storage/images/cars/$imageUrl',
          fit: BoxFit.cover,
          width: 120,
          height: 80,
        ),
      );
    }

    return image;
  }
}
