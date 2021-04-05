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

  for (int i = 0; i < itemsList.length; i++) {
    int remainingQuantity = itemsList[i]['quantity'];
    do {
      var desiredDocId = await _firstIn(itemsList[i]['itemId']);
      var _supplier = await getSupplier(itemsList[i]['itemId'], desiredDocId);
      int _quantity = _supplier['quantity'];

      int _toBeDeducted = 0;

      if (remainingQuantity > _quantity) {
        _toBeDeducted = _quantity;
        remainingQuantity -= _quantity;
      } else {
        _toBeDeducted = remainingQuantity;
        remainingQuantity = 0;
      }

      await FirebaseFirestore.instance
          .collection('items')
          .doc(itemsList[i]['itemId'])
          .collection('suppliers')
          .doc(desiredDocId)
          .update({
        'quantity': _quantity - _toBeDeducted,
      });
    } while (remainingQuantity > 0);
    int oldQuantity = (await FirebaseFirestore.instance
            .collection('items')
            .doc(itemsList[i]['itemId'])
            .get())
        .data()['quantity'];
    await FirebaseFirestore.instance
        .collection('items')
        .doc(itemsList[i]['itemId'])
        .update({
      'quantity': oldQuantity - itemsList[i]['quantity'],
    });
  }
}

Future<dynamic> getSupplier(itemId, String docId) async {
  DocumentReference documentReference = FirebaseFirestore.instance
      .collection('items')
      .doc(itemId)
      .collection('suppliers')
      .doc(docId);
  return (await documentReference.get()).data();
}

_firstIn(itemId) async {
  var listOfDocs = await FirebaseFirestore.instance
      .collection('items')
      .doc(itemId)
      .collection('suppliers')
      .where('itemId', isEqualTo: itemId)
      .where('quantity', isGreaterThan: 0)
      .get();

  return (listOfDocs.docs
        ..sort((a, b) => (a.data()['entryDate'] as Timestamp)
            .compareTo(b.data()['entryDate'] as Timestamp)))
      .first
      .id;
}
