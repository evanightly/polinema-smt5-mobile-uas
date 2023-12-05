import 'package:client/models/car.dart';
import 'package:client/models/car_body_type.dart';
import 'package:client/models/car_brand.dart';

class CarFilter {
  String? minPrice;
  String? maxPrice;
  String? minKm;
  String? maxKm;
  String? minYear;
  String? maxYear;
  CarBrand? brand;
  CarBodyType? bodyType;
  CarTransmission? transmission;
  CarCondition? condition;

  CarFilter({
    this.minPrice,
    this.maxPrice,
    this.minKm,
    this.maxKm,
    this.minYear,
    this.maxYear,
    this.brand,
    this.bodyType,
    this.transmission,
    this.condition,
  });

  CarFilter.fromJson(Map<String, dynamic> json) {
    minPrice = json['min_price'];
    maxPrice = json['max_price'];
    minKm = json['min_km'];
    maxKm = json['max_km'];
    minYear = json['min_year'];
    maxYear = json['max_year'];
    brand = json['brand_id'];
    bodyType = json['body_type_id'];
    transmission = json['transmission'];
    condition = json['condition'];
  }

  Map<String, dynamic> toJson() {
    return {
      'min_price': minPrice,
      'max_price': maxPrice,
      'min_km': minKm,
      'max_km': maxKm,
      'min_year': minYear,
      'max_year': maxYear,
      'brand_id': brand?.id,
      'body_type_id': bodyType?.id,
      'transmission': transmission?.name,
      'condition': condition?.name,
    };
  }
}
