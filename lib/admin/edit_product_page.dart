//import 'package:mirus_global/widgets/customAppBar.dart';

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mirus_global/Widgets/customAppBar.dart';
import 'package:mirus_global/Widgets/loadingWidget.dart';
import 'package:mirus_global/Widgets/myDrawer.dart';
import 'package:mirus_global/admin/admin_manage.dart';
import 'package:mirus_global/config/config.dart';
import 'package:mirus_global/models/item.dart';
import 'package:flutter/material.dart';
import 'package:mirus_global/store/storehome.dart';


class EditProductPage extends StatefulWidget {

  final ItemModel itemModel;
  final String docID;

  EditProductPage({this.docID, this.itemModel});

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {

  int qtyOfItems = 1;
  File fileImage; // storage place for captured image

  // variables for item uploads
  final _itemCategoryEditingController = TextEditingController();
  final _itemNameEditingController = TextEditingController();
  final _itemDescEditingController = TextEditingController();
  final _itemPriceEditingController = TextEditingController();
  final _itemSizeInfoController = TextEditingController();
  final _itemColourController = TextEditingController();
  final _discountController = TextEditingController();
  final _searchInfoEditingController = TextEditingController();

  String itemId = DateTime.now().millisecondsSinceEpoch.toString();
  bool uploading = false;

  final itemsDoc = FirebaseFirestore.instance.collection("items");


  @override
  void dispose() {
    _itemCategoryEditingController.dispose();
    _itemNameEditingController.dispose();
    _itemDescEditingController.dispose();
    _itemPriceEditingController.dispose();
    _itemSizeInfoController.dispose();
    _itemColourController.dispose();
    _discountController.dispose();
    _searchInfoEditingController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return displayUploadForm();
  }

  // ====================

  Future<void> updateItemInfo(String urlImg) async {
    final itemsRef = FirebaseFirestore.instance.collection("items");
    String id = widget.docID;
    await itemsRef.doc(id).set({
          "category": _itemCategoryEditingController.text.trim(),
          "shortInfo": _searchInfoEditingController.text.trim(),
          "longDescription": _itemDescEditingController.text.trim(),
          "dimensions": _itemSizeInfoController.text.trim(),
          "colour": _itemColourController.text.trim(),
          "price": int.parse(_itemPriceEditingController.text),
          "discount": int.parse(_discountController.text),
          "publishedDate": DateTime.now(),
          "status": "available",
          "thumbnailUrl": urlImg,
          "title": _itemNameEditingController.text.trim(),
    }).then((v) {
      print('Item updated');
        setState(() {
        fileImage = null;
        uploading = false;
        itemId = DateTime.now().millisecondsSinceEpoch.toString();
        _itemCategoryEditingController.clear();
        _itemNameEditingController.clear();
        _itemDescEditingController.clear();
        _itemPriceEditingController.clear();
        _itemColourController.clear();
        _itemSizeInfoController.clear();
        _discountController.clear();
        _searchInfoEditingController.clear();
        });
        Navigator.pop(context);
    }).catchError((e) => print('Failed to update: $e'));
  } // update item info

  deleteItemInfo() {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text(
              'Delete Item?',
              style: TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold
              ),
            ),
            children: [
              SimpleDialogOption(
                child: Text(
                  'Yes, delete forever',
                  style: TextStyle(
                    color: Colors.deepPurple,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  itemsDoc.doc(widget.docID).delete();
                  Fluttertoast.showToast(
                      msg: 'Deleted! Go back to Management.',
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.CENTER);
                },
              ),
              SimpleDialogOption(
                  child: Text(
                    'No, I change my mind',
                    style: TextStyle(
                      color: Colors.deepPurple,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context)
              ),
            ],
          );
        });
  }

  // image update section
  takePhotoWithCamera() async {
    Navigator.pop(context);
    final picker = ImagePicker();
    PickedFile photoFile = await picker
        .getImage(
      source: ImageSource.camera,
      maxHeight: 680.0,
      maxWidth: 970.0,
    );
    setState(() {
      fileImage = File(photoFile.path);
    });
  }

  selectGalleryPhoto() async {
    Navigator.pop(context);
    final picker = ImagePicker();
    PickedFile photoFile = await picker
        .getImage(
      source: ImageSource.gallery,
    );
    setState(() {
      fileImage = File(photoFile.path);
    });
  }

  selectImage(mContext) {
    return showDialog(
        context: mContext,
        builder: (context) {
          return SimpleDialog(
            title: Text(
              'Change or choose same image',
              style: TextStyle(
                  color: Colors.purple,
                  fontWeight: FontWeight.bold
              ),
            ),
            children: [
              SimpleDialogOption(
                child: Text(
                  'Take a photo',
                  style: TextStyle(
                    color: Colors.purple,
                  ),
                ),
                onPressed: () => takePhotoWithCamera(),
              ),
              SimpleDialogOption(
                child: Text(
                  'Select image from gallery',
                  style: TextStyle(
                    color: Colors.purple,
                  ),
                ),
                onPressed: () => selectGalleryPhoto(),
              ),
              SimpleDialogOption(
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.purple,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context)
              ),
            ],
          );
        });
  }
