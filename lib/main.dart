import 'package:flutter/material.dart';
import 'package:hunarpak/product_list_screen.dart';
import 'package:provider/provider.dart';

import 'cart_provider.dart';
void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: Builder(builder: (BuildContext context) {
         return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: ProductListScreen(),
        );
      })
    );
  }
}
