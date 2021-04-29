import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRCodeScannerPage extends StatefulWidget {
  final String title, successMessage, skipBody, skipText;
  final Future<bool> Function(String text) verifyCallback;
  final VoidCallback quitCallback;
  final VoidCallback skipCallback;
  final bool skippable;
  final Duration solutionDelay;

  QRCodeScannerPage({
    @required this.verifyCallback,
    @required this.quitCallback,
    this.title: 'Scan QR code',
    this.successMessage: 'QR Code scanned successfully',
    this.solutionDelay: const Duration(milliseconds: 1200),
    this.skippable: false,
    this.skipCallback,
    this.skipText,
    this.skipBody,
  }) {
    assert(
      !skippable ||
          (skippable &&
              skipText != null &&
              skipBody != null &&
              skipCallback != null),
    );
  }

  @override
  _QRCodeScannerPageState createState() => _QRCodeScannerPageState();
}

class _QRCodeScannerPageState extends State<QRCodeScannerPage> {
  final GlobalKey qrKey = GlobalKey();
  QRViewController controller;

  bool foundAnything = false;
  Size size;
  double x;
  bool y = true;
  bool showSkipper = false;
  Timer skipDelay;
  Timer frameResizeTimer;

  launchSkipDelay() {
    try {
      skipDelay = Timer(Duration(milliseconds: 800), () {
        setState(() {
          showSkipper = true;
        });
      });
    } catch (e) {
      print(e);
    }
  }

  launchFrameAnimation(BuildContext context) {
    frameResizeTimer = Timer.periodic(Duration(milliseconds: 100), (Timer t) {
      if (mounted) {
        y
            ? x = 8 * MediaQuery.of(context).size.width / 10
            : x = 7 * MediaQuery.of(context).size.width / 10;
        setState(() {
          y = !y;
        });
      } else {
        frameResizeTimer?.cancel();
      }
    });
  }

  void toggleLoading(bool status) async {
    if (status && (frameResizeTimer?.isActive ?? false)) {
      controller.pauseCamera();
      frameResizeTimer?.cancel();
    } else if (!status) {
      controller.resumeCamera();
      size = MediaQuery.of(context).size;
      launchFrameAnimation(context);
      x = 7 * MediaQuery.of(context).size.width / 10;
    }
  }

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      size = MediaQuery.of(context).size;
      launchFrameAnimation(context);
      x = 7 * MediaQuery.of(context).size.width / 10;
    });
    if (widget.skippable) launchSkipDelay();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Center(
              child: Container(
                width: size.width,
                height: size.height,
                color: Colors.white,
                child: foundAnything || !mounted
                    ? Container()
                    : QRView(
                        key: qrKey,
                        onQRViewCreated: (QRViewController controller) {
                          this.controller = controller;
                          controller.scannedDataStream.listen((scanData) {
                            _qrCallback(scanData);
                          });
                        },
                      ),
              ),
            ),
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF222222),
                  borderRadius: BorderRadius.circular(64),
                ),
                width: 42,
                height: 42,
                child: Center(
                  child: GestureDetector(
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 18,
                    ),
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
            ),
            Center(
              child: foundAnything
                  ? Icon(
                      CupertinoIcons.check_mark_circled_solid,
                      color: Color(0xFF222222),
                      size: size.width / 5,
                    )
                  : AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      width: x,
                      child: Image.asset(
                        "assets/images/qr_cadre.png",
                      ),
                    ),
            ),
            Positioned(
              top: 64,
              width: size.width,
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                    color: Color(0xFF222222),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black87,
                        offset: Offset(1, 0),
                        blurRadius: 12,
                      )
                    ]),
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                child: Text(
                  foundAnything ? widget.successMessage : widget.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            !showSkipper
                ? Container()
                : Positioned(
                    bottom: 40,
                    width: size.width,
                    child: Center(
                      child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 16),
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              color: foundAnything
                                  ? Colors.white
                                  : Color(0xFF222222),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black87,
                                  offset: Offset(1, 0),
                                  blurRadius: 12,
                                )
                              ]),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "${widget.title}",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    Text(
                                      "${widget.skipBody}",
                                      style: TextStyle(
                                          fontSize: 13, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.arrow_forward_ios),
                                iconSize: 32,
                                color: Colors.white,
                                onPressed: widget.skipCallback,
                              )
                            ],
                          )),
                    ),
                  )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    frameResizeTimer?.cancel();
    skipDelay?.cancel();
    controller?.dispose();
    super.dispose();
  }

  _qrCallback(Barcode code) async {
    toggleLoading(true);
    print("\n\n\nTEXT: ${code.code + "\n" + code.format.formatName}\n\n\n");
    if (mounted && !foundAnything) {
      bool status = await widget.verifyCallback(code.code);
      if (status) {
        setState(() {
          foundAnything = true;
        });
        await Future.delayed(widget.solutionDelay);
        widget.quitCallback();
      }
    }
    toggleLoading(false);
  }
}
