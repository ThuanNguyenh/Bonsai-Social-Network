class Post {
  final String name;
  final String image;
  final int price;
  final String address;
  final String id;

  const Post({
      required this.name,
      required this.image,
      required this.price,
      required this.address,
      required this.id
  });

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        name: json['name'],
        image: json['image'],
        price: json['price'],
        address: json['address'],
        id: json['id'],
      );

  Map<String, dynamic> toJson() => {
   'name': name,
    'image': image,
    'price': price,
    'address': address,
    'id': id
  };
  Post copy() => Post(
      name: name,
      image: image,
      price: price,
      address: address,
      id: id
  );
}
