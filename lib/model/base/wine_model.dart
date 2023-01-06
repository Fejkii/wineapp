import 'dart:convert';

class WineModel {
  int id;
  int projectId;
  WineVarietyModel wineVariety;
  String title;
  WineModel({
    required this.id,
    required this.projectId,
    required this.wineVariety,
    required this.title,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'projectId': projectId,
      'wineVariety': wineVariety.toMap(),
      'title': title,
    };
  }

  factory WineModel.fromMap(Map<String, dynamic> map) {
    return WineModel(
      id: map['id']?.toInt() ?? 0,
      projectId: map['projectId']?.toInt() ?? 0,
      wineVariety: WineVarietyModel.fromMap(map['wineVariety']),
      title: map['title'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory WineModel.fromJson(String source) => WineModel.fromMap(json.decode(source));
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
  WineModel wine;
  WineClassificationModel wineClassification;
  String title;
  double volume;
  int year;
  double alcohol;
  double acid;
  double sugar;
  String note;
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
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'projectId': projectId,
      'wine': wine.toMap(),
      'wineClassification': wineClassification.toMap(),
      'title': title,
      'volume': volume,
      'year': year,
      'alcohol': alcohol,
      'acid': acid,
      'sugar': sugar,
      'note': note,
    };
  }

  factory WineEvidenceModel.fromMap(Map<String, dynamic> map) {
    return WineEvidenceModel(
      id: map['id']?.toInt() ?? 0,
      projectId: map['projectId']?.toInt() ?? 0,
      wine: WineModel.fromMap(map['wine']),
      wineClassification: WineClassificationModel.fromMap(map['wineClassification']),
      title: map['title'] ?? '',
      volume: map['volume']?.toDouble() ?? 0.0,
      year: map['year']?.toInt() ?? 0,
      alcohol: map['alcohol']?.toDouble() ?? 0.0,
      acid: map['acid']?.toDouble() ?? 0.0,
      sugar: map['sugar']?.toDouble() ?? 0.0,
      note: map['note'] ?? '',
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
  WineEvidenceModel wineEvidence;
  WineRecordTypeModel wineRecordType;
  String title;
  DateTime date;
  String note;
  DateTime createdAt;
  DateTime updatedAt;
  WineRecordModel({
    required this.id,
    required this.wineEvidence,
    required this.wineRecordType,
    required this.title,
    required this.date,
    required this.note,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'wineEvidence': wineEvidence.toMap(),
      'wineRecordType': wineRecordType.toMap(),
      'title': title,
      'date': date.millisecondsSinceEpoch,
      'note': note,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory WineRecordModel.fromMap(Map<String, dynamic> map) {
    return WineRecordModel(
      id: map['id']?.toInt() ?? 0,
      wineEvidence: WineEvidenceModel.fromMap(map['wineEvidence']),
      wineRecordType: WineRecordTypeModel.fromMap(map['wineRecordType']),
      title: map['title'] ?? '',
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      note: map['note'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
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
