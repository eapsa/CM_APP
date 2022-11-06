import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oart/feed/feed_repository.dart';
import 'package:oart/session_cubic.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeView extends StatefulWidget {
  const QrCodeView({super.key});

  @override
  State<QrCodeView> createState() => _QrCodeViewState();
}

class _QrCodeViewState extends State<QrCodeView> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  String userId = "";

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    final sessionCubit = context.read<SessionCubit>();
    userId = sessionCubit.currentUser.toString();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add friend"),
      ),
      body: _qrcode(),
    );
  }

  Widget _qrcode() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          QrImage(
            data: userId.toString(),
            version: QrVersions.auto,
            size: 200.0,
          ),
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Text('Friend added')
                  : const Text('Scan a code'),
            ),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        if (result != null) FeedRepository().addFriend(userId, result!.code);
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
