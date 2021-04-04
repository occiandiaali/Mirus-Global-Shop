import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:mirus_global/admin/adminShiftOrders.dart';
import 'package:mirus_global/widgets/loadingWidget.dart';
import 'package:mirus_global/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as ImD;


class UploadPage extends StatefulWidget
{
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> with AutomaticKeepAliveClientMixin<UploadPage>
{
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Admin Screen',
          style: TextStyle(fontSize: 25.0),
        ),
      ),
    );
  }
}