// ================================

  clearFormInfo() {
    fileImage = null;
    _itemNameEditingController.clear();
    _itemDescEditingController.clear();
    _itemPriceEditingController.clear();
    _searchInfoEditingController.clear();
    _itemSizeInfoController.clear();
    _itemColourController.clear();
    _discountController.clear();
    Navigator.pop(context);
  }

  void _mustAddImage(BuildContext ctx) {
    showModalBottomSheet(
        elevation: 10,
        backgroundColor: Colors.amber,
        context: ctx,
        builder: (ctx) => Container(
          padding: EdgeInsets.all(8.0),
          width: 300,
          height: 100,
          color: Colors.white54,
          alignment: Alignment.center,
          child: Text(
            'Ensure you select image and fill fields!',
            style: TextStyle(color: Colors.deepPurple, fontSize: 23.0),),
        ));
  }

  uploadAndSaveItem() async {
    if(fileImage != null) {
      setState(() {
        uploading = true;
      });
      String imageDownloadUrl = await uploadItemImage(fileImage);
      updateItemInfo(imageDownloadUrl);
    } else {
      _mustAddImage(context);
    }
  }

  Future<String> uploadItemImage(mFileImage) async {
    final storageRef = FirebaseStorage.instance.ref().child("Items");
    UploadTask uploadTask = storageRef.child("item_$itemId.jpg").putFile(mFileImage);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  displayUploadForm() {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black12, Colors.blueGrey],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        title: Text(
          'Edit Item',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
          ),
        ),
        actions: [
          TextButton(
            // child: Icon(Icons.add_rounded, color: Colors.pink,),
            child: Text(
              'Update',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),),
            onPressed: uploading ? null : () => uploadAndSaveItem(),
          ),
          TextButton(
            child: Icon(Icons.cancel_rounded, color: Colors.white,),
            onPressed: () => clearFormInfo(),
          ),
        ],
      ),
      body: ListView(
        children: [
          uploading ? linearProgress() : Text(''),
          Padding(padding: EdgeInsets.only(top: 12.0),),
          GestureDetector(
            child: Center(
              child: Image.network(
                widget.itemModel.thumbnailUrl,
                height: 250.0,
                width: 680.0,
              ),
            ),
            onTap: () => selectImage(context),
          ),
           Divider(color: Colors.deepPurple,),
          ListTile(
            leading: Icon(
              Icons.category_outlined,
              color: Colors.pink,),
            title: Container(
              width: 250.0,
                child: TextField(
                  style: TextStyle(color: Colors.deepPurple),
                  controller: _itemCategoryEditingController,
                  decoration: InputDecoration(
                    hintText: widget.itemModel.category,
                    hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                    border: InputBorder.none,
                  ),
                ),

            ),
          ),
          Divider(color: Colors.deepPurple,),
          ListTile(
            leading: Icon(
              Icons.perm_device_information_outlined,
              color: Colors.pink,),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Colors.deepPurple),
                controller: _searchInfoEditingController,
                decoration: InputDecoration(
                  hintText: widget.itemModel.shortInfo,
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    alignment: Alignment.centerLeft,
                    icon: Icon(Icons.copy_outlined),
                    onPressed: () => _copyToClipboard('${widget.itemModel.shortInfo}'),
                  ),
                ),
              ),
            ),
          ),
          Divider(color: Colors.deepPurple,),

          ListTile(
            leading: Icon(
              Icons.title_outlined,
              color: Colors.pink,),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Colors.deepPurple),
                controller: _itemNameEditingController,
                decoration: InputDecoration(
                  hintText: widget.itemModel.title,
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    alignment: Alignment.centerLeft,
                    icon: Icon(Icons.copy_outlined),
                    onPressed: () => _copyToClipboard('${widget.itemModel.title}'),
                  ),
                ),
              ),
            ),
          ),
          Divider(color: Colors.deepPurple,),

          ListTile(
            leading: Icon(
              Icons.info_outline,
              color: Colors.pink,),
            title: Container(
                width: 250.0,
                  child: TextField(
                    style: TextStyle(color: Colors.deepPurple),
                    controller: _itemDescEditingController,
                    decoration: InputDecoration(
                      hintText: widget.itemModel.longDescription,
                      hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        alignment: Alignment.centerLeft,
                        icon: Icon(Icons.copy_outlined),
                        onPressed: () => _copyToClipboard('${widget.itemModel.longDescription}'),
                      ),
                    ),
                  ),

              ),
          ),
          Divider(color: Colors.deepPurple,),
          ListTile(
            leading: Icon(
              Icons.format_size_rounded,
              color: Colors.pink,),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Colors.deepPurple),
                controller: _itemSizeInfoController,
                decoration: InputDecoration(
                  hintText: widget.itemModel.dimensions,
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    alignment: Alignment.centerLeft,
                    icon: Icon(Icons.copy_outlined),
                    onPressed: () => _copyToClipboard('${widget.itemModel.dimensions}'),
                  ),
                ),
              ),

            ),
          ),
           Divider(color: Colors.deepPurple,),
          ListTile(
            leading: Icon(
              Icons.format_paint_rounded,
              color: Colors.pink,),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Colors.deepPurple),
                controller: _itemColourController,
                decoration: InputDecoration(
                  hintText: widget.itemModel.colour,
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    alignment: Alignment.centerLeft,
                    icon: Icon(Icons.copy_outlined),
                    onPressed: () => _copyToClipboard('${widget.itemModel.colour}'),
                  ),
                ),
              ),
            ),
          ),
          Divider(color: Colors.deepPurple,),
          ListTile(
            leading: Icon(
              Icons.money_outlined,
              color: Colors.pink,),
            title: Container(
              width: 250.0,
              child: TextField(
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.deepPurple),
                controller: _itemPriceEditingController,
                decoration: InputDecoration(
                  hintText: widget.itemModel.price.toString(),
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(color: Colors.deepPurple,),
          ListTile(
            leading: Icon(
              Icons.wine_bar_outlined,
              color: Colors.pink,),
            title: Container(
              width: 250.0,
              child: TextField(
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.deepPurple),
                controller: _discountController,
                decoration: InputDecoration(
                  hintText: widget.itemModel.discount.toString(),
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        child: Icon(Icons.delete_forever),
        onPressed: () => deleteItemInfo(),
      ),
    );

  } // display upload form

// ================================

  Future<void> _copyToClipboard(String str) async {
   await Clipboard.setData(ClipboardData(text: str));
   // Fluttertoast.showToast(msg: 'Copied');
  }



} // class

const boldTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
const largeTextStyle = TextStyle(fontWeight: FontWeight.normal, fontSize: 40);