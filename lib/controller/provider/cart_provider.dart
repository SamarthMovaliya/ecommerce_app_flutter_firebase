import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_firebase/controller/helper_classes/firebase_firestore_helper.dart';
import 'package:ecommerce_app_firebase/models/provider/cart_model.dart';
import 'package:flutter/material.dart';

import '../../models/product_model.dart';

class CartController extends ChangeNotifier {
  //add to cart
  CartModel cartModel = CartModel(i: 1);

  addToCart({required products e}) {
    Map<String, dynamic> temp = {
      'id': e.id,
      'name': e.name,
      'category': e.category,
      'description': e.description,
      'image': e.image,
      'quantity': e.quantity,
      'price': e.price,
    };
    FireBaseStoreHelper.fireBaseStoreHelper.cartInsert(data: temp);
    notifyListeners();
  }

  deleteFromCart({required int Uid}) {
    FireBaseStoreHelper.fireBaseStoreHelper.cartDelete(Uid: Uid);
    notifyListeners();
  }

  increment({required QueryDocumentSnapshot<Map<String, dynamic>> e}) {
    cartModel.i = e['quantity'];
    ++cartModel.i;
    int Uid = e['Uid'];
    print(cartModel.i);
    Map<String, dynamic> temp = {
      'Uid': Uid,
      'id': e['id'],
      'name': e['name'],
      'category': e['category'],
      'description': e['description'],
      'image': e['image'],
      'quantity': cartModel.i,
      'price': e['price'],
    };
    FireBaseStoreHelper.fireBaseStoreHelper.cartUpdate(data: temp);
    notifyListeners();
  }

  decrement({required QueryDocumentSnapshot<Map<String, dynamic>> e}) {
    cartModel.i = e['quantity'];
    if (e['quantity'] == 1) {
      deleteFromCart(Uid: e['Uid']);
    } else {
      --cartModel.i;
      int Uid = e['Uid'];
      print(cartModel.i);
      Map<String, dynamic> temp = {
        'Uid': Uid,
        'id': e['id'],
        'name': e['name'],
        'category': e['category'],
        'description': e['description'],
        'image': e['image'],
        'quantity': cartModel.i,
        'price': e['price'],
      };
      FireBaseStoreHelper.fireBaseStoreHelper.cartUpdate(data: temp);
    }
    notifyListeners();
  }
}
