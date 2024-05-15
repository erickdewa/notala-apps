class ResponseModel {
  final bool? status;
  final dynamic data;
  final String? message;
  final int? code;

  const ResponseModel({
    this.status,
    this.data,
    this.message,
    this.code,
  });

  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel(
      status: json['status'] ?? false,
      data: checkEmpty(json['data']),
      message: checkEmpty(json['message']),
      code: json['code'] ?? 0,
    );
  }

  static dynamic checkEmpty(dynamic value){
    return value != '' ? value : null;
  }
}