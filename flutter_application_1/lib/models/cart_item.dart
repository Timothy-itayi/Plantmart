import 'plant.dart';

class CartItem {
  final Plant plant;
  int quantity;

  CartItem({
    required this.plant,
    this.quantity = 1,
  });

  double get totalPrice => plant.price * quantity;
} 