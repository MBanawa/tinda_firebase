import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tinda/models/cashier/cashier_item.dart';
import 'package:tinda/widgets/shared-widgets/images/cached_image_widget.dart';

class SearchItemView extends StatefulWidget {
  final Function(String, CashierItem) addToSummary;
  SearchItemView({Key key, @required this.addToSummary}) : super(key: key);

  @override
  _SearchItemViewState createState() => _SearchItemViewState();
}

class _SearchItemViewState extends State<SearchItemView> {
  final _searchController = TextEditingController();

  CollectionReference itemsCollection =
      FirebaseFirestore.instance.collection('items');
  void searchItems() async {
    FocusScope.of(context).unfocus();
    setState(() {});
  }

  addToSummary(DocumentSnapshot item) async {
    TextEditingController _quantityController =
        TextEditingController(text: '1');

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Item quantity'),
        content: TextField(
          controller: _quantityController,
          decoration: InputDecoration(
            labelText: 'Quantity',
            hintText: 'Please enter ItenQuantity',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              widget.addToSummary(
                item.id,
                CashierItem(
                  title: item['itemName'],
                  price: item['sellPrice'],
                  quantity: int.tryParse(_quantityController.text) ?? 1,
                ),
              );
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text(
              'Done',
              style: TextStyle(
                color: Colors.grey[700],
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              widget.addToSummary(
                item.id,
                CashierItem(
                  title: item['itemName'],
                  price: item['sellPrice'],
                  quantity: int.tryParse(_quantityController.text) ?? 1,
                ),
              );
              Navigator.pop(context);
            },
            child: Text('Scan more'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Type your search here',
            hintStyle: TextStyle(color: Colors.grey[300]),
          ),
          style: TextStyle(color: Colors.white),
          onSubmitted: (text) => searchItems(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: Icon(Icons.search, size: 30),
              onPressed: searchItems,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _searchController.text.trim().length > 0
            ? StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('items')
                    .where(
                      'searchKeywords',
                      arrayContains:
                          _searchController.text.trim().toLowerCase(),
                    )
                    .where(
                      'userId',
                      isEqualTo: FirebaseAuth.instance.currentUser.uid,
                    )
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data.docs.length == 0)
                    return Center(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          'You can search by typing item name above',
                        ),
                      ),
                    );
                  else if (snapshot.hasData)
                    return ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        var item = snapshot.data.docs[index].data();
                        return Container(
                          margin: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x22000000),
                                blurRadius: 12,
                                offset: Offset(0, 3),
                              )
                            ],
                          ),
                          child: GestureDetector(
                            onTap: () =>
                                addToSummary(snapshot.data.docs[index]),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Row(
                                children: [
                                  CachedImageWidget(
                                    url: item['itemImage'],
                                    width: 128,
                                    height: 130,
                                  ),
                                  Flexible(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 4,
                                        horizontal: 8.0,
                                      ),
                                      height: 130,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            item['itemName'],
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6
                                                .copyWith(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 17,
                                                ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                              top: 2.0,
                                              bottom: 0.0,
                                            ),
                                            child: Text(
                                              (item['sellPrice'] as double)
                                                      .toStringAsFixed(2) +
                                                  ' PHP',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2
                                                  .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ),
                                          Text(
                                            item['category'],
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                .copyWith(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  return ImageLoadingWidget();
                },
              )
            : Center(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    'You can search by typing item name above',
                  ),
                ),
              ),
      ),
    );
  }
}
