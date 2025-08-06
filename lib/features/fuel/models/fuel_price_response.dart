import 'package:flow_360/features/fuel/models/fuel_price_model.dart';

class PaginatedFuelPriceResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<FuelPriceModel> results;

  PaginatedFuelPriceResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory PaginatedFuelPriceResponse.fromJson(Map<String, dynamic> json) {
    return PaginatedFuelPriceResponse(
      count: json['count'] ?? 0,
      next: json['next'],
      previous: json['previous'],
      results: (json['results'] as List)
          .map((item) => FuelPriceModel.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'count': count,
    'next': next,
    'previous': previous,
    'results': results.map((e) => e.toJson()).toList(),
  };
}
