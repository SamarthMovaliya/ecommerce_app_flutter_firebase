import 'package:ecommerce_app_firebase/models/getx/category_model_getx.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryControllerGetx extends GetxController {
  CategoryModelGetx categoryModelGetx = CategoryModelGetx(i: 0);

  changeCategory({required int temp}) {
    categoryModelGetx.i = temp;
    update();
  }
}
