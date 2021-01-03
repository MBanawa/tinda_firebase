import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tinda/widgets/itemBuilder/itemPerCategory_builder.dart';

class ItemsPerCategory extends StatefulWidget {
  final String categoryId;

  ItemsPerCategory(this.categoryId);

  @override
  _ItemsPerCategoryState createState() => _ItemsPerCategoryState();
}

class _ItemsPerCategoryState extends State<ItemsPerCategory> {
  String _category;
  Stream userstream;
  CollectionReference itemcollection =
      FirebaseFirestore.instance.collection('items');

  @override
  void initState() {
    super.initState();

    getStream();
  }

  void getStream() async {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    setState(() {
      userstream = itemcollection
          .where('userId', isEqualTo: firebaseUser.uid)
          .where('categoryId', isEqualTo: widget.categoryId)
          .orderBy('createdAt')
          .snapshots();
    });

    final categDoc = await FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.categoryId)
        .get();

    setState(() {
      _category = categDoc.data()['categoryname'];
    });
  }

  //TODO: pre-load images so that it won't show grey shadow first?
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$_category'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: userstream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final itemDocs = snapshot.data.docs;

          return ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: itemDocs.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 4.0),
                child: InkWell(
                  splashColor: Colors.teal.withAlpha(80),
                  onTap: () {},
                  child: Container(
                    // itemDocs[index].data()['itemName']
                    child: MakeItem(
                      id: itemDocs[index].id,
                      createdAt: itemDocs[index].data()['createdAt'].toString(),
                      category: itemDocs[index].data()['category'],
                      categoryId: itemDocs[index].data()['categoryId'],
                      barcode: itemDocs[index].data()['barcode'],
                      itemName: itemDocs[index].data()['itemName'],
                      quantity: itemDocs[index].data()['quantity'],
                      image: itemDocs[index].data()['itemImage'],
                      buyDate: itemDocs[index].data()['buyDate'],
                      supplier: itemDocs[index].data()['supplier'],
                      buyPrice: itemDocs[index].data()['buyPrice'],
                      sellPrice: itemDocs[index].data()['sellPrice'],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
