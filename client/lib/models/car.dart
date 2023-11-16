// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'dart:io';

import 'package:client/models/car_body_type.dart';
import 'package:client/models/car_brand.dart';
import 'package:client/models/car_fuel.dart';
import 'package:client/providers/diohttp.dart';

enum CarTransmission { Automatic, Manual }

enum CarStatus { Available, Sold }

enum CarCondition { New, Used }

class Car {
  String? id;
  String name;
  CarBrand brand;
  CarBodyType body_type;
  String year;
  num km_min;
  num km_max;
  CarFuel fuel;
  num price;
  String? image;
  File? uploadImage;
  String? description;
  CarCondition condition;
  CarTransmission transmission;
  CarStatus status;

  // constructor using named parameter
  Car({
    this.id,
    required this.name,
    required this.brand,
    required this.body_type,
    required this.year,
    required this.km_min,
    required this.km_max,
    required this.fuel,
    required this.price,
    this.image,
    this.uploadImage,
    this.description,
    required this.condition,
    required this.transmission,
    required this.status,
  });

  String get imageUrl {
    String imageUrl = '';
    if (image == null) {
      return imageUrl;
    }

    if (image!.startsWith('http')) {
      return image!;
    } else {
      return 'http://$ipv4/polinema-smt5-mobile-uas/server/public/storage/images/cars/$image';
    }
  }

  // convert json to object
  factory Car.fromJson(Map<String, dynamic> json) {
    final id = json['id'].toString();
    final name = json['name'].toString();
    final brand = CarBrand.fromJson(json['brand']);
    final body_type = CarBodyType.fromJson(json['body_type']);
    final year = json['year'].toString();
    final km_min = num.parse(json['km_min'].toString());
    final km_max = num.parse(json['km_max'].toString());
    final fuel = CarFuel.fromJson(json['fuel']);
    final price = num.parse(json['price'].toString());
    final image = json['image'].toString();
    final description = json['description'].toString();
    final transmission =
        CarTransmission.values.byName(json['transmission'].toString());
    final status = CarStatus.values.byName(json['status']);
    final condition = CarCondition.values.byName(json['condition']);

    return Car(
      id: id,
      name: name,
      brand: brand,
      body_type: body_type,
      year: year,
      km_min: km_min,
      km_max: km_max,
      fuel: fuel,
      price: price,
      image: image,
      description: description,
      condition: condition,
      transmission: transmission,
      status: status,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand.name,
      'body_type': body_type.name,
      'year': year,
      'km_min': km_min,
      'km_max': km_max,
      'fuel': fuel.name,
      'price': price,
      'image': image,
      'description': description,
      'condition': condition.toString(),
      'transmission': transmission.toString(),
      'status': status.toString(),
    };
  }
}
