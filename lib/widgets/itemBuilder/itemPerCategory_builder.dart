import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tinda/animation/FadeAnimation.dart';
import 'package:tinda/screens/itemDetail_screen.dart';
import 'package:tinda/widgets/itemBuilder/edit_item.dart';

Color fontColor = Colors.white;

class MakeItem extends StatelessWidget {
  final String id;
  final String createdAt;
  final String category;
  final String categoryId;
  final String barcode;
  final String itemName;
  final String quantity;
  final String image;
  final String buyDate;
  final String supplier;
  final String buyPrice;
  final String sellPrice;

  MakeItem({
    @required this.id,
    @required this.createdAt,
    @required this.category,
    @required this.categoryId,
    @required this.barcode,
    @required this.itemName,
    @required this.quantity,
    @required this.image,
    @required this.buyDate,
    @required this.supplier,
    @required this.buyPrice,
    @required this.sellPrice,
  });

  _deleteDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (dialogContext) {
          return AlertDialog(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text(
              'Delete Confirmation',
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              'Are you sure you want to delete $itemName? This action is permanent.',
              style: TextStyle(color: Colors.yellow),
            ),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Container(
                width: 100.0,
                child: RaisedButton(
                  color: Colors.yellow.shade900,
                  child: Text(
                    'Delete',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    //Delete Item Document
                    CollectionReference items =
                        FirebaseFirestore.instance.collection('items');
                    var result = await items
                        .doc(id)
                        .delete()
                        .then((value) => value = 'deleted')
                        .catchError((error) => print(error));
                    if (result == 'deleted') {
                      //Delete Item Image
                      final storageReference =
                          FirebaseStorage.instance.refFromURL(image);
                      storageReference
                          .delete()
                          .catchError((error) => print(error));

                      //Delete Item Supplier Document
                      final supplier =
                          FirebaseFirestore.instance.collection('suppliers');
                      supplier
                          .where('itemId', isEqualTo: id)
                          .get()
                          .then((value) {
                        supplier
                            .doc(value.docs.first.id)
                            .delete()
                            .catchError((error) => print(error));
                      });

                      //Delete Item sellprice Document
                      final sellprice =
                          FirebaseFirestore.instance.collection('sellprice');
                      sellprice
                          .where('itemId', isEqualTo: id)
                          .get()
                          .then((value) {
                        sellprice
                            .doc(value.docs.first.id)
                            .delete()
                            .catchError((error) => print(error));
                      });

                      Navigator.of(dialogContext).pop();
                    }
                  },
                ),
              ),
            ],
          );
        });
  }

  _editDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text(
              'Please select an option for $itemName',
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
                                    option: 'add',
                                    itemId: id,
                                    category: category,
                                    barcode: barcode,
                                    itemName: itemName,
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
                                    option: 'remove',
                                    itemId: id,
                                    category: category,
                                    barcode: barcode,
                                    itemName: itemName,
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
                                    itemName: itemName,
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
                          Navigator.pop(context);
                          _deleteDialog(context)
                              // .then((value) =>
                              //     value == 'deleted'
                              //         ? Navigator.pop(context)
                              //         : null)
                              ;
                        }),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: itemName,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ItemDetail(image, itemName, quantity)));
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
                  itemName,
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
}
