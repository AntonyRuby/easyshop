class SubcategoryModel {
  int? _id;
  String? _name;
  int? _categoryId;
  int? _position;
  String? _createdAt;
  String? _updatedAt;
  String? _image;

  SubcategoryModel(
      {int? id,
      String? name,
      int? categoryId,
      int? position,
      String? createdAt,
      String? updatedAt,
      String? image}) {
    _id = id;
    _name = name;
    _categoryId = categoryId;
    _position = position;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _image = image;
  }

  int? get id => _id;
  String? get name => _name;
  int? get categoryId => _categoryId;
  int? get position => _position;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  String? get image => _image;

  SubcategoryModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _categoryId = json['category_id'];
    _position = json['position'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['name'] = _name;
    data['category_id'] = _categoryId;
    data['position'] = _position;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    data['image'] = _image;
    return data;
  }
}
