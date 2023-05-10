import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_firebase/controller/helper_classes/firebase_firestore_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_ios/image_picker_ios.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../models/resources.dart';

class drawerComponent extends StatefulWidget {
  const drawerComponent({Key? key}) : super(key: key);

  @override
  State<drawerComponent> createState() => _drawerComponentState();
}

class _drawerComponentState extends State<drawerComponent> {
  @override
  Widget build(BuildContext context) {
    print(person!.displayName);
    File? img;
    Future getImage() async {
      print('hello');
      var img =
          await ImagePickerIOS().getImageFromSource(source: ImageSource.camera);
      if (img == null) return;
      final ImageTemp = File(img.path);
      setState(() {
        img = ImageTemp as XFile?;
      });
    }

    Reference refImg;
    String ImageUrl = '';
    getimg() async {
      ImagePicker imagePicker = ImagePicker();
      XFile? myImage = await imagePicker.pickImage(source: ImageSource.gallery);

      String tempFile = person!.email ?? myImage!.path;
      //initialize FirebaseStorage
      Reference reference = FirebaseStorage.instance.ref();
      //create folder in FirebaseStorage
      Reference refRoot = reference.child('clients');
      // now upload image in Folder
      refImg = refRoot.child(tempFile);
      //putting file in image
      refImg.putFile(File(myImage!.path));
      print('img_uploded');
      ImageUrl = await refImg.getDownloadURL();
      Map<String, dynamic> tempp = {
        'name': tempFile,
        'image': ImageUrl,
      };
      FireBaseStoreHelper.fireBaseStoreHelper.imageInsert(data: tempp);
    }

    ;
    return Drawer(
      child: Builder(builder: (context) {
        return Column(
          children: [
            Expanded(
                flex: 4,
                child: Container(
                  width: double.infinity,
                  color: Colors.red.shade200,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 60,
                        ),
                        StreamBuilder(
                          stream: FireBaseStoreHelper.db
                              .collection("UserImage")
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  const CircleAvatar(
                                    backgroundImage: AssetImage(
                                        'assets/images/logo/user.png'),
                                    radius: 50,
                                    backgroundColor: Colors.blue,
                                  ),
                                  Container(
                                    height: 40,
                                    width: 40,
                                    child: ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                          Colors.red.shade300,
                                        )),
                                        onPressed: getimg,
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: const Icon(
                                            Icons.add,
                                            color: Colors.white,
                                            size: 10,
                                          ),
                                        )),
                                  ),
                                ],
                              );
                            } else if (snapshot.hasData) {
                              QuerySnapshot<Map<String, dynamic>>? favourite =
                                  snapshot.data;
                              List<QueryDocumentSnapshot<Map<String, dynamic>>>
                                  imgs = favourite!.docs;
                              if (imgs.isEmpty) {
                                return Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    const CircleAvatar(
                                      backgroundImage: AssetImage(
                                          'assets/images/logo/user.png'),
                                      radius: 50,
                                      backgroundColor: Colors.blue,
                                    ),
                                    Container(
                                      height: 40,
                                      width: 40,
                                      child: ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                            Colors.red.shade300,
                                          )),
                                          onPressed: getimg,
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: const Icon(
                                              Icons.add,
                                              color: Colors.white,
                                              size: 10,
                                            ),
                                          )),
                                    ),
                                  ],
                                );
                              } else {
                                return Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    CircleAvatar(
                                      backgroundImage:
                                          NetworkImage('${imgs[0]['image']}'),
                                      radius: 50,
                                      backgroundColor: Colors.blue,
                                    ),
                                  ],
                                );
                              }
                            }
                            return Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                const CircleAvatar(
                                  backgroundImage:
                                      AssetImage('assets/images/logo/user.png'),
                                  radius: 50,
                                  backgroundColor: Colors.blue,
                                ),
                                Container(
                                  height: 40,
                                  width: 40,
                                  child: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                        Colors.red.shade300,
                                      )),
                                      onPressed: getimg,
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: const Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 10,
                                        ),
                                      )),
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          (person!.email == null) ? '' : '${person!.email} ',
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'User',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                )),
            Expanded(
                flex: 10,
                child: Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Icon(Icons.favorite),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              'Favourite',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Icon(Icons.person),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              'Users',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Container(
                        padding: EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Icon(Icons.settings),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              'Settings',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Icon(Icons.shopping_cart),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              'Orders',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Icon(Icons.help),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              'Help',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        );
      }),
    );
  }
}
