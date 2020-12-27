import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ItemsPerCategory extends StatefulWidget {
  final String category;

  ItemsPerCategory(this.category);

  @override
  _ItemsPerCategoryState createState() => _ItemsPerCategoryState();
}

class _ItemsPerCategoryState extends State<ItemsPerCategory> {
  Stream userstream;
  CollectionReference itemcollection =
      FirebaseFirestore.instance.collection('items');

  @override
  void initState() {
    super.initState();

    getStream();
  }

  getStream() async {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    setState(() {
      userstream = itemcollection
          .where('userId', isEqualTo: firebaseUser.uid)
          .where('category', isEqualTo: widget.category)
          .orderBy('createdAt')
          .snapshots();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
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
              return Card(
                margin: const EdgeInsets.all(8),
                elevation: 3,
                child: InkWell(
                  splashColor: Colors.teal.withAlpha(80),
                  onTap: () {},
                  child: Container(
                    height: 60,
                    child:
                        Center(child: Text(itemDocs[index].data()['itemName'])),
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
