// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:client/models/car_body_type.dart';
import 'package:client/models/car_brand.dart';
import 'package:client/models/car_fuel.dart';
import 'package:flutter/material.dart';

enum CarTransmission { Automatic, Manual }

enum CarCondition { New, Used }

class Car {
  String? id;
  String name;
  CarBrand brand;
  CarBodyType bodyType;
  String year;
  double mileage;
  CarFuel fuel;
  num price;
  String? imageUrl;
  File? uploadImage;
  String? description;
  CarCondition condition;
  CarTransmission transmission;
  int stock;
  String? formattedPrice;

  Car({
    this.id,
    required this.name,
    required this.brand,
    required this.bodyType,
    required this.year,
    required this.fuel,
    required this.price,
    required this.mileage,
    this.imageUrl,
    this.uploadImage,
    this.description,
    required this.condition,
    required this.transmission,
    required this.stock,
    this.formattedPrice,
  });

  ImageProvider get imageProviderWidget {
    if (imageUrl == 'null') {
      return const AssetImage('assets/images/car1_MustangGT.jpg');
    }
    return CachedNetworkImageProvider(imageUrl!);
  }

  factory Car.fromJson(Map<String, dynamic> json) {
    final id = json['id'].toString();
    final name = json['name'].toString();
    final brand = CarBrand.fromJson(json['car_brand']);
    final bodyType = CarBodyType.fromJson(json['car_body_type']);
    final year = json['year'].toString();
    final mileage = double.parse(json['mileage'].toString());
    final fuel = CarFuel.fromJson(json['car_fuel']);
    final price = num.parse(json['price'].toString());
    final imageUrl = json['image_url'].toString();
    final description = json['description'].toString();
    final transmission =
        CarTransmission.values.byName(json['transmission'].toString());
    final condition = CarCondition.values.byName(json['condition']);
    final stock = int.parse(json['stock'].toString());
    final formattedPrice = json['formatted_price'].toString();

    return Car(
      id: id,
      name: name,
      brand: brand,
      bodyType: bodyType,
      year: year,
      mileage: mileage,
      fuel: fuel,
      price: price,
      imageUrl: imageUrl,
      description: description,
      condition: condition,
      transmission: transmission,
      stock: stock,
      formattedPrice: formattedPrice,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand.name,
      'body_type': bodyType.name,
      'year': year,
      'mileage': mileage,
      'fuel': fuel.name,
      'price': price,
      'image_url': imageUrl,
      'description': description,
      'condition': condition.name,
      'transmission': transmission.name,
      'stock': stock,
    };
  }
}
