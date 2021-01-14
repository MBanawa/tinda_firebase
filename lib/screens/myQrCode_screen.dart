import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyQrCodeScreen extends StatefulWidget {
  @override
  _MyQrCodeScreenState createState() => _MyQrCodeScreenState();
}

class _MyQrCodeScreenState extends State<MyQrCodeScreen> {
  Stream userstream;

  CollectionReference qrcollection =
      FirebaseFirestore.instance.collection('qrData');

  @override
  void initState() {
    super.initState();
    getStream();
  }

  getStream() async {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    setState(() {
      userstream = qrcollection
          .where('userId', isEqualTo: firebaseUser.uid)
          // .orderBy('createdAt')
          .snapshots();
    });
  }

  //TODO: Print Gridview
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Qr Codes'),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 15),
              child: StreamBuilder<QuerySnapshot>(
                stream: userstream,
                builder: (ctx, qrSnapshot) {
                  if (qrSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final qrDocs = qrSnapshot.data.docs;
                  return GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2.5 / 3,
                      crossAxisSpacing: 10,
                    ),
                    physics: BouncingScrollPhysics(),
                    itemCount: qrDocs.length,
                    itemBuilder: (context, index) {
                      return GridTile(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.network(qrDocs[index].data()['qrUrl']),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                'Code: ${qrDocs[index].data()['qrName']}',
                                style: TextStyle(
                                  color: Colors.teal.shade900,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 4,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
