import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tinda/models/cashier/cashier_item.dart';

declareSale(
  Map<String, CashierItem> items,
  double cash,
  double total,
) async {
  if (items.length == 0) return;
  int saleNumber = (await FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser.uid)
              .get())
          .data()['salesCount'] ??
      1;
  List itemsList = [];
  items.forEach((key, value) {
    itemsList.add({
      'itemId': key,
      'itemTitle': value.title,
      'quantity': value.quantity,
      'price': value.price,
    });
  });
  FirebaseFirestore.instance.collection('sales').add({
    'id': saleNumber,
    'date': DateTime.now(),
    'items': itemsList,
    'orderTotal': total,
    'paymentAmount': cash,
    'change': cash - total,
  });
  await FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser.uid)
      .update({
    'salesCount': saleNumber + 1,
  });
}
