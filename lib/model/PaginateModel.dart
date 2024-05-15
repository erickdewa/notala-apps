class PaginateModel {
  final dynamic data;
  final PaginateLinkModel links;
  final PaginateMetaModel meta;

  const PaginateModel({
    required this.data,
    required this.links,
    required this.meta,
  });

  factory PaginateModel.fromJson(Map<String, dynamic> json) {
    return PaginateModel(
      data: checkEmpty(json['data']),
      links: PaginateLinkModel.fromJson(json['links']),
      meta: PaginateMetaModel.fromJson(json['meta']),
    );
  }

  static dynamic checkEmpty(dynamic value){
    return value != '' ? value : null;
  }
}

class PaginateLinkModel {
  final String? first;
  final String? last;
  final String? prev;
  final String? next;

  const PaginateLinkModel({
    required this.first,
    required this.last,
    required this.prev,
    required this.next,
  });

  factory PaginateLinkModel.fromJson(Map<String, dynamic> json) {
    return PaginateLinkModel(
      first: json['first'],
      last: json['last'],
      prev: json['prev'],
      next: json['next'],
    );
  }
}

class PaginateMetaModel {
  final int? currentPage;
  final int? from;
  final int? lastPage;
  final String? path;
  final int? perPage;
  final int? to;
  final int? total;

  const PaginateMetaModel({
    required this.currentPage,
    required this.from,
    required this.lastPage,
    required this.path,
    required this.perPage,
    required this.to,
    required this.total,
  });

  factory PaginateMetaModel.fromJson(Map<String, dynamic> json) {
    return PaginateMetaModel(
      currentPage: json['current_page'],
      from: json['from'],
      lastPage: json['last_page'],
      path: json['path'],
      perPage: json['per_page'],
      to: json['to'],
      total: json['total'],
    );
  }
}