import 'dart:io';
import 'dart:typed_data';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

class MyQrCodeScreen extends StatefulWidget {
  @override
  _MyQrCodeScreenState createState() => _MyQrCodeScreenState();
}

class _MyQrCodeScreenState extends State<MyQrCodeScreen> {
  Stream userstream;

  CollectionReference qrcollection =
      FirebaseFirestore.instance.collection('qrData');

  ScreenshotController screenshotController = ScreenshotController();

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

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  _downloadQrCode() {
    Directory directory;
    _requestPermission(Permission.storage);
    try {
      screenshotController
          .capture(delay: Duration(milliseconds: 10))
          .then((Uint8List image) async {
        setState(() {});
        if (await _requestPermission(Permission.storage)) {
          directory = await getExternalStorageDirectory();

          String newPath = '';
          List<String> folders = directory.path.split('/');

          ///storage/emulated/0/Android/data/com.banawa.tinda/files
          for (int x = 1; x < folders.length; x++) {
            String folder = folders[x];
            if (folder != 'Android') {
              newPath += '/' + folder;
            } else {
              break;
            }
          }
          newPath = newPath + '/Tinda';
          directory = Directory(newPath);
          print(directory.path);
        } else {
          return false;
        }
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }
        if (await directory.exists()) {
          final result = await ImageGallerySaver.saveImage(
            image,
            quality: 100,
          );
          print("File Saved");
          print(result);
        }
      }).catchError((onError) {
        print(onError);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Qr Codes'),
        actions: [
          IconButton(
            icon: Icon(Icons.download_sharp),
            onPressed: _downloadQrCode,
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Screenshot(
          controller: screenshotController,
          child: Column(
            children: [
              Container(
                color: Colors.white,
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
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                BarcodeWidget(
                                  data: qrDocs[index].data()['qrName'],
                                  barcode: Barcode.qrCode(),
                                  color: Colors.black,
                                  height: 150,
                                  width: 150,
                                ),
                                Text(
                                  'Code: ${qrDocs[index].data()['qrName']}',
                                  style: TextStyle(
                                    color: Colors.teal.shade900,
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 4,
                                ),
                              ],
                            ),
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
      ),
    );
  }
}
