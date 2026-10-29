import 'package:flutter/material.dart';

import '../app_theme.dart';
import '../models/cart_item.dart';
import '../models/drink.dart';
import 'cart_page.dart';
import 'home_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Tab yang sedang aktif (0 = Menu, 1 = Keranjang)
  int _selectedIndex = 0;

  // State global keranjang
  final List<CartItem> _cartItems = [];

  // Data statis pengganti database
  final List<Drink> _drinkList = const [
    Drink(
      id: 'd1',
      name: 'Espresso',
      price: 15000,
      imageUrl: 'assets/esspresso.jpg',
    ),
    Drink(
      id: 'd2',
      name: 'Americano',
      price: 18000,
      imageUrl: 'assets/Americano.jpg',
    ),
    Drink(
      id: 'd3',
      name: 'Matcha Latte',
      price: 25000,
      imageUrl: 'assets/matcha.jpg',
    ),
    Drink(
      id: 'd4',
      name: 'Chocolate Frappe',
      price: 28000,
      imageUrl: 'assets/chocolate.jpg',
    ),
  ];

  void _addToCart(Drink drink, int quantity) {
    setState(() {
      final index = _cartItems.indexWhere((item) => item.drink.id == drink.id);
      if (index != -1) {
        // Sudah ada di keranjang -> tambahkan jumlahnya
        _cartItems[index].quantity += quantity;
      } else {
        // Belum ada -> buat item baru
        _cartItems.add(CartItem(drink: drink, quantity: quantity));
      }
    });
  }

  void _removeFromCart(String drinkId) {
    setState(() {
      _cartItems.removeWhere((item) => item.drink.id == drinkId);
    });
  }

  void _checkout() {
    setState(() {
      _cartItems.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Dibuat di dalam build supaya selalu memakai data terbaru
    final pages = [
      HomePage(drinkList: _drinkList, onAddToCart: _addToCart),
      CartPage(
        cartItems: _cartItems,
        onRemoveFromCart: _removeFromCart,
        onCheckout: _checkout,
      ),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.accent,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.local_cafe),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Badge(
              label: Text('${_cartItems.length}'),
              isLabelVisible: _cartItems.isNotEmpty,
              child: const Icon(Icons.shopping_cart),
            ),
            label: 'Keranjang',
          ),
        ],
      ),
    );
  }
}
