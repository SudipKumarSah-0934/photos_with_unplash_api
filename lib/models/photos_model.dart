class PhotosModel {
  String? id;
  String? createdAt;
  String? updatedAt;
  String? color;
  Map<String, dynamic>? urls;

  PhotosModel({this.id, this.createdAt, this.updatedAt, this.color, this.urls});

  PhotosModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    color = json['color'];
    urls = json['urls'];
  }
}