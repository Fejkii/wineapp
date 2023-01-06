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
  VineyardModel vineyard;
  String title;
  DateTime date;
  VineyardWineModel vineyardWine;
  VineyardRecordTypeModel vineyardRecordType;
  String note;
  DateTime createdAt;
  DateTime updatedAt;
  VineyardRecordModel({
    required this.id,
    required this.vineyard,
    required this.title,
    required this.date,
    required this.vineyardWine,
    required this.vineyardRecordType,
    required this.note,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'vineyard': vineyard.toMap(),
      'title': title,
      'date': date.millisecondsSinceEpoch,
      'vineyardWine': vineyardWine.toMap(),
      'vineyardRecordType': vineyardRecordType.toMap(),
      'note': note,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory VineyardRecordModel.fromMap(Map<String, dynamic> map) {
    return VineyardRecordModel(
      id: map['id']?.toInt() ?? 0,
      vineyard: VineyardModel.fromMap(map['vineyard']),
      title: map['title'] ?? '',
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      vineyardWine: VineyardWineModel.fromMap(map['vineyardWine']),
      vineyardRecordType: VineyardRecordTypeModel.fromMap(map['vineyardRecordType']),
      note: map['note'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory VineyardRecordModel.fromJson(String source) => VineyardRecordModel.fromMap(json.decode(source));
}

class VineyardRecordTypeModel {
  int id;
  String title;
  String code;
  String color;
  VineyardRecordTypeModel({
    required this.id,
    required this.title,
    required this.code,
    required this.color,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'code': code,
      'color': color,
    };
  }

  factory VineyardRecordTypeModel.fromMap(Map<String, dynamic> map) {
    return VineyardRecordTypeModel(
      id: map['id']?.toInt() ?? 0,
      title: map['title'] ?? '',
      code: map['code'] ?? '',
      color: map['color'] ?? '',
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
