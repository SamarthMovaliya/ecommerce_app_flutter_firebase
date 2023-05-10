import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_firebase/controller/provider/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../controller/helper_classes/firebase_firestore_helper.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        icon: null,
        backgroundColor: Colors.red,
        onPressed: () {},
        label: const Text(
          'Place Order ',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      appBar: AppBar(
        title: Text(
          'My Cart',
          style: GoogleFonts.alata(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 9,
            child: StreamBuilder(
              stream:
                  FireBaseStoreHelper.db.collection("cartProduct").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      snapshot.error.toString(),
                    ),
                  );
                } else if (snapshot.hasData) {
                  QuerySnapshot<Map<String, dynamic>>? favourite =
                      snapshot.data;
                  List<QueryDocumentSnapshot<Map<String, dynamic>>> allFav =
                      favourite!.docs;
                  if (allFav.isNotEmpty) {
                    int sum = 0;
                    int qut = 0;
                    allFav.forEach((e) {
                      qut = e['quantity'] + qut;
                      int psum = e['quantity'] * e['price'];
                      sum = sum + psum;
                    });
                    return Column(
                      children: [
                        Expanded(
                          flex: 6,
                          child: ListView.builder(
                              itemCount: allFav.length,
                              padding: const EdgeInsets.all(20),
                              itemBuilder: (context, i) {
                                return GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    margin: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color: (Get.isDarkMode)
                                                ? Colors.grey.shade900
                                                : Colors.grey.shade300,
                                            offset: const Offset(1, 2),
                                            blurRadius: 8)
                                      ],
                                      borderRadius: BorderRadius.circular(30),
                                      color: (Get.isDarkMode)
                                          ? Colors.grey.shade800
                                          : Colors.white,
                                    ),
                                    height: 140,
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    child: ListTile(
                                      leading: Transform.scale(
                                        scale: 1.6,
                                        child: Hero(
                                          tag: allFav[i]['name'],
                                          child: Transform.translate(
                                            offset: const Offset(3, 10),
                                            child: Image.asset(
                                              allFav[i]['image'],
                                            ),
                                          ),
                                        ),
                                      ),
                                      isThreeLine: true,
                                      title: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, top: 8.0),
                                        child: Text(
                                          allFav[i]['name'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 0,
                                            fontSize: 22,
                                          ),
                                        ),
                                      ),
                                      trailing: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            height: 30,
                                            width: 50,
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                  Colors.red.shade500,
                                                ),
                                              ),
                                              onPressed: () {
                                                Provider.of<CartController>(
                                                        context,
                                                        listen: false)
                                                    .deleteFromCart(
                                                        Uid: allFav[i]['Uid']);
                                              },
                                              child: const Icon(
                                                Icons.delete,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '℈${allFav[i]['price']}',
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 2,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 4.0,
                                                        horizontal: 10),
                                                child: Text(
                                                  allFav[i]['category'],
                                                  style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w700,
                                                    letterSpacing: 2,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                              const Spacer(),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              IconButton(
                                                color: Colors.grey,
                                                onPressed: () {
                                                  Provider.of<CartController>(
                                                    context,
                                                    listen: false,
                                                  ).decrement(e: allFav[i]);
                                                },
                                                icon: const Icon(
                                                  Icons.remove,
                                                  size: 25,
                                                ),
                                              ),
                                              Container(
                                                alignment: Alignment.center,
                                                height: 30,
                                                width: 30,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: Colors.grey.shade400,
                                                ),
                                                child: Text(
                                                  '${allFav[i]['quantity']}',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 22,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              IconButton(
                                                color: Colors.grey,
                                                onPressed: () {
                                                  Provider.of<CartController>(
                                                    context,
                                                    listen: false,
                                                  ).increment(e: allFav[i]);
                                                },
                                                icon: const Icon(
                                                  Icons.add,
                                                  size: 25,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 160 - 76,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 3),
                                  child: Text(
                                    'Total Amount : $sum',
                                    style: GoogleFonts.alata(
                                      letterSpacing: 1,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 8),
                                  child: Text(
                                    'Total Amount : $qut',
                                    style: GoogleFonts.alata(
                                      letterSpacing: 1,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Center(
                      child: Icon(
                        Icons.add_shopping_cart,
                        size: 300,
                        color: Colors.grey.shade300,
                      ),
                    );
                  }
                }
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.red,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
