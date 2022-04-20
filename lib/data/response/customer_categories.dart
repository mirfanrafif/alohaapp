class CustomerCategoriesResponse {
  CustomerCategoriesResponse({
    required this.data,
    required this.meta,
  });

  final List<CustomerCategories> data;
  final Meta? meta;

  factory CustomerCategoriesResponse.fromJson(Map<String, dynamic> json) {
    return CustomerCategoriesResponse(
      data: json["data"] == null
          ? []
          : List<CustomerCategories>.from(
              json["data"]!.map((x) => CustomerCategories.fromJson(x))),
      meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    );
  }
}

class CustomerCategories {
  CustomerCategories({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.name,
  });

  final int? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? name;

  factory CustomerCategories.fromJson(Map<String, dynamic> json) {
    return CustomerCategories(
      id: json["id"],
      createdAt: json["created_at"] == null
          ? null
          : DateTime.parse(json["created_at"]),
      updatedAt: json["updated_at"] == null
          ? null
          : DateTime.parse(json["updated_at"]),
      name: json["name"],
    );
  }
}

class Meta {
  Meta({
    required this.itemsPerPage,
    required this.totalItems,
    required this.currentPage,
    required this.totalPages,
    required this.sortBy,
  });

  final int? itemsPerPage;
  final int? totalItems;
  final int? currentPage;
  final int? totalPages;
  final List<List<String>> sortBy;

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      itemsPerPage: json["itemsPerPage"],
      totalItems: json["totalItems"],
      currentPage: json["currentPage"],
      totalPages: json["totalPages"],
      sortBy: json["sortBy"] == null
          ? []
          : List<List<String>>.from(json["sortBy"]!.map(
              (x) => x == null ? [] : List<String>.from(x!.map((x) => x)))),
    );
  }
}

//Customer Interests
class CustomerInterestsResponse {
  CustomerInterestsResponse({
    required this.data,
    required this.meta,
  });

  final List<CustomerInterests> data;
  final Meta? meta;

  factory CustomerInterestsResponse.fromJson(Map<String, dynamic> json) {
    return CustomerInterestsResponse(
      data: json["data"] == null
          ? []
          : List<CustomerInterests>.from(
              json["data"]!.map((x) => CustomerInterests.fromJson(x))),
      meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    );
  }
}

class CustomerInterests {
  CustomerInterests({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.name,
  });

  final int? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? name;

  factory CustomerInterests.fromJson(Map<String, dynamic> json) {
    return CustomerInterests(
      id: json["id"],
      createdAt: json["created_at"] == null
          ? null
          : DateTime.parse(json["created_at"]),
      updatedAt: json["updated_at"] == null
          ? null
          : DateTime.parse(json["updated_at"]),
      name: json["name"],
    );
  }
}

//Customer Interests
class CustomerTypesResponse {
  CustomerTypesResponse({
    required this.data,
    required this.meta,
  });

  final List<CustomerTypes> data;
  final Meta? meta;

  factory CustomerTypesResponse.fromJson(Map<String, dynamic> json) {
    return CustomerTypesResponse(
      data: json["data"] == null
          ? []
          : List<CustomerTypes>.from(
              json["data"]!.map((x) => CustomerTypes.fromJson(x))),
      meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    );
  }
}

class CustomerTypes {
  CustomerTypes({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.name,
  });

  final int? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? name;

  factory CustomerTypes.fromJson(Map<String, dynamic> json) {
    return CustomerTypes(
      id: json["id"],
      createdAt: json["created_at"] == null
          ? null
          : DateTime.parse(json["created_at"]),
      updatedAt: json["updated_at"] == null
          ? null
          : DateTime.parse(json["updated_at"]),
      name: json["name"],
    );
  }
}
