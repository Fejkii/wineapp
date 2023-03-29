import 'dart:convert';

class WineRecordModel {
  int id;
  int wineEvidenceId;
  WineRecordTypeModel wineRecordType;
  DateTime date;
  bool? isInProgress;
  DateTime? dateTo;
  String? note;
  String? title;
  dynamic data;
  DateTime createdAt;
  DateTime? updatedAt;
  WineRecordModel({
    required this.id,
    required this.wineEvidenceId,
    required this.wineRecordType,
    required this.date,
    this.isInProgress,
    this.dateTo,
    this.note,
    this.title,
    required this.data,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'wine_evidence_id': wineEvidenceId,
      'wine_record_type': wineRecordType.toMap(),
      'date': date.millisecondsSinceEpoch,
      'is_in_rogress': isInProgress,
      'date_to': dateTo?.millisecondsSinceEpoch,
      'note': note,
      'title': title,
      'data': data,
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
      isInProgress: map['is_in_progress'],
      dateTo: map['date_to'] != null ? DateTime.parse(map['date_to']) : null,
      note: map['note'],
      title: map['title'],
      data: map['data'],
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

enum WineRecordType {
  measurementFreeSulfure,
  sulfurization,
  measurementProteins,
  proteinWithdrawal,
  filtering,
  withdrawal,
  fermentation,
  pressing,
  others,
}

extension WineRecordTypeExtension on WineRecordType {
  int getId() {
    switch (this) {
      case WineRecordType.measurementFreeSulfure:
        return 1;
      case WineRecordType.sulfurization:
        return 2;
      case WineRecordType.measurementProteins:
        return 3;
      case WineRecordType.proteinWithdrawal:
        return 4;
      case WineRecordType.filtering:
        return 5;
      case WineRecordType.withdrawal:
        return 6;
      case WineRecordType.fermentation:
        return 7;
      case WineRecordType.pressing:
        return 8;
      case WineRecordType.others:
        return 9;
      default:
        return 9;
    }
  }
}

class WineRecordFreeSulfure {
  double freeSulfure;
  double volume;
  double requiredSulphurisation;
  double liquidSulfur;
  double sulfurizationBy;
  double liquidSulfurDosage;

  WineRecordFreeSulfure({
    required this.freeSulfure,
    required this.volume,
    required this.requiredSulphurisation,
    required this.liquidSulfur,
    required this.sulfurizationBy,
    required this.liquidSulfurDosage,
  });

  Map<String, dynamic> toMap() {
    return {
      'freeSulfure': freeSulfure,
      'volume': volume,
      'requiredSulphurisation': requiredSulphurisation,
      'liquidSulfur': liquidSulfur,
      'sulfurizationBy': sulfurizationBy,
      'liquidSulfurDosage': liquidSulfurDosage,
    };
  }

  factory WineRecordFreeSulfure.fromMap(Map<String, dynamic> map) {
    return WineRecordFreeSulfure(
      freeSulfure: map['freeSulfure']?.toDouble() ?? 0.0,
      volume: map['volume']?.toDouble() ?? 0.0,
      requiredSulphurisation: map['requiredSulphurisation']?.toDouble() ?? 0.0,
      liquidSulfur: map['liquidSulfur']?.toDouble() ?? 0.0,
      sulfurizationBy: map['sulfurizationBy']?.toDouble() ?? 0.0,
      liquidSulfurDosage: map['liquidSulfurDosage']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory WineRecordFreeSulfure.fromJson(String source) => WineRecordFreeSulfure.fromMap(json.decode(source));
}
