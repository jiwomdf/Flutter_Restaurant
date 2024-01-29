class RestaurantEntity {
  String id;
  String name;
  String description;
  String city;
  String address;
  String pictureId;
  double rating;

  RestaurantEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.city,
    required this.address,
    required this.pictureId,
    required this.rating
  });

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "city": city,
    "address": address,
    "pictureId": pictureId,
    "rating": rating,
  };

  factory RestaurantEntity.fromJson(Map<String, dynamic> json) => RestaurantEntity(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    city: json["city"],
    address: json["address"],
    pictureId: json["pictureId"],
    rating: json["rating"]?.toDouble()
  );

}