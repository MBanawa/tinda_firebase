import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

import 'package:provider/provider.dart';

import 'package:tinda/providers/category_provider.dart';
import 'package:tinda/widgets/InventoryCard.dart';
import 'package:tinda/widgets/categoryBuilder/edit_category.dart';
import 'package:tinda/widgets/categoryBuilder/new_category.dart';
import 'package:tinda/widgets/drawer/drawer_navigation.dart';
import 'package:tinda/widgets/dropDown.dart';
import 'package:tinda/widgets/itemBuilder/new_item.dart';
import 'package:tinda/widgets/menuItem.dart';
import 'package:tinda/widgets/search_field.dart';

class InventoryScreen extends StatefulWidget {
  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  String _scanBarcode = '';
  Stream userstream;

  @override
  void initState() {
    super.initState();
    getStream();
  }

  CollectionReference categcollection =
      FirebaseFirestore.instance.collection('categories');

  getStream() async {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    setState(() {
      userstream = categcollection
          .where('userId', isEqualTo: firebaseUser.uid)
          .orderBy('createdAt')
          .snapshots();
    });
  }

  _scanDialog(context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text(
              'Add Stocks',
              style: TextStyle(color: Colors.white),
            ),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 20,
                    height: 60,
                    child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0)),
                        color: Colors.yellow.shade900,
                        child: Text(
                          'Scan item now',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          scanBarcodeNormal()
                              .then((value) => _selectionDialog(context));
                        }),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'OR',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 20,
                    height: 60,
                    child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0)),
                        color: Colors.yellow.shade900,
                        child: Text(
                          'Create item without Barcode',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          _selectionDialog(context);
                          _scanBarcode = null;
                        }),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      if (barcodeScanRes.length < 3) {
        _scanBarcode = 'No Data';
      } else {
        _scanBarcode = barcodeScanRes;
      }
    });
  }

  FirebaseDropDown _dropDownList() => FirebaseDropDown();

  _selectionDialog(context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            backgroundColor: Theme.of(context).primaryColor,
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.teal[50],
                  ),
                ),
              ),
              _scanBarcode == 'No Data'
                  ? null
                  : RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0)),
                      color: Colors.yellow.shade900,
                      onPressed: () {
                        Navigator.pop(context);
                        final providedCategory = Provider.of<CategoryProvider>(
                            context,
                            listen: false);

                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => NewItem(
                                  categoryId:
                                      providedCategory.getCategory.categoryId,
                                  barcode: _scanBarcode,
                                )));
                      },
                      child: Text(
                        'Continue',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
            ],
            title: Text(
              _scanBarcode == 'No Data'
                  ? 'No Barcode Data Captured'
                  : 'Please Select a Category for ${_scanBarcode != null ? _scanBarcode : 'this new item'}',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            content: _scanBarcode == 'No Data'
                ? SizedBox(
                    height: 60,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0)),
                      color: Colors.yellow.shade900,
                      onPressed: () {
                        Navigator.pop(context);
                        scanBarcodeNormal()
                            .then((value) => _selectionDialog(context))
                            .then((value) => null);
                      },
                      child: Text(
                        'Scan Again',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 20,
                          height: 60,
                          child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0)),
                              color: Colors.yellow.shade900,
                              child: Text(
                                'Create a new Category',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NewCategory(
                                            barcode: _scanBarcode)));
                              }),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          'OR',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        _dropDownList(),
                      ],
                    ),
                  ),
          );
        });
  }

  executeAfterWholeBuildProcess(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    final doc = FirebaseFirestore.instance.collection('refresh').doc(user.uid);
    final userData = await doc.get();
    if (userData.data()['refresh'] == 1) {
      doc.update({'refresh': 0});
      Phoenix.rebirth(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => executeAfterWholeBuildProcess(context));
    return Scaffold(
      drawer: DrawerNavigation(),
      appBar: AppBar(
        centerTitle: true,
        title: Text('Inventory Manager'),
      ),
      //TODO: add to stock for items with no barcode??
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _scanDialog(context);
        },
      ),

      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            SearchFieldWidget(
              hintText: 'Search Category',
            ),
            Container(
              child: StreamBuilder<QuerySnapshot>(
                  stream: userstream,
                  builder: (ctx, categSnapshot) {
                    if (categSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final categDocs = categSnapshot.data.docs;

                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: categDocs.length,
                      itemBuilder: (context, index) {
                        return InventoryCard(
                          categID: categDocs[index].id,
                          categName: categDocs[index].data()['categoryname'],
                          categDescription:
                              categDocs[index].data()['categorydescription'],
                          categColor: categDocs[index].data()['categorycolor'],
                          onMenuItemSelected: (MenuItem menuItem) {
                            if (menuItem.menuVal == "Edit") {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      EditCategory(
                                        context,
                                        categDocs[index].id,
                                        categDocs[index].data()['categoryname'],
                                        categDocs[index]
                                            .data()['categorydescription'],
                                        categDocs[index]
                                            .data()['categorycolor'],
                                      )));
                            } else if (menuItem.menuVal == "Delete") {
                              //delete category
                              CollectionReference categs = FirebaseFirestore
                                  .instance
                                  .collection('categories');
                              categs.doc(categDocs[index].id).delete();
                            }
                          },
                        );
                      },
                    );
                  }),
            ),
            SizedBox(height: 80.0)
          ],
        ),
      ),
    );
  }
}
