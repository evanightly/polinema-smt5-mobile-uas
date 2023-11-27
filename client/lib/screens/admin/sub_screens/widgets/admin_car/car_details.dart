import 'package:client/helpers/decimal_formatter.dart';
import 'package:client/models/car.dart';
import 'package:flutter/material.dart';

void carDetails(BuildContext context, Car car) {
  showDialog(
    context: context,
    builder: (ctx) {
      return Scaffold(
        appBar: AppBar(
          title: Text(car.name),
        ),
        body: Column(
          children: [
            Image(image: car.imageProviderWidget),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                children: [
                  Text(car.name, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  if (car.description != null)
                    Text(
                      car.description!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  const SizedBox(height: 12),
                  Text(
                    'Price :\$ ${formatNumber(car.price)}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 12),
                  car.stock <= 0
                      ? Text(
                          'No Stock',
                          style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        )
                      : Text(
                          'Ready : ${car.stock} items',
                          style: const TextStyle(fontSize: 18),
                        ),
                  const SizedBox(height: 12),
                  const Text(
                    'Specification :',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 12),
                  GridView.count(
                    childAspectRatio: (1 / .7),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    padding: const EdgeInsets.all(0),
                    children: [
                      Card(
                        shadowColor: Colors.black54,
                        surfaceTintColor: Colors.white,
                        elevation: 6,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 18),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.directions_car,
                                size: 32,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(.5),
                              ),
                              const Spacer(),
                              Text(
                                'Condition',
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                              ),
                              const Spacer(),
                              Text(
                                car.condition.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        shadowColor: Colors.black54,
                        surfaceTintColor: Colors.white,
                        elevation: 6,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 18),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.calendar_month,
                                size: 32,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(.5),
                              ),
                              const Spacer(),
                              Text(
                                'Production Year',
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                car.year,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        shadowColor: Colors.black54,
                        surfaceTintColor: Colors.white,
                        elevation: 6,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 18),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.speed,
                                  size: 32,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(.5),
                                ),
                                const Spacer(),
                                Text(
                                  'Kilometer',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground),
                                ),
                                const Spacer(),
                                Row(
                                  children: [
                                    const Text(
                                      '0',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(width: 6),
                                    const Text(
                                      '-',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      '${formatNumber(car.km_max)} km',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )
                              ]),
                        ),
                      ),
                      Card(
                        shadowColor: Colors.black54,
                        surfaceTintColor: Colors.white,
                        elevation: 6,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 18),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.car_repair,
                                size: 32,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(.5),
                              ),
                              const Spacer(),
                              Text(
                                'Body Type',
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                              ),
                              const Spacer(),
                              Text(
                                car.body_type.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        shadowColor: Colors.black54,
                        surfaceTintColor: Colors.white,
                        elevation: 6,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 18),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.color_lens,
                                size: 32,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(.5),
                              ),
                              const Spacer(),
                              Text(
                                'Brand',
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                              ),
                              const Spacer(),
                              Text(
                                car.brand.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        shadowColor: Colors.black54,
                        surfaceTintColor: Colors.white,
                        elevation: 6,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 18),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.gas_meter,
                                size: 32,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(.5),
                              ),
                              const Spacer(),
                              Text(
                                'Fuel',
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                              ),
                              const Spacer(),
                              Text(
                                car.fuel.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        shadowColor: Colors.black54,
                        surfaceTintColor: Colors.white,
                        elevation: 6,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 18),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.settings,
                                size: 32,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(.5),
                              ),
                              const Spacer(),
                              Text(
                                'Transmission',
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                              ),
                              const Spacer(),
                              Text(
                                car.transmission.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        shadowColor: Colors.black54,
                        surfaceTintColor: Colors.white,
                        elevation: 6,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 18),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                car.status.name == 'Available'
                                    ? Icons.check_circle
                                    : Icons.cancel,
                                size: 32,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(.5),
                              ),
                              const Spacer(),
                              Text(
                                'Status',
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                              ),
                              const Spacer(),
                              Text(
                                car.status.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      );
    },
  );
}
