import 'dart:convert';

enum VineyardRecordType {
  spraying,
  pleating,
  greenJobs,
  plowing,
  pickingGrapes,
  cutting,
  binding,
  fertilization,
  others,
}

extension WineRecordTypeExtension on VineyardRecordType {
  int getId() {
    switch (this) {
      case VineyardRecordType.spraying:
        return 1;
      case VineyardRecordType.pleating:
        return 2;
      case VineyardRecordType.greenJobs:
        return 3;
      case VineyardRecordType.plowing:
        return 4;
      case VineyardRecordType.pickingGrapes:
        return 5;
      case VineyardRecordType.cutting:
        return 6;
      case VineyardRecordType.binding:
        return 7;
      case VineyardRecordType.fertilization:
        return 8;
      case VineyardRecordType.others:
        return 9;
      default:
        return 9;
    }
  }
}

class VineyardRecordModel {
  int id;
  int? vineyardId;
  int? vineyardWineId;
  VineyardRecordTypeModel vineyardRecordType;
  DateTime date;
  bool? isInProgress;
  DateTime? dateTo;
  String? note;
  String? title;
  dynamic data;
  DateTime createdAt;
  DateTime? updatedAt;
  VineyardRecordModel({
    required this.id,
    this.vineyardId,
    this.vineyardWineId,
    required this.vineyardRecordType,
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
    return <String, dynamic>{
      'id': id,
      'vineyard_id': vineyardId,
      'vineyard_wine_id': vineyardWineId,
      'vineyard_record_type': vineyardRecordType.toMap(),
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

  factory VineyardRecordModel.fromMap(Map<String, dynamic> map) {
    return VineyardRecordModel(
      id: map['id'] as int,
      vineyardId: map['vineyard_id'] != null ? map['vineyard_id'] as int : null,
      vineyardWineId: map['vineyard_wine_id'] != null ? map['vineyard_wine_id'] as int : null,
      vineyardRecordType: VineyardRecordTypeModel.fromMap(map['vineyard_record_type'] as Map<String, dynamic>),
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

  factory VineyardRecordModel.fromJson(String source) => VineyardRecordModel.fromMap(json.decode(source) as Map<String, dynamic>);
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

class VineyardRecordSpraying {
  String sprayName;
  double amountSpray;
  double amountWater;
  VineyardRecordSpraying({
    required this.sprayName,
    required this.amountSpray,
    required this.amountWater,
  });

  Map<String, dynamic> toMap() {
    return {
      'sprayName': sprayName,
      'amountSpray': amountSpray,
      'amountWater': amountWater,
    };
  }

  factory VineyardRecordSpraying.fromMap(Map<String, dynamic> map) {
    return VineyardRecordSpraying(
      sprayName: map['sprayName'] ?? '',
      amountSpray: map['amountSpray']?.toDouble() ?? 0.0,
      amountWater: map['amountWater']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory VineyardRecordSpraying.fromJson(String source) => VineyardRecordSpraying.fromMap(json.decode(source));
}
