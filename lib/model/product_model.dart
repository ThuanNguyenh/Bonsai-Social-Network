//
// import 'dart:core';
//
// class ProductModel {
//   String id, name, price, address, description, url;
//
//   ProductModel({
//     required this.name,
//     required this.price,
//     required this.address,
//     required this.url,
//     required this.description,
//     required this.id
//   });
//
//   factory ProductModel.fromJson(Map<String, dynamic> json)
//   {
//     return ProductModel(
//         name: json['name'] as String ?? '',
//         price: json['price'],
//         address: json['address'],
//         url: json['url'] as String ?? '',
//         description: json['description'] as String ?? '',
//         id: json['id']
//     );
//   }
//
//
//   Map<String, dynamic> toJson() =>
//       {
//         'name': name,
//         'price': price,
//         'address': address,
//         'url': url,
//         'description': description,
//         'id': id
//       };
// }