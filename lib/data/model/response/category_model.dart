import 'package:sixam_mart/data/model/response/subcategory_model.dart';

class CategoryModel {
  int? _id;
  String? _name;
  int? _parentId;
  int? _position;
  String? _createdAt;
  String? _updatedAt;
  String? _image;
  List<SubcategoryModel>? _subcategories; // Add this

  CategoryModel(
      {int? id,
      String? name,
      int? parentId,
      int? position,
      String? createdAt,
      String? updatedAt,
      String? image,
      List<SubcategoryModel>? subcategories}) {
    // Add this
    _id = id;
    _name = name;
    _parentId = parentId;
    _position = position;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _image = image;
    _subcategories = subcategories; // Add this
  }

  int? get id => _id;
  String? get name => _name;
  int? get parentId => _parentId;
  int? get position => _position;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  String? get image => _image;
  List<SubcategoryModel>? get subcategories => _subcategories; // Add this

  CategoryModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _parentId = json['parent_id'];
    _position = json['position'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _image = json['image'];
    if (json['childes'] != null) {
      _subcategories = (json['childes'] as List)
          .map((subcategory) => SubcategoryModel.fromJson(subcategory))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['name'] = _name;
    data['parent_id'] = _parentId;
    data['position'] = _position;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    data['image'] = _image;
    if (_subcategories != null) {
      data['subcategories'] =
          _subcategories!.map((subcategory) => subcategory.toJson()).toList();
    }
    return data;
  }
}
