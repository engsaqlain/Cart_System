class Cart {
  late final int? id;
  final String? prdouctid;
  final String? productName;
  final int? initalPrice;
  final int? productPrice;
  final int? productQuantity;
  final String? productImage;
  final String? unitTag;

  Cart({
    required this.id,
    required this.prdouctid,
    required this.productName,
    required this.initalPrice,
    required this.productPrice,
    required this.productQuantity,
    required this.productImage,
    required this.unitTag,
  });

  Cart.fromMap(Map<dynamic, dynamic> res)
    : id = res["id"],
      prdouctid = res["prdouctid"],
      productName = res["productName"],
      initalPrice = res["initalPrice"],
      productPrice = res["productPrice"],
      productQuantity = res["productQuantity"],
      productImage = res["productImage"],
      unitTag = res["unitTag"];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'prdouctid': prdouctid,
      'productName': productName,
      'initalPrice': initalPrice,
      'productPrice': productPrice,
      'productQuantity': productQuantity,
      'productImage': productImage,
      'unitTag': unitTag,
    };
  }
}
