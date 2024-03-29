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
  List<WineEvidenceWineModel> wines;
  WineClassificationModel? wineClassification;
  String title;
  double volume;
  int year;
  double? alcohol;
  double? acid;
  double? sugar;
  String? note;
  DateTime createdAt;
  DateTime? updatedAt;
  WineEvidenceModel({
    required this.id,
    required this.projectId,
    required this.wines,
    this.wineClassification,
    required this.title,
    required this.volume,
    required this.year,
    this.alcohol,
    this.acid,
    this.sugar,
    this.note,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'project_id': projectId,
      'wines': wines.toList(),
      'wine_classification': wineClassification?.toMap(),
      'title': title,
      'volume': volume,
      'year': year,
      'alcohol': alcohol,
      'acid': acid,
      'sugar': sugar,
      'note': note,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt?.millisecondsSinceEpoch,
    };
  }

  factory WineEvidenceModel.fromMap(Map<String, dynamic> map) {
    List<WineEvidenceWineModel> wineList = [];
    (jsonDecode(json.encode(map['wines']))).forEach((element) {
      wineList.add(WineEvidenceWineModel.fromMap(element));
    });
    return WineEvidenceModel(
      id: map['id'] as int,
      projectId: map['project_id'] as int,
      wines: wineList,
      wineClassification:
          map['wine_classification'] != null ? WineClassificationModel.fromMap(map['wine_classification'] as Map<String, dynamic>) : null,
      title: map['title'] as String,
      volume: map['volume']?.toDouble() ?? 0.0,
      year: map['year'] as int,
      alcohol: map['alcohol'] != null ? map['alcohol']?.toDouble() ?? 0.0 : null,
      acid: map['acid'] != null ? map['acid']?.toDouble() ?? 0.0 : null,
      sugar: map['sugar'] != null ? map['sugar']?.toDouble() ?? 0.0 : null,
      note: map['note'] != null ? map['note'] as String : null,
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory WineEvidenceModel.fromJson(String source) => WineEvidenceModel.fromMap(json.decode(source) as Map<String, dynamic>);
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

class WineEvidenceWineModel {
  int id;
  int wineEvidenceId;
  WineBaseModel wine;
  DateTime createdAt;
  DateTime? updatedAt;
  WineEvidenceWineModel({
    required this.id,
    required this.wineEvidenceId,
    required this.wine,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'wine_evidence_id': wineEvidenceId,
      'wine': wine,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt?.millisecondsSinceEpoch,
    };
  }

  factory WineEvidenceWineModel.fromMap(Map<String, dynamic> map) {
    return WineEvidenceWineModel(
      id: map['id']?.toInt() ?? 0,
      wineEvidenceId: map['wine_evidence_id']?.toInt() ?? 0,
      wine: WineBaseModel.fromMap(map['wine']),
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory WineEvidenceWineModel.fromJson(String source) => WineEvidenceWineModel.fromMap(json.decode(source));
}
