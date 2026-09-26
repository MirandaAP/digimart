class ProductModel {
  String id;
  String name;
  String description;
  double price;
  String image;
  String category;
  int quantity;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.category,
    this.quantity = 1,
  });

  String get productName => name;
  String get productDescription => description;
  double get productPrice => price;
  String get productImage => image;
  String get productCategory => category;

  set productName(String newName) {
    if (newName.isNotEmpty) {
      name = newName;
    }
  }

  set productDescription(String newDescription) {
    if (newDescription.isNotEmpty) {
      description = newDescription;
    }
  }

  set productPrice(double newPrice) {
    if (newPrice >= 0) {
      price = newPrice;
    }
  }

  void updateProduct({
    String? newName,
    String? newDescription,
    double? newPrice,
  }) {
    if (newName != null && newName.isNotEmpty) {
      name = newName;
    }

    if (newDescription != null &&
        newDescription.isNotEmpty) {
      description = newDescription;
    }

    if (newPrice != null && newPrice >= 0) {
      price = newPrice;
    }
  }

  String getProductInfo() {
    return '$name - Rp${price.toStringAsFixed(0)}';
  }
}