import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cart_model.dart';
import 'db_helper.dart';

class CartProvider with ChangeNotifier {
  final DbHelper db = DbHelper();

  int _counter = 0;
  int get counter => _counter;

  double _totalPrice = 0.0;
  double get totalPrice => _totalPrice;
  late Future<List<Cart>> _cart;
  Future<List<Cart>> get cart => _cart;
  Future<List<Cart>> getData() async {
    _cart =  db.getCart() ;
    return await _cart;
  }

  // Save data in SharedPreferences
  void _setPrefItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setInt('cart_item', _counter);
    await prefs.setDouble('total_price', _totalPrice);

    notifyListeners();
  }

  // Get data from SharedPreferences
  void _getPrefItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    _counter = prefs.getInt('cart_item') ?? 0;
    _totalPrice = prefs.getDouble('total_price') ?? 0.0;

    notifyListeners();
  }

  // Add price
  void addTotalPrice(double price) {
    _totalPrice += price;
    _setPrefItems();
  }

  // Remove price
  void removeTotalPrice(double price) {
    _totalPrice -= price;
    _setPrefItems();
  }

  // Get total price
  double getTotalPrice() {
    return _totalPrice;
  }

  // Add cart item
  void addCounter() {
    _counter++;
    _setPrefItems();
  }

  // Remove cart item
  void removeCounter() {
    _counter--;
    _setPrefItems();
  }

  // Get cart counter
  int getCounter() {
    return _counter;
  }
}