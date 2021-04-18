//import 'package:mirus_global/widgets/customAppBar.dart';

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mirus_global/Widgets/customAppBar.dart';
import 'package:mirus_global/Widgets/loadingWidget.dart';
import 'package:mirus_global/Widgets/myDrawer.dart';
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
  File imageFile; // storage place for captured image

  // variables for item uploads
  final _itemNameEditingController = TextEditingController();
  final _itemDescEditingController = TextEditingController();
  final _itemPriceEditingController = TextEditingController();
  final _searchInfoEditingController = TextEditingController();
  String itemId = DateTime.now().millisecondsSinceEpoch.toString();
  bool uploading = false;

  final itemsDoc = FirebaseFirestore.instance.collection("items");


  @override
  void dispose() {
    _itemNameEditingController.dispose();
    _itemDescEditingController.dispose();
    _itemPriceEditingController.dispose();
    _searchInfoEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return imageFile == null ? displayEditScreen() : displayUploadForm();
  }

  displayEditScreen() {
   // Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text('Update Item'),
        ),
        //  drawer: MyDrawer(),
        body: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(8.0),
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Center(
                        child: Image.network(
                          widget.itemModel.thumbnailUrl,
                        ),
                      ),
                      Positioned(
                        bottom: 15,
                        right: 15,
                        child: GestureDetector(
                          onTap: () => print('Change image?'),
                          child: Icon(
                            Icons.edit_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.grey[300],
                        child: SizedBox(
                          height: 1.0,
                          width: double.infinity,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(20.0),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.itemModel.title,
                                style: boldTextStyle,
                              ),
                              // Icon(Icons.edit_outlined),
                            ],
                          ),

                          SizedBox(height: 10.0,),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.itemModel.status,
                              ),
                              // Icon(Icons.edit_outlined),
                            ],
                          ),
                          SizedBox(height: 10.0,),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.itemModel.shortInfo,
                              ),
                              // Icon(Icons.edit_outlined),
                            ],
                          ),
                          SizedBox(height: 10.0,),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.itemModel.longDescription,
                              ),
                              // Icon(Icons.edit_outlined),
                            ],
                          ),
                          SizedBox(height: 10.0,),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "=N= " + widget.itemModel.price.toString(),
                                style: boldTextStyle,
                              ),
                              // Icon(Icons.edit_outlined),
                            ],
                          ),
                          SizedBox(height: 10.0,),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Center(
                      child: Column(
                        children: [
                          ElevatedButton(
                            onPressed: () => selectImage(context),
                            child: Text('Update Item'),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                              onPrimary: Colors.white,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => deleteItemInfo(),
                            child: Text('Delete Item'),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                              onPrimary: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: EdgeInsets.only(top: 8.0),
                  //   child: Center(
                  //     child: InkWell(
                  //       onTap: () => selectImage(context),
                  //       // onTap: () => checkItemInCart(widget.itemModel.shortInfo, context),
                  //       child: Container(
                  //         decoration: BoxDecoration(
                  //           color: Colors.purple,
                  //           // gradient: LinearGradient(
                  //           //   colors: [Colors.pink, Colors.blueGrey],
                  //           //   begin: const FractionalOffset(0.0, 0.0),
                  //           //   end: const FractionalOffset(1.0, 0.0),
                  //           //   stops: [0.0, 1.0],
                  //           //   tileMode: TileMode.clamp,
                  //           // ),
                  //         ),
                  //         width: MediaQuery.of(context).size.width - 40.0,
                  //         height: 50.0,
                  //         child: Center(
                  //           child: Text(
                  //             'Update',
                  //             style: TextStyle(
                  //                 color: Colors.white,
                  //                 fontWeight: FontWeight.bold,
                  //                 fontSize: 20.0),),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      );
  } // Edit screen

  // ====================

  Future<void> updateItemInfo(String urlImg) async {
    // String docID = "1617884091033";
    final itemsRef = FirebaseFirestore.instance.collection("items");
    String id = widget.docID;
    await itemsRef.doc(id).set({
          "shortInfo": _searchInfoEditingController.text.trim(),
          "longDescription": _itemDescEditingController.text.trim(),
          "price": int.parse(_itemPriceEditingController.text),
          "publishedDate": DateTime.now(),
          "status": "available",
          "thumbnailUrl": urlImg,
          "title": _itemNameEditingController.text.trim()
    }).then((v) {
      print('Item updated');
        setState(() {
        imageFile = null;
        uploading = false;
        itemId = DateTime.now().millisecondsSinceEpoch.toString();
        _itemNameEditingController.clear();
        _itemDescEditingController.clear();
        _itemPriceEditingController.clear();
        _searchInfoEditingController.clear();
        });
        Navigator.pop(context);
    }).catchError((e) => print('Failed to update: $e'));
  } // update item info

  // Future<void> saveItemInfo(String urlImg) {
  //   return FirebaseFirestore.instance.collection("items")
  //       .doc()
  //       .set({
  //     "shortInfo": _searchInfoEditingController.text.trim(),
  //     "longDescription": _itemDescEditingController.text.trim(),
  //     "price": int.parse(_itemPriceEditingController.text),
  //     "publishedDate": DateTime.now(),
  //     "status": "available",
  //     "thumbnailUrl": urlImg,
  //     "title": _itemNameEditingController.text.trim()
  //   }).then((value) {
  //   print('Item updated');
  //   setState(() {
  //   imageFile = null;
  //   uploading = false;
  //   itemId = DateTime.now().millisecondsSinceEpoch.toString();
  //   _itemNameEditingController.clear();
  //   _itemDescEditingController.clear();
  //   _itemPriceEditingController.clear();
  //   _searchInfoEditingController.clear();
  //   });
  //   }).catchError((e) => print('Failed to update: $e'));
  // } // save item info


  deleteItemInfo() {
    itemsDoc
        .doc(widget.docID).delete();
    Navigator.pop(context);
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
      imageFile = File(photoFile.path);
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
      imageFile = File(photoFile.path);
    });
  }


  selectImage(mContext) {
    return showDialog(
        context: mContext,
        builder: (context) {
          return SimpleDialog(
            title: Text(
              'Start by updating the item image',
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
    imageFile = null;
    _itemNameEditingController.clear();
    _itemDescEditingController.clear();
    _itemPriceEditingController.clear();
    Navigator.pop(context);
  }

  uploadAndSaveItem() async {
    setState(() {
      uploading = true;
    });
    String imageDownloadUrl = await uploadItemImage(imageFile);
    String label = itemId;

    updateItemInfo(imageDownloadUrl);
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
              'Upload',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),),
            onPressed: uploading ? null : () => uploadAndSaveItem(),
           // onPressed: () => uploadAndSaveItem(),
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
          Container(
            height: 230.0,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16/9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(imageFile),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 12.0),),
          // ListTile(
          //   leading: Icon(
          //     Icons.image_outlined,
          //     color: Colors.pink,),
          //   title: Container(
          //     width: 150.0,
          //     child: TextButton(
          //       child: Text('Select image'),
          //       onPressed: () => selectGalleryPhoto(),
          //     ),
          //   ),
          // ),
          // Divider(color: Colors.deepPurple,),
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
                  hintText: 'Tag e.g. "Phone", or "Shoes"',
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
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
                  hintText: 'Item name',
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
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
                  hintText: 'Item description',
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
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
                  hintText: 'Item price',
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(color: Colors.deepPurple,),
        ],
      ),
    );

  } // display upload form

// ================================

} // class

const boldTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
const largeTextStyle = TextStyle(fontWeight: FontWeight.normal, fontSize: 20);