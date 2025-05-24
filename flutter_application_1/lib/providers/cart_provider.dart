import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/plant.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => [..._items];

  int get itemCount => _items.length;

  double get totalAmount {
    return _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  void addItem(Plant plant) {
    final existingIndex = _items.indexWhere((item) => item.plant.id == plant.id);
    
    if (existingIndex >= 0) {
      _items[existingIndex].quantity += 1;
    } else {
      _items.add(CartItem(plant: plant));
    }
    notifyListeners();
  }

  void removeItem(String plantId) {
    _items.removeWhere((item) => item.plant.id == plantId);
    notifyListeners();
  }

  void updateQuantity(String plantId, int quantity) {
    final index = _items.indexWhere((item) => item.plant.id == plantId);
    if (index >= 0) {
      if (quantity > 0) {
        _items[index].quantity = quantity;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
} 