class CategoryModel {
  int? _id;
  String? _name;
  int? _parentId;
  int? _position;
  String? _createdAt;
  String? _updatedAt;
  String? _image;
  int? _storeId; // Add this property

  CategoryModel({
    int? id,
    String? name,
    int? parentId,
    int? position,
    String? createdAt,
    String? updatedAt,
    String? image,
    int? storeId, // Add this parameter
  }) {
    _id = id;
    _name = name;
    _parentId = parentId;
    _position = position;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _image = image;
    _storeId = storeId; // Initialize the storeId property
  }

  int? get id => _id;
  String? get name => _name;
  int? get parentId => _parentId;
  int? get position => _position;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  String? get image => _image;
  int? get storeId => _storeId; // Add this getter

  CategoryModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _parentId = json['parent_id'];
    _position = json['position'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _image = json['image'];
    _storeId = json['store_id']; // Parse the storeId from the JSON response
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
    data['store_id'] = _storeId; // Add the storeId to the JSON data
    return data;
  }

  @override
  String toString() {
    return 'CategoryModel(_id: $_id, _name: $_name, _parentId: $_parentId, _position: $_position, _createdAt: $_createdAt, _updatedAt: $_updatedAt, _image: $_image, _storeId: $_storeId)';
  }
}
