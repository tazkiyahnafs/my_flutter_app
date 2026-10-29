import 'drink.dart';

class CartItem {
  final Drink drink;
  int quantity;

  CartItem({required this.drink, required this.quantity});

  int get subtotal => drink.price * quantity;
}
