import 'dart:convert';

import 'package:wine_app/model/base/wine_model.dart';

class VineyardModel {
  int id;
  int projectId;
  String title;
  double? area;
  VineyardModel({
    required this.id,
    required this.projectId,
    required this.title,
    this.area,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'project_id': projectId,
      'title': title,
      'area': area,
    };
  }

  factory VineyardModel.fromMap(Map<String, dynamic> map) {
    return VineyardModel(
      id: map['id'] as int,
      projectId: map['project_id'] as int,
      title: map['title'] as String,
      area: map['area']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory VineyardModel.fromJson(String source) => VineyardModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

// Hlavička vinohradu
class VineyardWineModel {
  int id;
  int vineyardId;
  WineBaseModel wine;
  String title;
  int quantity;
  int? year;
  String? note;
  VineyardWineModel({
    required this.id,
    required this.vineyardId,
    required this.wine,
    required this.title,
    required this.quantity,
    this.year,
    this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'vineyard': vineyardId,
      'wine': wine.toMap(),
      'title': title,
      'quantity': quantity,
      'year': year,
      'note': note,
    };
  }

  factory VineyardWineModel.fromMap(Map<String, dynamic> map) {
    return VineyardWineModel(
      id: map['id']?.toInt() ?? 0,
      vineyardId: map['vineyard']?.toInt() ?? 0,
      wine: WineBaseModel.fromWineData(map['wine']),
      title: map['title'] ?? '',
      quantity: map['quantity']?.toInt() ?? 0,
      year: map['year']?.toInt() ?? 0,
      note: map['note'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory VineyardWineModel.fromJson(String source) => VineyardWineModel.fromMap(json.decode(source));
}
