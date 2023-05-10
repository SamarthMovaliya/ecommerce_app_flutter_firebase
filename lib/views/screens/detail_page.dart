import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_firebase/controller/provider/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

import '../../controller/helper_classes/firebase_firestore_helper.dart';
import '../../models/product_model.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    products e = ModalRoute.of(context)!.settings.arguments as products;
    return Scaffold(
      backgroundColor:
          (Get.isDarkMode) ? Colors.red.shade200 : Colors.red.shade100,
      appBar: AppBar(
        leadingWidth: 100,
        leading: Padding(
          padding:
              const EdgeInsets.only(left: 22, top: 10, bottom: 10, right: 20),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.grey,
            ),
          ),
        ),
        foregroundColor:
            (Get.isDarkMode) ? Colors.red.shade200 : Colors.red.shade100,
        backgroundColor:
            (Get.isDarkMode) ? Colors.red.shade200 : Colors.red.shade100,
        elevation: 0,
        bottomOpacity: 0.0,
        scrolledUnderElevation: 0,
        actions: [
          const SizedBox(
            width: 10,
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 26, top: 10, bottom: 10, right: 22),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, 'CartScreen');
              },
              child: const Icon(
                Icons.shopping_cart,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(
            width: 6,
          )
        ],
      ),
      body: Column(
        children: [
          const Expanded(
            flex: 2,
            child: SizedBox(),
          ),
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                color: (Get.isDarkMode) ? Colors.grey.shade900 : Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(60),
                  topRight: Radius.circular(60),
                ),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12,
                      offset: Offset(-2, -3),
                      blurRadius: 12)
                ],
              ),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const SizedBox(
                        height: 80,
                      ),
                      const Spacer(
                        flex: 8,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              e.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w800, fontSize: 33),
                            ),
                            const Spacer(),
                            const Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Text(
                                '℈',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 3,
                            ),
                            Text(
                              e.price.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 33,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          e.category,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 23,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Divider(
                          thickness: 1.7,
                          color: Colors.grey.shade200,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              '⭐️ 5.4',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Spacer(),
                            Text(
                              '⏰ 10-20 hours',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 40),
                        child: Text(
                          e.description,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 22,
                            wordSpacing: 1.4,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: StreamBuilder(
                          stream: FireBaseStoreHelper.db
                              .collection("cartProduct")
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                    Colors.red.shade500,
                                  ),
                                ),
                                onPressed: () {
                                  Provider.of<CartController>(context,
                                          listen: false)
                                      .addToCart(e: e);
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 70,
                                  width: double.infinity,
                                  child: const Text(
                                    'Add to Cart',
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              );
                            } else if (snapshot.hasData) {
                              QuerySnapshot<Map<String, dynamic>>? favourite =
                                  snapshot.data;
                              List<QueryDocumentSnapshot<Map<String, dynamic>>>
                                  allFav = favourite!.docs;
                              if (allFav.isNotEmpty) {
                                int check = 0;
                                allFav.forEach((f) {
                                  if (f['name'] == e.name) {
                                    check = 1;
                                  }
                                });
                                if (check == 0) {
                                  return ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                        Colors.red.shade500,
                                      ),
                                    ),
                                    onPressed: () {
                                      Provider.of<CartController>(context,
                                              listen: false)
                                          .addToCart(e: e);
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 70,
                                      width: double.infinity,
                                      child: const Text(
                                        'Add to Cart',
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  return ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                        Colors.grey.shade500,
                                      ),
                                    ),
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          backgroundColor: Colors.red,
                                          duration: Duration(seconds: 1),
                                          behavior: SnackBarBehavior.floating,
                                          content: Text(
                                            'Product Already addaed to cart',
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 70,
                                      width: double.infinity,
                                      child: const Text(
                                        'Added to Cart',
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              } else {
                                return ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                      Colors.red.shade500,
                                    ),
                                  ),
                                  onPressed: () {
                                    Provider.of<CartController>(context,
                                            listen: false)
                                        .addToCart(e: e);
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 70,
                                    width: double.infinity,
                                    child: const Text(
                                      'Add to Cart',
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                );
                              }
                            }
                            return ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  Colors.red.shade500,
                                ),
                              ),
                              onPressed: () {
                                Provider.of<CartController>(context,
                                        listen: false)
                                    .addToCart(e: e);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 70,
                                width: double.infinity,
                                child: const Text(
                                  'Add to Cart',
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                  Transform.translate(
                    offset: const Offset(0, -150),
                    child: Transform.scale(
                      scale: 0.6,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Hero(
                          tag: e.name,
                          child: Transform.translate(
                            offset: const Offset(0, -250),
                            child: Image.asset(e.image),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
