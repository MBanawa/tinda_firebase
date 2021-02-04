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
  final dataKey = GlobalKey();

  _qrGenerator() async {
    Scrollable.ensureVisible(dataKey.currentContext);
    this.setState(() {
      loading = true;
    });
    FocusScope.of(context).unfocus();
    await Future.delayed(Duration(milliseconds: 1500), () {
      setState(() {
        _qrCode = _qrController.text.trim();
        loading = false;
      });
    });
  }

  Future<void> _saveQrImage() async {
    _requestPermission(Permission.storage);
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
          downloadQR(),
          _qrController.clear(),
          Navigator.pop(context, '$_qrCode')
        });
  }

  Future<bool> saveFile(String url, String fileName) async {
    Directory directory;
    print('URL: $url');
    try {
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
        File saveFile = File(directory.path + '/QR_Codes/$fileName.png');
        await dio.download(url, saveFile.path);
      }
      return true;
    } catch (e) {
      print(e);
    }
    return false;
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
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              (loading)
                  ? Container(
                      alignment: Alignment.center,
                      child: LinearProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.teal[600]),
                        backgroundColor: Colors.teal[100],
                      ),
                    )
                  : Center(),
              SizedBox(
                key: dataKey,
                height: 80,
              ),
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
                    //TODO: ADD RESET FUNCTION
                    child: Text(
                      _qrCode == null ? 'Generate QR Now' : 'Reset',
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
                            'Save and go back',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            _saveQrImage();
                          }),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
