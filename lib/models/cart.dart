class Cart {
  final int id;
  final String title;
  final double price;
  final String imgName;
  int quantity;

  Cart({
    required this.id,
    required this.title,
    required this.price,
    required this.imgName,
    this.quantity = 1,
  });

  double get totalPrice => price * quantity;
}
