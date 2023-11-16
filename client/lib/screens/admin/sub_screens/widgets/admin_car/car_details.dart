import 'package:client/helpers/decimal_formatter.dart';
import 'package:client/models/car.dart';
import 'package:client/providers/diohttp.dart';
import 'package:flutter/material.dart';

void carDetails(BuildContext context, Car car) {
  const double circularRadius = 16;
  showDialog(
    context: context,
    builder: (ctx) {
      return Scaffold(
        appBar: AppBar(
          title: Text(car.name),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(circularRadius),
                child: Image.network(
                  car.image!.startsWith('http')
                      ? car.image!
                      : 'http://$ipv4/polinema-smt5-mobile-uas/server/public/storage/images/cars/${car.image!}',
                  fit: BoxFit.cover,
                  width: 120,
                  height: 200,
                ),
              ),
              const SizedBox(height: 14),
              Row(children: [const Text('Name : '), Text(car.name)]),
              const SizedBox(height: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Description : '),
                  car.description != null
                      ? Text(car.description!)
                      : const SizedBox.shrink()
                ],
              ),
              const SizedBox(height: 14),
              Text('Price: ${formatNumber(car.price)}'),
              const SizedBox(height: 14),
              Text('Brand: ${car.brand.name}'),
              const SizedBox(height: 14),
              Text('Body Type: ${car.body_type.name}'),
              const SizedBox(height: 14),
              Text('Production Year: ${car.year}'),
              const SizedBox(height: 14),
              Text(
                'Kilometer: ${formatNumber(car.km_min)} - ${formatNumber(car.km_max)}km',
              ),
              const SizedBox(height: 14),
              Text('Fuel: ${car.fuel.name}'),
              const SizedBox(height: 14),
              Text('Condition: ${car.condition.name}'),
              const SizedBox(height: 14),
              Text('Transmission: ${car.transmission.name}'),
              const SizedBox(height: 14),
              Text('Status: ${car.status.name}'),
            ],
          ),
        ),
      );
    },
  );
}
