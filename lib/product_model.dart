import 'package:cloud_firestore/cloud_firestore.dart';

class ProductList {

  String prdctName;
  double price;
  double stock;
  bool delete;
  String image;
  String id;
  double discount;
  DateTime date;
  DocumentReference reference;

  ProductList({
    required this.prdctName,
    required this.price,
    required this.stock,
    required this.delete,
    required this.image,
    required this.id,
    required this.discount,
    required this.date,
    required this.reference,
  });

  ProductList copyWith({
    String? prdctName,
    double? price,
    double? stock,
    bool? delete,
    String? image,
    String? id,
    double? discount,
    DateTime? date,
    DocumentReference? reference,
  }) =>
      ProductList(
        prdctName: prdctName ?? this.prdctName,
        price: price ?? this.price,
        stock: stock ?? this.stock,
        delete: delete ?? this.delete,
        id: id ?? this.id,
        date: date ?? this.date,
        discount: discount ?? this.discount,
        reference: reference?? this.reference,
        image: image ?? this.image,
      );

  factory ProductList.fromJson(Map<String, dynamic> json) => ProductList(
    prdctName: json["prdctName"],
    price: double.tryParse(json["price"].toString())??0,
    stock: double.tryParse(json["stock"].toString())??0,
    delete: json["delete"],
    image: json["image"],
    id: json["id"],
    date: json["date"].toDate(),
    reference: json["reference"],
    discount: double.tryParse(json["discount"].toString())??0,
  );

  Map<String, dynamic> toJson() => {
    "prdctName": prdctName,
    "price": price,
    "stock": stock,
    "delete":delete,
    "image":image,
    "id":id,
    "discount":discount,
    "date":date,
    "reference":reference,
  };
}