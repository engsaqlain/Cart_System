import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cart_model.dart';
import 'cart_provider.dart';
import 'db_helper.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  DbHelper dbHelper = DbHelper();

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
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
          "My Products",
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
                  return Text(
                    value.getCounter().toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  );
                },
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                color: Colors.white,
                size: 29,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: cart.getData(),
            builder: (context, AsyncSnapshot<List<Cart>> snapshot) {
              if (snapshot.hasData) {
                return Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 5,
                    ),
                    itemCount: snapshot.data?.length,
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
                                    snapshot.data![index].productImage!,
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
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          snapshot.data![index].productName!,
                                          style: const TextStyle(
                                            fontSize: 19,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xff222222),
                                          ),
                                        ),
                                        InkWell(

                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          onTap: () {
                                            dbHelper.delete(
                                              snapshot.data![index].id!,
                                            );
                                            cart.removeCounter();
                                            cart.removeTotalPrice(
                                              double.parse(
                                                snapshot.data![index].productPrice.toString(),
                                              ),
                                            );
                                            cart.getCounter();
                                          }
                                        ),
                                      ],
                                    ),
                                    Text(
                                      snapshot.data![index].productName!,
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
                                          snapshot.data![index].unitTag!,
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
                                      "Rs. ${snapshot.data![index].productPrice}",
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

                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xff00C853),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        // ================= QUANTITY BUTTON =================

                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [

                                            // ================= MINUS =================
                                            InkWell(
                                              onTap: () async {
                                                int quantity =
                                                snapshot.data![index].productQuantity!;

                                                int unitPrice =
                                                snapshot.data![index].initalPrice!;

                                                // Quantity 1 se neeche nahi jayegi
                                                if (quantity > 1) {
                                                  quantity--;

                                                  int newPrice = unitPrice * quantity;

                                                  await dbHelper.updateQuantity(
                                                    Cart(
                                                      id: snapshot.data![index].id,
                                                      prdouctid:
                                                      snapshot.data![index].prdouctid.toString(),
                                                      productName:
                                                      snapshot.data![index].productName,
                                                      initalPrice:
                                                      snapshot.data![index].initalPrice,
                                                      productPrice: newPrice,
                                                      productQuantity: quantity,
                                                      productImage:
                                                      snapshot.data![index].productImage,
                                                      unitTag:
                                                      snapshot.data![index].unitTag,
                                                    ),
                                                  );

                                                  // Total cart price se sirf ONE unit price minus
                                                  cart.removeTotalPrice(
                                                    unitPrice.toDouble(),
                                                  );

                                                  setState(() {});
                                                }
                                              },
                                              child: const Icon(Icons.remove),
                                            ),

                                            // ================= QUANTITY =================
                                            Text(
                                              snapshot.data![index].productQuantity.toString(),
                                            ),

                                            // ================= PLUS =================
                                            InkWell(
                                              onTap: () async {
                                                int quantity =
                                                snapshot.data![index].productQuantity!;

                                                int unitPrice =
                                                snapshot.data![index].initalPrice!;

                                                quantity++;

                                                // IMPORTANT:
                                                // Original/unit price × new quantity
                                                int newPrice = unitPrice * quantity;

                                                await dbHelper.updateQuantity(
                                                  Cart(
                                                    id: snapshot.data![index].id,
                                                    prdouctid:
                                                    snapshot.data![index].prdouctid.toString(),
                                                    productName:
                                                    snapshot.data![index].productName,
                                                    initalPrice:
                                                    snapshot.data![index].initalPrice,
                                                    productPrice: newPrice,
                                                    productQuantity: quantity,
                                                    productImage:
                                                    snapshot.data![index].productImage,
                                                    unitTag:
                                                    snapshot.data![index].unitTag,
                                                  ),
                                                );

                                                // Total cart price mein sirf ONE unit add
                                                cart.addTotalPrice(
                                                  unitPrice.toDouble(),
                                                );
                                              },
                                              child: const Icon(Icons.add),
                                            ),
                                          ],
                                        ),
                                      )
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
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
          Consumer<CartProvider>(
            builder: (context, value, child) {
              return Visibility(
                visible: cart.getCounter()  >0.00? true : false,
                replacement: const SizedBox(
                  height: 200,
                  child: Column(
                    children: [
                      Icon(Icons.hourglass_empty_outlined, size: 100, color: Colors.grey),
                      Center(
                        child: Text(
                          "Your cart is empty",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    ReusableWidgets(
                      title: "Total Price: ",
                      value: r"RS " + cart.getTotalPrice().toStringAsFixed(2),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ReusableWidgets extends StatelessWidget {
  final String title, value;

  const ReusableWidgets({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
                ),
              padding: const EdgeInsets.all(10),
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleSmall,
              )),
          Container(

              decoration: BoxDecoration(

                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),

                ),

              padding: const EdgeInsets.all(10),
              child: Text(
                value,
                style: Theme.of(context).textTheme.titleSmall,
              )),
        ],
      ),
    );
  }
}
