import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class GenerateQr extends StatefulWidget {
  @override
  _GenerateQrState createState() => _GenerateQrState();
}

class _GenerateQrState extends State<GenerateQr> {
  var _qrController = TextEditingController();
  String _qrCode;
  String _url;
  FocusNode _qrFocus = FocusNode();
  GlobalKey _globalKey = GlobalKey();
  bool loading = false;
  final Dio dio = Dio();
  double progress = 0;

  _qrGenerator() {
    FocusScope.of(context).unfocus();
    setState(() {
      _qrCode = _qrController.text.trim();
    });
  }

  Future<void> _saveQrImage() async {
    RenderRepaintBoundary boundary =
        _globalKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage();
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();

    this.setState(() {
      loading = true;
    });

    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    final ref = FirebaseStorage.instance.ref().child('qrCodes').child(_qrCode +
        '_' +
        Timestamp.now().millisecondsSinceEpoch.toString() +
        '.png');

    await ref.putData(pngBytes);
    final url = await ref.getDownloadURL();

    await FirebaseFirestore.instance.collection('qrData').add({
      'userId': user.uid,
      'userName': userData.data()['name'],
      'createdAt': Timestamp.now(),
      'qrName': _qrCode,
      'qrUrl': url,
    }).then((value) => {
          this.setState(() {
            _url = url;
            loading = false;
          }),
          _qrController.clear(),
          Navigator.pop(context, '$_qrCode')
        });
  }

  Future<bool> saveFile(String url, String fileName) async {
    Directory directory;
    try {
      if (await _requestPermission(Permission.storage)) {
        directory = await getExternalStorageDirectory();
        print(directory.path);
      } else {
        return false;
      }
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      if (await directory.exists()) {
        File saveFile = File(directory.path + '/$fileName');
        await dio.download(url, saveFile.path);
      }
      return true;
    } catch (e) {
      print(e);
    }
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

  downloadQR() async {
    bool downloaded = await saveFile(_url, _qrCode);
    if (downloaded) {
      print('file downloaded');
    } else {
      print('problem downloading file');
    }
  }

  String awe;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generate QR'),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _qrCode == null
                  ? Container(
                      child: Icon(
                        Icons.qr_code,
                        size: 200,
                        color: Colors.teal.shade900,
                      ),
                    )
                  : RepaintBoundary(
                      key: _globalKey,
                      child: BarcodeWidget(
                        height: 200,
                        width: 200,
                        data: _qrCode,
                        barcode: Barcode.qrCode(),
                        color: Colors.black,
                      ),
                    ),
              SizedBox(height: 60),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Container(
                  width: MediaQuery.of(context).size.width - 20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(6.0)),
                  ),
                  padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                  margin: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                  child: TextField(
                    focusNode: _qrFocus,
                    controller: _qrController,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.grey),
                      hintText: 'Type your desired QR Code Name here',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              SizedBox(
                width: MediaQuery.of(context).size.width - 20,
                height: 60,
                child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0)),
                    color: Colors.yellow.shade900,
                    child: Text(
                      'Generate QR Now',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      // Navigator.pop(context);
                      _qrGenerator();
                    }),
              ),
              SizedBox(height: 15),
              if (_qrCode != null)
                Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 20,
                      height: 60,
                      child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0)),
                          color: Colors.green,
                          child: Text(
                            'Save Generated QR Code',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            _saveQrImage();
                          }),
                    ),
                    SizedBox(height: 15),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 20,
                      height: 60,
                      child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0)),
                          color: Colors.green,
                          child: Text(
                            'Save Generated QR Code to Phone',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            downloadQR();
                          }),
                    ),
                  ],
                ),
              (loading)
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Center()
            ],
          ),
        ),
      ),
    );
  }
}
