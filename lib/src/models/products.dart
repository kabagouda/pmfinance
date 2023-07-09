class Product {
  int? id;
  String? title;
  String? description;
  int? price;
  String? country;
  String? city;
  String? district;
  int? surfaceArea;
  List<String>? image;
  int? noRooms;
  int? noBedrooms;
  int? noBathrooms;
  int? noGarages;
  String? type;
  String? status;
  String? createdAt;
  String? updatedAt;

  Product(
      {this.id,
      this.title,
      this.description,
      this.price,
      this.country,
      this.city,
      this.district,
      this.surfaceArea,
      this.image,
      this.noRooms,
      this.noBedrooms,
      this.noBathrooms,
      this.noGarages,
      this.type,
      this.status,
      this.createdAt,
      this.updatedAt});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    price = json['price'];
    country = json['country'];
    city = json['city'];
    district = json['district'];
    surfaceArea = json['surface_area'];
    image = json['image'].cast<String>();
    noRooms = json['no_rooms'];
    noBedrooms = json['no_bedrooms'];
    noBathrooms = json['no_bathrooms'];
    noGarages = json['no_garages'];
    type = json['type'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['price'] = price;
    data['country'] = country;
    data['city'] = city;
    data['district'] = district;
    data['surface_area'] = surfaceArea;
    data['image'] = image;
    data['no_rooms'] = noRooms;
    data['no_bedrooms'] = noBedrooms;
    data['no_bathrooms'] = noBathrooms;
    data['no_garages'] = noGarages;
    data['type'] = type;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
