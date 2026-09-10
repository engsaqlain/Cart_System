import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cart_model.dart';
import 'cart_provider.dart';
import 'cart_screen.dart';
import 'db_helper.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  DbHelper dbHelper = DbHelper();
  final List<String> productList = [
    "Mango",
    "Apple",
    "Banana",
    "Orange",
    "Grapes",
    "Watermelon",
  ];

  final List<String> productUnit = ["Kg", "Kg", "Dozen", "Dozen", "Kg", "Kg"];

  final List<int> productPrice = [100, 200, 300, 400, 500, 600];

  final List<String> productImage = [
    "https://www.shutterstock.com/image-photo/ripe-mango-slice-isolated-on-600w-2635891691.jpg",
    "https://www.shutterstock.com/image-photo/apples-path-isolated-on-white-600w-2484585805.jpg",
    "https://www.shutterstock.com/image-photo/bunch-bananas-isolated-on-white-600w-2704366003.jpg",
    "https://www.shutterstock.com/image-photo/whole-halved-oranges-green-leaf-600w-2701354535.jpg",
    "https://www.shutterstock.com/image-photo/bunch-grapes-white-background-studio-600w-2595094347.jpg",
    "https://www.shutterstock.com/image-photo/watermelon-slice-seeds-isolated-on-600w-2590247625.jpg",
  ];

  int cartCount = 0;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      backgroundColor: const Color(0xffF5F7F6),

      // ================= APP BAR =================
      appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
        
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff00C853), Color(0xff69F0AE)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        
          title: const Text(
            "Fresh Products",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 18),
              child: Badge(
                backgroundColor: Colors.red,
                label: Consumer<CartProvider>(
                  builder: (context, value, child) {
                  return  Text(
                    value.getCounter().toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    );
                  },

                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return const CartScreen();
                      }));
                  },
                  child: const Icon(
                    Icons.shopping_bag_outlined,
                    color: Colors.white,
                    size: 29,
                  ),
                ),
              ),
            ),
          ],
        ),

      // ================= BODY =================
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header text
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
            child: Text(
              "Fresh Fruits 🍎",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color(0xff1B1B1B),
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Choose your favorite fruits",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),

          const SizedBox(height: 15),

          // ================= PRODUCT LIST =================
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              itemCount: productList.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 15),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.07),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),

                  child: Padding(
                    padding: const EdgeInsets.all(12),

                    child: Row(
                      children: [
                        // ================= IMAGE =================
                        Container(
                          width: 105,
                          height: 105,

                          decoration: BoxDecoration(
                            color: const Color(0xffF1FFF6),
                            borderRadius: BorderRadius.circular(18),
                          ),

                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(18),

                            child: Image.network(
                              productImage[index],
                              fit: BoxFit.cover,

                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    }

                                    return const Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.green,
                                      ),
                                    );
                                  },

                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.image_not_supported_outlined,
                                  size: 40,
                                  color: Colors.grey,
                                );
                              },
                            ),
                          ),
                        ),

                        const SizedBox(width: 14),

                        // ================= PRODUCT DETAILS =================
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                productList[index],
                                style: const TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff222222),
                                ),
                              ),

                              const SizedBox(height: 5),

                              Row(
                                children: [
                                  const Icon(
                                    Icons.scale_outlined,
                                    size: 15,
                                    color: Colors.grey,
                                  ),

                                  const SizedBox(width: 4),

                                  Text(
                                    productUnit[index],
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 8),

                              // Price
                              Text(
                                "Rs. ${productPrice[index]}",
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff00A844),
                                ),
                              ),

                              const SizedBox(height: 10),

                              // ================= BUTTON =================
                              SizedBox(
                                height: 40,
                                width: double.infinity,

                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    dbHelper
                                        .insert(
                                          Cart(
                                            id: null ,
                                            prdouctid: index.toString(),
                                            productName: productList[index],
                                            initalPrice: productPrice[index],
                                            productPrice: productPrice[index],
                                            productQuantity: 1,
                                            productImage: productImage[index],
                                            unitTag: productUnit[index],
                                          ),
                                        )
                                        .then((value) {
                                          cart.addTotalPrice(
                                            double.parse(
                                              productPrice[index].toString(),
                                            ),
                                          );
                                          cart.addCounter();
                                           cart.getCounter();
                                          if (kDebugMode) {
                                            print("Product added to cart");
                                          }
                                        })
                                        .catchError((error) {
                                          if (kDebugMode) {
                                            print(error.toString());
                                          }
                                        });

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "${productList[index]} added to cart",
                                        ),
                                        duration: const Duration(seconds: 1),
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                    );
                                  },

                                  icon: const Icon(
                                    Icons.add_shopping_cart,
                                    size: 17,
                                  ),

                                  label: const Text(
                                    "Add to Cart",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff00C853),
                                    foregroundColor: Colors.white,
                                    elevation: 0,

                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    ),

    ]
      ),
    );
  }
}

