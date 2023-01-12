import 'dart:convert';

class BaseResponse {
  String status;
  int code;
  String message;
  dynamic data;

  BaseResponse(
    this.status,
    this.code,
    this.message,
    this.data,
  );

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'code': code,
      'message': message,
      'data': data,
    };
  }

  factory BaseResponse.fromMap(Map<String, dynamic> map) {
    return BaseResponse(
      map['status'] ?? '',
      map['code']?.toInt() ?? 0,
      map['message'] ?? '',
      map['data'],
    );
  }

  String toJson() => json.encode(toMap());

  factory BaseResponse.fromJson(String source) => BaseResponse.fromMap(json.decode(source));
}

class BaseErrorResponse {
  String status;
  int code;
  String message;

  BaseErrorResponse(
    this.status,
    this.code,
    this.message,
  );

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'code': code,
      'message': message,
    };
  }

  factory BaseErrorResponse.fromMap(Map<String, dynamic> map) {
    return BaseErrorResponse(
      map['status'] ?? '',
      map['code']?.toInt() ?? 0,
      map['message'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory BaseErrorResponse.fromJson(String source) => BaseErrorResponse.fromMap(json.decode(source));
}
