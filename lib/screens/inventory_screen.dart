import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:tinda/widgets/categoryBuilder/edit_category.dart';

import 'package:tinda/widgets/categoryBuilder/new_category.dart';
import 'package:tinda/widgets/drawer/drawer_navigation.dart';
import 'package:tinda/widgets/dropDown.dart';
import 'package:tinda/widgets/loadingWidget.dart';
import 'package:tinda/widgets/menuItem.dart';

class InventoryScreen extends StatefulWidget {
  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  String _scanBarcode = '';
  Stream userstream;
  String fuser;

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

  _scanDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text(
              'Create New Item',
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
                          'Scan Barcode Now',
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
                        ),
                        onPressed: () {
                          Navigator.pop(context);
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
      print(barcodeScanRes);
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
    print('Barcode $_scanBarcode');
  }

  var _selectedValue;
  FirebaseDropDown _dropDownList() => FirebaseDropDown(
        onChanged: (value) {
          _selectedValue = value;
        },
      );

  _selectionDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              _scanBarcode == 'No Data'
                  ? FlatButton(
                      color: Colors.grey,
                      onPressed: () {},
                      child: Text(
                        'Continue',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : FlatButton(
                      color: Colors.blue,
                      onPressed: () {
                        Navigator.pop(context);
                        // Navigator.of(context).push(MaterialPageRoute(
                        //     builder: (context) => ItemScreen(
                        //           category: _selectedValue,
                        //           barcode: _scanBarcode,
                        //         )));
                      },
                      child: Text('Continue'),
                    ),
            ],
            title: Text(_scanBarcode == 'No Data'
                ? 'No Barcode Data Captured'
                : 'Please Select a Category ${_scanBarcode != null ? _scanBarcode : 'for this new item'}'),
            content: _scanBarcode == 'No Data'
                ? RaisedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      scanBarcodeNormal()
                          .then((value) => _selectionDialog(context));
                    },
                    child: Text('Scan Again'),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        _dropDownList(),
                        SizedBox(height: 10.0),
                        Text(
                          'OR',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        RaisedButton(
                            child: Text('Create a new Category'),
                            onPressed: () {
                              Navigator.pop(context, 'NewCategory');
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NewCategory()));
                            }),
                      ],
                    ),
                  ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerNavigation(),
      appBar: AppBar(
        centerTitle: true,
        title: Text('Inventory Manager'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _scanDialog(context);
        },
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: userstream,
        builder: (ctx, categSnapshot) {
          if (categSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final categDocs = categSnapshot.data.docs;
          return ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: categDocs.length,
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                elevation: 3,
                child: InkWell(
                  splashColor: Colors.teal.withAlpha(80),
                  onTap: () {},
                  child: Container(
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width: 6,
                          height: 65,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(4),
                                bottomLeft: Radius.circular(4)),
                            color: Color(
                                categDocs[index].data()['categorycolor'] == null
                                    ? 0xff008080
                                    : categDocs[index].data()['categorycolor']),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16.0, 8, 0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      categDocs[index].data()['categoryname'],
                                      style: TextStyle(
                                        fontSize: 22.0,
                                        color: Colors.teal.shade800,
                                      ),
                                    ),
                                    Text(
                                      '${categDocs[index].data()['categorydescription']}',
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        color: Colors.orange.shade400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuButton(onSelected: (MenuItem menuItem) {
                                if (menuItem.menuVal == "Edit") {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          EditCategory(
                                            categDocs[index].id,
                                            categDocs[index]
                                                .data()['categoryname'],
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
                              }, itemBuilder: (BuildContext context) {
                                return menuitems.map((MenuItem menuItem) {
                                  return PopupMenuItem(
                                    value: menuItem,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Icon(menuItem.iconVal),
                                        Text(menuItem.menuVal),
                                      ],
                                    ),
                                  );
                                }).toList();
                              })
                            ],
                          ),
                        ),
                      ],
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
