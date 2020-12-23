import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tinda/authentication/authentication.dart';
import 'package:tinda/widgets/categoryBuilder/edit_category.dart';

import 'package:tinda/widgets/categoryBuilder/new_category.dart';
import 'package:tinda/widgets/menuItem.dart';

class InventoryScreen extends StatefulWidget {
  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventory Screen'),
        actions: [
          FlatButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Route route =
                    MaterialPageRoute(builder: (_) => AuthenticScreen());
                Navigator.pushReplacement(context, route);
              },
              child: Text('Sign Out'))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => NewCategory()));
        },
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('categories')
            .orderBy('createdAt')
            .snapshots(),
        builder: (ctx, AsyncSnapshot<QuerySnapshot> categSnapshot) {
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
                                print(menuItem.menuVal);
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
