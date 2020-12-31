import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tinda/animation/FadeAnimation.dart';

import 'package:tinda/screens/itemDetail_screen.dart';
import 'package:tinda/widgets/itemBuilder/edit_item.dart';

Color fontColor = Colors.white;

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

  void getStream() async {
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
              return Padding(
                padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 4.0),
                child: InkWell(
                  splashColor: Colors.teal.withAlpha(80),
                  onTap: () {},
                  child: Container(
                    // itemDocs[index].data()['itemName']
                    child: makeItem(
                      itemDocs[index].id,
                      itemDocs[index].data()['createdAt'],
                      itemDocs[index].data()['category'],
                      itemDocs[index].data()['barcode'],
                      itemDocs[index].data()['itemName'],
                      itemDocs[index].data()['quantity'],
                      itemDocs[index].data()['itemImage'],
                      itemDocs[index].data()['buyDate'],
                      itemDocs[index].data()['supplier'],
                      itemDocs[index].data()['buyPrice'],
                      itemDocs[index].data()['sellPrice'],
                      context,
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

Widget makeItem(
  id,
  createdAt,
  category,
  barcode,
  tag,
  quantity,
  image,
  buyDate,
  supplier,
  buyPrice,
  sellPrice,
  context,
) {
  _editDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text(
              'Please select an option for $tag',
              style: TextStyle(color: Colors.white),
            ),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 20,
                    height: 60,
                    child: RaisedButton.icon(
                        icon: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0)),
                        color: Colors.yellow.shade900,
                        label: Text(
                          'Add Stocks',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => EditItem(
                                    option: 'update',
                                    itemId: id,
                                    category: category,
                                    barcode: barcode,
                                    itemName: tag,
                                    itemQuantity: quantity,
                                    itemImage: image,
                                    buyDate: buyDate,
                                    supplier: supplier,
                                    buyPrice: buyPrice,
                                    sellPrice: sellPrice,
                                  )));
                        }),
                  ),
                  SizedBox(height: 10.0),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 20,
                    height: 60,
                    child: RaisedButton.icon(
                        icon: Icon(
                          Icons.remove,
                          color: Colors.white,
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0)),
                        color: Colors.yellow.shade900,
                        label: Text(
                          'Remove Stocks',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => EditItem(
                                    option: 'update',
                                    itemId: id,
                                    category: category,
                                    barcode: barcode,
                                    itemName: tag,
                                    itemQuantity: quantity,
                                    itemImage: image,
                                    buyDate: buyDate,
                                    supplier: supplier,
                                    buyPrice: buyPrice,
                                    sellPrice: sellPrice,
                                  )));
                        }),
                  ),
                  SizedBox(height: 10.0),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 20,
                    height: 60,
                    child: RaisedButton.icon(
                        icon: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0)),
                        color: Colors.yellow.shade900,
                        label: Text(
                          'Edit this item',
                          softWrap: true,
                          maxLines: 3,
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.start,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => EditItem(
                                    option: 'edit',
                                    itemId: id,
                                    category: category,
                                    barcode: barcode,
                                    itemName: tag,
                                    itemQuantity: quantity,
                                    itemImage: image,
                                    buyDate: buyDate,
                                    supplier: supplier,
                                    buyPrice: buyPrice,
                                    sellPrice: sellPrice,
                                  )));
                        }),
                  ),
                  SizedBox(height: 10.0),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 20,
                    height: 60,
                    child: RaisedButton.icon(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0)),
                        color: Colors.red.shade400,
                        label: Text(
                          'Delete this item',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => EditItem(
                                    option: 'update',
                                    itemId: id,
                                    category: category,
                                    barcode: barcode,
                                    itemName: tag,
                                    itemQuantity: quantity,
                                    itemImage: image,
                                    buyDate: buyDate,
                                    supplier: supplier,
                                    buyPrice: buyPrice,
                                    sellPrice: sellPrice,
                                  )));
                        }),
                  ),
                ],
              ),
            ),
          );
        });
  }

  return Hero(
    tag: tag,
    child: GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ItemDetail(image, tag, quantity)));
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        height: 250,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          image: DecorationImage(
            image: NetworkImage(image),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.teal,
              BlendMode.modulate,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[500],
              blurRadius: 10,
              offset: Offset(0, 10),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FadeAnimation(
                        0.5,
                        Text(
                          'In Stock: $quantity',
                          style: TextStyle(
                              color: fontColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      FadeAnimation(
                        .6,
                        Text(
                          'Buy Price: PHP ${double.parse(buyPrice).toStringAsFixed(2)}',
                          style: TextStyle(
                              color: fontColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      _editDialog(context);
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.yellow.shade900),
                      child: Center(
                        child: Icon(
                          Icons.settings,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            FadeAnimation(
              0.7,
              Text(
                tag,
                style: TextStyle(
                  color: fontColor,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
