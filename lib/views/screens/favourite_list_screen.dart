import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controller/helper_classes/firebase_firestore_helper.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({Key? key}) : super(key: key);

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My favourites',
          style: GoogleFonts.alata(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FireBaseStoreHelper.db.collection("product").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          } else if (snapshot.hasData) {
            QuerySnapshot<Map<String, dynamic>>? favourite = snapshot.data;
            List<QueryDocumentSnapshot<Map<String, dynamic>>> allFav =
                favourite!.docs;
            if (allFav.isNotEmpty) {
              return ListView.builder(
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
                                    : Colors.grey.shade200,
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
                            padding: const EdgeInsets.only(left: 10, top: 8.0),
                            child: Text(
                              allFav[i]['name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0,
                                fontSize: 22,
                              ),
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0, horizontal: 10),
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
                                  IconButton(
                                    onPressed: () {
                                      FireBaseStoreHelper.fireBaseStoreHelper
                                          .Delete(
                                        Uid: allFav[i]['Uid'],
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.start,
                                children: const [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text('⭐️ 5.4'),
                                  SizedBox(
                                    width: 50,
                                  ),
                                  Text('⏰ 5-10 min'),
                                  SizedBox(
                                    width: 5,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            } else {
              return Center(
                child: Icon(
                  Icons.favorite_outline_outlined,
                  size: 400,
                  color: Colors.grey.shade200,
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
    );
  }
}
