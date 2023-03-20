import 'dart:convert';

import 'package:wine_app/model/base/project_model.dart';

class WineModel {
  int id;
  ProjectModel project;
  WineVarietyModel wineVariety;
  String title;
  WineModel({
    required this.id,
    required this.project,
    required this.wineVariety,
    required this.title,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'project': project.toMap(),
      'wine_variety': wineVariety.toMap(),
      'title': title,
    };
  }

  factory WineModel.fromMap(Map<String, dynamic> map) {
    return WineModel(
      id: map['id']?.toInt() ?? 0,
      project: ProjectModel.fromMap(map['project']),
      wineVariety: WineVarietyModel.fromMap(map['wine_variety']),
      title: map['title'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory WineModel.fromJson(String source) => WineModel.fromMap(json.decode(source));
}

class WineBaseModel {
  int id;
  int projectId;
  int wineVarietyId;
  String title;
  WineBaseModel({
    required this.id,
    required this.projectId,
    required this.wineVarietyId,
    required this.title,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'project_id': projectId,
      'wine_variety_id': wineVarietyId,
      'title': title,
    };
  }

  factory WineBaseModel.fromMap(Map<String, dynamic> map) {
    return WineBaseModel(
      id: map['id']?.toInt() ?? 0,
      projectId: map['project_id']?.toInt() ?? 0,
      wineVarietyId: map['wine_variety_id']?.toInt() ?? 0,
      title: map['title'] ?? '',
    );
  }

  factory WineBaseModel.fromWineData(Map<String, dynamic> map) {
    return WineBaseModel(
      id: map['id']?.toInt() ?? 0,
      projectId: map['project']?['id'].toInt() ?? 0,
      wineVarietyId: map['wine_variety']?['id'].toInt() ?? 0,
      title: map['title'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory WineBaseModel.fromJson(String source) => WineBaseModel.fromMap(json.decode(source));
}

class WineVarietyModel {
  int id;
  String title;
  String code;
  WineVarietyModel({
    required this.id,
    required this.title,
    required this.code,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'code': code,
    };
  }

  factory WineVarietyModel.fromMap(Map<String, dynamic> map) {
    return WineVarietyModel(
      id: map['id']?.toInt() ?? 0,
      title: map['title'] ?? '',
      code: map['code'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory WineVarietyModel.fromJson(String source) => WineVarietyModel.fromMap(json.decode(source));
}

class WineEvidenceModel {
  int id;
  int projectId;
  WineBaseModel wine;
  WineClassificationModel wineClassification;
  String title;
  double volume;
  int year;
  double alcohol;
  double acid;
  double sugar;
  String note;
  DateTime createdAt;
  DateTime? updatedAt;
  WineEvidenceModel({
    required this.id,
    required this.projectId,
    required this.wine,
    required this.wineClassification,
    required this.title,
    required this.volume,
    required this.year,
    required this.alcohol,
    required this.acid,
    required this.sugar,
    required this.note,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'project_id': projectId,
      'wine': wine.toMap(),
      'wine_classification': wineClassification.toMap(),
      'title': title,
      'volume': volume,
      'year': year,
      'alcohol': alcohol,
      'acid': acid,
      'sugar': sugar,
      'note': note,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
    };
  }

  factory WineEvidenceModel.fromMap(Map<String, dynamic> map) {
    return WineEvidenceModel(
      id: map['id']?.toInt() ?? 0,
      projectId: map['project_id']?.toInt() ?? 0,
      wine: WineBaseModel.fromMap(map['wine']),
      wineClassification: WineClassificationModel.fromMap(map['wine_classification']),
      title: map['title'] ?? '',
      volume: map['volume']?.toDouble() ?? 0.0,
      year: map['year']?.toInt() ?? 0,
      alcohol: map['alcohol']?.toDouble() ?? 0.0,
      acid: map['acid']?.toDouble() ?? 0.0,
      sugar: map['sugar']?.toDouble() ?? 0.0,
      note: map['note'] ?? '',
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory WineEvidenceModel.fromJson(String source) => WineEvidenceModel.fromMap(json.decode(source));
}

class WineClassificationModel {
  int id;
  String title;
  String code;
  String params;
  WineClassificationModel({
    required this.id,
    required this.title,
    required this.code,
    required this.params,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'code': code,
      'params': params,
    };
  }

  factory WineClassificationModel.fromMap(Map<String, dynamic> map) {
    return WineClassificationModel(
      id: map['id']?.toInt() ?? 0,
      title: map['title'] ?? '',
      code: map['code'] ?? '',
      params: map['params'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory WineClassificationModel.fromJson(String source) => WineClassificationModel.fromMap(json.decode(source));
}

class WineRecordModel {
  int id;
  int wineEvidenceId;
  WineRecordTypeModel wineRecordType;
  DateTime date;
  double? freeSulfure;
  String? note;
  DateTime createdAt;
  DateTime? updatedAt;
  WineRecordModel({
    required this.id,
    required this.wineEvidenceId,
    required this.wineRecordType,
    required this.date,
    this.freeSulfure,
    required this.note,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'wine_evidence_id': wineEvidenceId,
      'wine_record_type': wineRecordType.toMap(),
      'date': date.millisecondsSinceEpoch,
      'free_sulfure': freeSulfure,
      'note': note,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt?.millisecondsSinceEpoch,
    };
  }

  factory WineRecordModel.fromMap(Map<String, dynamic> map) {
    return WineRecordModel(
      id: map['id']?.toInt() ?? 0,
      wineEvidenceId: map['wine_evidence_id']?.toInt() ?? 0,
      wineRecordType: WineRecordTypeModel.fromMap(map['wine_record_type']),
      date: DateTime.parse(map['date']),
      freeSulfure: map['free_sulfure']?.toDouble(),
      note: map['note'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory WineRecordModel.fromJson(String source) => WineRecordModel.fromMap(json.decode(source));
}

class WineRecordTypeModel {
  int id;
  String title;
  String code;
  String color;
  WineRecordTypeModel({
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

  factory WineRecordTypeModel.fromMap(Map<String, dynamic> map) {
    return WineRecordTypeModel(
      id: map['id']?.toInt() ?? 0,
      title: map['title'] ?? '',
      code: map['code'] ?? '',
      color: map['color'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory WineRecordTypeModel.fromJson(String source) => WineRecordTypeModel.fromMap(json.decode(source));
}
