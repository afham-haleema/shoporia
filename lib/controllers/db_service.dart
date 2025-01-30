import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shoporia_app/models/cart_model.dart';

class DbService {
  User? user = FirebaseAuth.instance.currentUser;

  Future saveUserData({required String name, required String email}) async {
    try {
      Map<String, dynamic> data = {'name': name, 'email': email};
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .set(data);
    } catch (e) {
      print('Error on saving user data ${e}');
    }
  }

  Future updateUserData({required Map<String, dynamic> extraData}) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .update(extraData);
  }

  // Read Users
  Stream<DocumentSnapshot> readUserdata() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .snapshots();
  }

  // Read Promos
  Stream<QuerySnapshot> readPromos() {
    return FirebaseFirestore.instance.collection('promos').snapshots();
  }

  // Read Banners
  Stream<QuerySnapshot> readBanners() {
    return FirebaseFirestore.instance.collection('banners').snapshots();
  }

  // Read Coupons
  Stream<QuerySnapshot> readCoupons() {
    return FirebaseFirestore.instance
        .collection('coupons')
        .orderBy('discount', descending: true)
        .snapshots();
  }

  // Verify coupon
  Future<QuerySnapshot> verifyDiscount({required String code}) {
    return FirebaseFirestore.instance
        .collection('coupons')
        .where('code', isEqualTo: code)
        .get();
  }

  // read category
  Stream<QuerySnapshot> readCategories() {
    return FirebaseFirestore.instance
        .collection('categories')
        .orderBy('priority', descending: true)
        .snapshots();
  }

// Read Products
  Stream<QuerySnapshot> readProducts(String category) {
    return FirebaseFirestore.instance
        .collection('products')
        .where('category', isEqualTo: category.toLowerCase())
        .snapshots();
  }

  // Serach product by doc id

  Stream<QuerySnapshot> searchProducts(List<String> docIds) {
    return FirebaseFirestore.instance
        .collection('products')
        .where(FieldPath.documentId, whereIn: docIds)
        .snapshots();
  }

  // reduce count of product

  Future decrementQty({required String productd, required int qty}) async {
    await FirebaseFirestore.instance
        .collection('products')
        .doc(productd)
        .update({'quantity': FieldValue.increment(-qty)});
  }

  // display user cart

  Stream<QuerySnapshot> readUserCart() {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("cart")
        .snapshots();
  }

  // adding product to the cart
  Future addToCart({required CartModel cartData}) async {
    try {
      // update
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .collection("cart")
          .doc(cartData.productId)
          .update({
        "product_id": cartData.productId,
        "quantity": FieldValue.increment(1)
      });
    } on FirebaseException catch (e) {
      print("firebase exception : ${e.code}");
      if (e.code == "not-found") {
        // insert
        await FirebaseFirestore.instance
            .collection("users")
            .doc(user!.uid)
            .collection("cart")
            .doc(cartData.productId)
            .set({"product_id": cartData.productId, "quantity": 1});
      }
    }
  }

  // delete specific product from cart
  Future deleteFromCart({required String productId}) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("cart")
        .doc(productId)
        .delete();
  }

  // empty users cart
  Future emptyCart() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("cart")
        .get()
        .then((value) {
      for (DocumentSnapshot ds in value.docs) {
        ds.reference.delete();
      }
    });
  }

  // decrease count of item
  Future decreaseCount({required String productId}) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("cart")
        .doc(productId)
        .update({"quantity": FieldValue.increment(-1)});
  }

  // create order

  Future createOrder({required Map<String, dynamic> data}) async {
    await FirebaseFirestore.instance.collection('orders').add(data);
  }

  // update order

  Future updateOrder(
      {required String docId, required Map<String, dynamic> data}) async {
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(docId)
        .update(data);
  }

  // read order

  Stream<QuerySnapshot> readOrder() {
    return FirebaseFirestore.instance
        .collection('orders')
        .where('user_id', isEqualTo: user!.uid)
        .orderBy('created_at', descending: true)
        .snapshots();
  }
}
