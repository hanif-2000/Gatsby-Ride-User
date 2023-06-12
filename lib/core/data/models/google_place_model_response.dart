import 'package:equatable/equatable.dart';

import 'google_place_model.dart';

class GooglePlaceSearchModelResponse extends Equatable {
  final List<GooglePlaceSearchModel> results;

  const GooglePlaceSearchModelResponse({required this.results});

  factory GooglePlaceSearchModelResponse.fromJson(Map<String, dynamic> json) =>
      GooglePlaceSearchModelResponse(
        results: List<GooglePlaceSearchModel>.from(
            json["results"].map((x) => GooglePlaceSearchModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };

  @override
  List<Object?> get props => [results];
}
