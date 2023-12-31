import 'package:client/helpers/decimal_formatter.dart';
import 'package:client/models/car.dart';
import 'package:client/providers/cars.dart';
import 'package:client/providers/user_carts.dart';
import 'package:client/providers/user_transactions.dart';
import 'package:client/screens/user/widgets/user_main/car_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class UserMainScreen extends ConsumerStatefulWidget {
  const UserMainScreen({super.key});

  @override
  ConsumerState<UserMainScreen> createState() => _UserMainScreenState();
}

class _UserMainScreenState extends ConsumerState<UserMainScreen> {
  bool _isLoading = false;
  int _page = 1;
  final _listViewKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        setState(() {
          _page++;
          _isLoading = true;
        });
        await ref
            .read(carsProvider.notifier)
            .getPagination(_page)
            .then((value) {
          setState(() {
            _isLoading = false;
          });
        });
      }
    });
    final refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
    final cars = ref.watch(carsProvider);

    Future<void> onRefresh() async {
      setState(() {
        _page = 1;
      });
      await ref.read(carsProvider.notifier).refresh();
      await ref.read(userTransactionsProvider.notifier).refresh();
      await ref.read(userCartsProvider.notifier).refresh();
    }

    void openCarDetailsScreen(Car car) {
      Navigator.push(
        context,
        PageRouteBuilder(
          opaque: false,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.ease;

            final tween = Tween(begin: begin, end: end).chain(CurveTween(
              curve: curve,
            ));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          pageBuilder: (context, _, __) {
            return CarDetailsScreen(car: car);
          },
        ),
      );
    }

    return LiquidPullToRefresh(
      key: refreshIndicatorKey,
      onRefresh: onRefresh,
      child: ListView(
        key: _listViewKey,
        controller: scrollController,
        children: [
          Container(
            height: 140,
            alignment: Alignment.bottomCenter,
            margin: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage('assets/images/car2_Porsche.jpg'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 6, bottom: 6),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                color: Colors.black54,
              ),
              child: Text(
                'New Arrival',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.white),
              ),
            ),
          ),
          cars.when(
            data: (data) {
              return Container(
                margin: const EdgeInsets.only(left: 15, right: 15),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cars.asData?.value.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    mainAxisExtent: 275,
                  ),
                  itemBuilder: (context, index) {
                    final car = cars.asData?.value[index];
                    return InkWell(
                      onTap: car!.stock <= 0
                          ? null
                          : () {
                              openCarDetailsScreen(car);
                            },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 150,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: car.imageProviderWidget,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    car.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '\$ ${formatNumber(car.price)}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(color: Colors.black87),
                                  ),
                                  const SizedBox(height: 11),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Badge(
                                        largeSize: 20,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
                                        backgroundColor:
                                            car.condition.name == 'New'
                                                ? Colors.green
                                                : Colors.orange,
                                        label: Text(
                                          car.condition.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                color: Colors.white,
                                              ),
                                        ),
                                      ),
                                      Text(
                                        car.stock <= 0
                                            ? 'Out of stock'
                                            : 'Available: ${car.stock}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              color: car.stock <= 0
                                                  ? Colors.red
                                                  : Colors.black87,
                                            ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
            error: ((error, stackTrace) {
              return Center(child: Text(error.toString()));
            }),
            loading: () {
              return const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: CircularProgressIndicator()),
                ],
              );
            },
          ),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
