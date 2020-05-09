class UserProfileModel {
  final String id;
  final String email;
  final String name;
  final bool blocked;
  final int role;
  final String customerNumber;
  final int confirmStatus;
  final List<CategoryModel> listCategory;
  final List<SpbuCodeModel> listSpbuCode;

  UserProfileModel copyWith(
      {String id,
        String email,
        String name,
        bool blocked,
        int role,
        String customerNumber,
        int confirmStatus,
        List<CategoryModel> listCategory,
        List<SpbuCodeModel> listSpbuCode
      }) {
    return UserProfileModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      blocked: blocked ?? this.blocked,
      role: role ?? this.role,
      customerNumber: customerNumber ?? this.customerNumber,
      confirmStatus: confirmStatus ??  this.confirmStatus,
      listCategory: listCategory ?? this.listCategory,
      listSpbuCode: listSpbuCode ?? this.listSpbuCode
    );
  }

  UserProfileModel(
      { this.id, this.email,
      this.name,
      this.blocked,
      this.role,
      this.customerNumber,
      this.confirmStatus,
      this.listCategory,
      this.listSpbuCode});

  factory UserProfileModel.fromJson(Map<dynamic, dynamic> json) {
    List<CategoryModel> categoryList = [];

    List<SpbuCodeModel> spbuList = [];

    for (var item in json["categories"]) {
      categoryList.add(CategoryModel.fromJson(item));
    }

    for (var item in json["spbuCode"]) {
      spbuList.add(SpbuCodeModel.fromJson(item));
    }

    return UserProfileModel(
      id: json["id"] as String,
      email: json["email"] as String ,
      name: json["name"] as String,
      blocked: json["blocked"] as bool,
      role: json["role"] as int,
      customerNumber: json["customNumber"] as String,
      confirmStatus: json["confirmStatus"] as int,
      listCategory: categoryList,
      listSpbuCode: spbuList
    );
  }
}

class CategoryModel {
  final String email;
  final String salesOrg;
  final String salesOrgDesc;

  CategoryModel({this.email, this.salesOrg, this.salesOrgDesc});

  factory CategoryModel.fromJson(Map<dynamic, dynamic> json) {
    return CategoryModel(
      email: json["email"] as String,
      salesOrg: json["salesOrg"] as String,
      salesOrgDesc: json["salesOrgDesc"] as String,
    );
  }
}

class SpbuCodeModel {
  final String spbuCode;
  final String email;

  SpbuCodeModel({this.spbuCode, this.email});

  factory SpbuCodeModel.fromJson(Map<dynamic, dynamic> json) {
    return SpbuCodeModel(
        spbuCode: json["spbuCode"] as String, email: json["email"] as String);
  }
}
