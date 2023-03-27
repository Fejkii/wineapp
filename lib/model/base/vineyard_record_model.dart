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
  DateTime date;
  VineyardRecordTypeModel vineyardRecordType;
  String? title;
  String? data;
  String? note;
  DateTime createdAt;
  DateTime? updatedAt;
  VineyardRecordModel({
    required this.id,
    this.vineyardId,
    this.vineyardWineId,
    required this.date,
    required this.vineyardRecordType,
    this.title,
    this.data,
    this.note,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'vineyard_id': vineyardId,
      'vineyard_wine_id': vineyardWineId,
      'date': date.millisecondsSinceEpoch,
      'vineyard_record_type': vineyardRecordType.toMap(),
      'title': title,
      'data': data,
      'note': note,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt?.millisecondsSinceEpoch,
    };
  }

  factory VineyardRecordModel.fromMap(Map<String, dynamic> map) {
    return VineyardRecordModel(
      id: map['id'] as int,
      vineyardId: map['vineyard_id'] != null ? map['vineyard_id'] as int : null,
      vineyardWineId: map['vineyard_wine_id'] != null ? map['vineyard_wine_id'] as int : null,
      date: DateTime.parse(map['date']),
      vineyardRecordType: VineyardRecordTypeModel.fromMap(map['vineyard_record_type'] as Map<String, dynamic>),
      title: map['title'] != null ? map['title'] as String : null,
      data: map['data'] != null ? map['data'] as String : null,
      note: map['note'] != null ? map['note'] as String : null,
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
  String title;
  String ratio;
  VineyardRecordSpraying({
    required this.title,
    required this.ratio,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'ratio': ratio,
    };
  }

  factory VineyardRecordSpraying.fromMap(Map<String, dynamic> map) {
    return VineyardRecordSpraying(
      title: map['title'] ?? '',
      ratio: map['ratio'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory VineyardRecordSpraying.fromJson(String source) => VineyardRecordSpraying.fromMap(json.decode(source));
}
