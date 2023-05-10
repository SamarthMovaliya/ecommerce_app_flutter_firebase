import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireBaseStoreHelper {
  FireBaseStoreHelper._();

  static final FireBaseStoreHelper fireBaseStoreHelper =
      FireBaseStoreHelper._();
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> insert({required Map<String, dynamic> data}) async {
    DocumentSnapshot<Map<String, dynamic>> k =
        await db.collection('counter').doc('CounterKeeper').get();
    int id = k['id'];
    int len = k['lenght'];
    await db.collection("product").doc("${++id}").set(data);
    db.collection("product").doc("$id").update({"Uid": id});
    db
        .collection("counter")
        .doc("CounterKeeper")
        .update({'id': id, 'lenght': ++len});
  }

  Future<void> update({required Map<String, dynamic> data}) async {
    String id = data['Uid'].toString();
    db.collection('product').doc(id).set(data);
  }

  Delete({required int Uid}) async {
    String id = Uid.toString();
    await db.collection("product").doc(id).delete();

    DocumentSnapshot<Map<String, dynamic>> k =
        await db.collection("counter").doc("CounterKeeper").get();

    int length = k['lenght'];

    await db
        .collection("counter")
        .doc("CounterKeeper")
        .update({"lenght": --length});
  }

  Future<void> cartInsert({required Map<String, dynamic> data}) async {
    DocumentSnapshot<Map<String, dynamic>> k =
        await db.collection('cartCounter').doc('cartCounterKeeper').get();
    int id = k['id'];
    int len = k['lenght'];
    await db.collection("cartProduct").doc("${++id}").set(data);
    db.collection("cartProduct").doc("$id").update({"Uid": id});
    db
        .collection("cartCounter")
        .doc("cartCounterKeeper")
        .update({'id': id, 'lenght': ++len});
  }

  Future<void> cartUpdate({required Map<String, dynamic> data}) async {
    String id = data['Uid'].toString();
    db.collection('cartProduct').doc(id).set(data);
  }

  cartDelete({required int Uid}) async {
    String id = Uid.toString();
    await db.collection("cartProduct").doc(id).delete();

    DocumentSnapshot<Map<String, dynamic>> k =
        await db.collection("cartCounter").doc("cartCounterKeeper").get();

    int length = k['lenght'];

    await db
        .collection("cartCounter")
        .doc("cartCounterKeeper")
        .update({"lenght": --length});
  }

  Future<void> imageInsert({required Map<String, dynamic> data}) async {
    DocumentSnapshot<Map<String, dynamic>> k =
        await db.collection('imgCounter').doc('imageCounterKeeper').get();
    int id = k['id'];
    int len = k['lenght'];
    await db.collection("UserImage").doc("${++id}").set(data);
    db.collection("UserImage").doc("$id").update({"Uid": id});
    db
        .collection("imgCounter")
        .doc("imageCounterKeeper")
        .update({'id': id, 'lenght': ++len});
  }
}
