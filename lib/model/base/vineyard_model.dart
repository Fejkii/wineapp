import 'dart:convert';

import 'package:wine_app/model/base/wine_model.dart';

class VineyardModel {
  int id;
  int projectId;
  String title;
  VineyardModel({
    required this.id,
    required this.projectId,
    required this.title,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'projectId': projectId,
      'title': title,
    };
  }

  factory VineyardModel.fromMap(Map<String, dynamic> map) {
    return VineyardModel(
      id: map['id']?.toInt() ?? 0,
      projectId: map['projectId']?.toInt() ?? 0,
      title: map['title'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory VineyardModel.fromJson(String source) => VineyardModel.fromMap(json.decode(source));
}

class VineyardRecordModel {
  int id;
  int vineyardId;
  String title;
  DateTime date;
  int vineyardWineId;
  VineyardRecordTypeModel vineyardRecordType;
  String note;
  DateTime createdAt;
  DateTime? updatedAt;
  VineyardRecordModel({
    required this.id,
    required this.vineyardId,
    required this.title,
    required this.date,
    required this.vineyardWineId,
    required this.vineyardRecordType,
    required this.note,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'vineyard_id': vineyardId,
      'title': title,
      'date': date,
      'vineyard_wine_id': vineyardWineId,
      'vineyard_record_type': vineyardRecordType.toMap(),
      'note': note,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt?.millisecondsSinceEpoch,
    };
  }

  factory VineyardRecordModel.fromMap(Map<String, dynamic> map) {
    return VineyardRecordModel(
      id: map['id']?.toInt() ?? 0,
      vineyardId: map['vineyard_id']?.toInt() ?? 0,
      title: map['title'] ?? '',
      date: DateTime.parse(map['date']),
      vineyardWineId: map['vineyard_wine_id']?.toInt() ?? 0,
      vineyardRecordType: VineyardRecordTypeModel.fromMap(map['vineyard_record_type']),
      note: map['note'] ?? '',
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory VineyardRecordModel.fromJson(String source) => VineyardRecordModel.fromMap(json.decode(source));
}

class VineyardRecordTypeModel {
  int id;
  String title;
  String? note;
  String? color;
  VineyardRecordTypeModel({
    required this.id,
    required this.title,
    this.note,
    required this.color,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'note': note,
      'color': color,
    };
  }

  factory VineyardRecordTypeModel.fromMap(Map<String, dynamic> map) {
    return VineyardRecordTypeModel(
      id: map['id']?.toInt() ?? 0,
      title: map['title'] ?? '',
      note: map['note'],
      color: map['color'],
    );
  }

  String toJson() => json.encode(toMap());

  factory VineyardRecordTypeModel.fromJson(String source) => VineyardRecordTypeModel.fromMap(json.decode(source));
}

class VineyardWineModel {
  int id;
  VineyardModel vineyard;
  WineModel wine;
  String title;
  int quantity;
  int year;
  String note;
  VineyardWineModel({
    required this.id,
    required this.vineyard,
    required this.wine,
    required this.title,
    required this.quantity,
    required this.year,
    required this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'vineyard': vineyard.toMap(),
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
      vineyard: VineyardModel.fromMap(map['vineyard']),
      wine: WineModel.fromMap(map['wine']),
      title: map['title'] ?? '',
      quantity: map['quantity']?.toInt() ?? 0,
      year: map['year']?.toInt() ?? 0,
      note: map['note'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory VineyardWineModel.fromJson(String source) => VineyardWineModel.fromMap(json.decode(source));
}
