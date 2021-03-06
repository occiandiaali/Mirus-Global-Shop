import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mirus_global/admin/admin_manage.dart';
import 'package:mirus_global/authentication/auth_screen.dart';
//import 'package:mirus_global/admin/adminShiftOrders.dart';
import 'package:mirus_global/Widgets/loadingWidget.dart';
import 'package:mirus_global/config/config.dart';
import 'package:mirus_global/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as ImD;

import 'admin_shift_orders.dart';

class UploadPage extends StatefulWidget {

  final String adminUser;

  UploadPage(this.adminUser, {Key key}) : super(key: key);

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage>
    with AutomaticKeepAliveClientMixin<UploadPage> {

  bool get wantKeepAlive => true;

  File imageFile; // storage place for captured image


  // variables for item uploads
  final _itemCategoryEditingController = TextEditingController();
  final _itemNameEditingController = TextEditingController();
  final _itemDescEditingController = TextEditingController();
  final _itemPriceEditingController = TextEditingController();
  final _searchInfoEditingController = TextEditingController();
  final _itemSizeInfoController = TextEditingController();
  final _itemColourController = TextEditingController();
  final _discountController = TextEditingController();

  String itemId = DateTime.now().millisecondsSinceEpoch.toString();
  bool uploading = false;
  int itemVariance = 0; // track individual items for search purpose

  @override
  void dispose() {
    _itemCategoryEditingController.dispose();
    _itemNameEditingController.dispose();
    _itemDescEditingController.dispose();
    _itemPriceEditingController.dispose();
    _searchInfoEditingController.dispose();
    _itemSizeInfoController.dispose();
    _itemColourController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   // return imageFile == null ? displayAdminScreen() : displayUploadForm();
    return WillPopScope(
        child: imageFile == null ? displayAdminScreen() : displayUploadForm(),
        onWillPop: () async {
          Fluttertoast.showToast(
              msg: 'Sign out for safety...',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER
          );
          return false;
        });

  }

  displayAdminScreen() {
    // Regex section for extracting xters
    // before '@' in user email
    // useful in welcome message on login
    var exp = RegExp(r"^.*?(?=@)");
    String re = exp.stringMatch(widget.adminUser);
    String user = re[0].toUpperCase() + re.substring(1);
    // =========================
    return Scaffold (
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
          actions: [
            IconButton(
              icon: Icon(
               // Icons.border_color,
                Icons.list_alt_outlined,
                color: Colors.white,
              ),
              onPressed: () {
                Route route =
                MaterialPageRoute(builder: (c) => AdminShiftOrders());
                Navigator.push(context, route);
              },
            ),
            SizedBox(width: 30.0,),
            IconButton(
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ),
              onPressed: () {
                EshopApp.auth.signOut().then((c) {
                  Navigator.of(context).pushAndRemoveUntil(
                    // context,
                    MaterialPageRoute(builder: (c) => AuthScreen()),
                        (route) => false,
                  );
                  // Navigator.pushReplacement(context, route);
                });
              },
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black12, Colors.blueGrey],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
          child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/adminlogo.png',
                    height: 100.0,
                    width: 100.0,
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    // 'Welcome, ${widget.adminUser}',
                    'Welcome, $user',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                    ),
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  Icon(
                    Icons.shop_two_outlined,
                    color: Colors.purple,
                    size: 170.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 17.0),
                    child: ElevatedButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9.0),
                        ),
                      ),
                      child: Text(
                        'Upload Items',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () => selectImage(context),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: ElevatedButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9.0),
                        ),
                      ),
                      child: Text(
                        'Management',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        Route route = MaterialPageRoute(builder: (c) => AdminManage());
                        Navigator.push(context, route);
                      },
                    ),
                  ),
                ],
              ),
          ),
        )
    );
  } // admin screen

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
          'New Item',
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
          ),
          TextButton(
            child: Icon(Icons.cancel_rounded, color: Colors.white,),
            onPressed: () {
              clearFormInfo();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          uploading ? linearProgress() : Text(''),
          Container(
            height: 230.0,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Stack(
              children: [
                Center(
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
                Positioned(
                  bottom: 15,
                  right: 15,
                  child: GestureDetector(
                    onTap: () => selectImage(context),
                    child: Icon(
                      Icons.edit_outlined,
                      color: Colors.deepOrange,
                      size: 40,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 12.0),),
          ListTile(
            leading: Icon(
              Icons.category_outlined,
              color: Colors.deepPurple,),
            title: Container(
              width: 250.0,
              child: TextField(
                maxLength: 12,
                textCapitalization: TextCapitalization.none,
                style: TextStyle(color: Colors.deepPurple),
                controller: _itemCategoryEditingController,
                decoration: InputDecoration(
                  hintText: 'Category (shirt, shoe, dress, bag...)',
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
            color: Colors.deepPurple,),
            title: Container(
              width: 250.0,
              child: TextField(
                maxLength: 20,
                maxLengthEnforcement: MaxLengthEnforcement.truncateAfterCompositionEnds,
                style: TextStyle(color: Colors.deepPurple),
                controller: _searchInfoEditingController,
                decoration: InputDecoration(
                  hintText: 'Short Info',
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
              color: Colors.deepPurple,),
            title: Container(
              width: 250.0,
              child: TextField(
                maxLength: 16,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
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
              color: Colors.deepPurple,),
            title: Container(
              width: 250.0,
              child: TextField(
                maxLines: 3,
                style: TextStyle(color: Colors.deepPurple),
                controller: _itemDescEditingController,
                decoration: InputDecoration(
                  hintText: 'Item details',
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(color: Colors.deepPurple,),
          ListTile(
              leading: Icon(
                Icons.format_size_rounded,
                color: Colors.deepPurple,),
              title: Container(
                width: 250.0,
                child: TextField(
                  style: TextStyle(color: Colors.deepPurple),
                  controller: _itemSizeInfoController,
                  decoration: InputDecoration(
                    hintText: 'small, medium, 12, 8...',
                    hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Divider(color: Colors.deepPurple,),
          ListTile(
            leading: Icon(
              Icons.format_paint_rounded,
              color: Colors.deepPurple,),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Colors.deepPurple),
                controller: _itemColourController,
                decoration: InputDecoration(
                  hintText: 'blue, black, green...',
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
              color: Colors.deepPurple,),
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
          ListTile(
            leading: Icon(
              Icons.wine_bar_outlined,
              color: Colors.deepPurple,),
            title: Container(
              width: 250.0,
              child: TextField(
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.deepPurple),
                controller: _discountController,
                decoration: InputDecoration(
                  hintText: 'Discount %',
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

  clearFormInfo() {
    imageFile = null;
    _itemCategoryEditingController.clear();
    _searchInfoEditingController.clear();
    _itemNameEditingController.clear();
    _itemDescEditingController.clear();
    _itemPriceEditingController.clear();
    _itemSizeInfoController.clear();
    _itemColourController.clear();
    _discountController.clear();
  }

  uploadAndSaveItem() async {
    setState(() {
      uploading = true;
    });
    String imageDownloadUrl = await uploadItemImage(imageFile);

    saveItemInfo(imageDownloadUrl);
  }

  Future<String> uploadItemImage(mFileImage) async {
    final storageRef = FirebaseStorage.instance.ref().child("Items");
    UploadTask uploadTask = storageRef.child("item_$itemId.jpg").putFile(mFileImage);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  saveItemInfo(String imgUrl) {
    final itemsRef = FirebaseFirestore.instance.collection("items");
    itemsRef.doc(itemId).set({
      "category": _itemCategoryEditingController.text.trim(),
      "shortInfo": _searchInfoEditingController.text.trim(),
      "longDescription": _itemDescEditingController.text.trim(),
      "dimensions": _itemSizeInfoController.text.trim(),
      "colour": _itemColourController.text.trim(),
      "price": int.parse(_itemPriceEditingController.text),
      "discount": int.parse(_discountController.text),
      "publishedDate": DateTime.now(),
      "status": "available",
      "thumbnailUrl": imgUrl,
      "title": _itemNameEditingController.text.trim()
    }).then((v) {
      setState(() {
        imageFile = null;
        uploading = false;
        itemId = DateTime.now().millisecondsSinceEpoch.toString();
        _itemCategoryEditingController.clear();
        _itemNameEditingController.clear();
        _itemDescEditingController.clear();
        _itemPriceEditingController.clear();
        _itemSizeInfoController.clear();
        _itemColourController.clear();
        _discountController.clear();
        _searchInfoEditingController.clear();
      });
    }).catchError((e) => print("Error: $e"));

  } // save item info

  takePhotoWithCamera() async {
    Navigator.pop(context);
    final picker = ImagePicker();
    PickedFile photoFile = await picker
        .getImage(
        source: ImageSource.camera,
    imageQuality: 85,
    maxHeight: 370.0,
    maxWidth: 570.0,
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
      imageQuality: 85,
      maxHeight: 370.0,
      maxWidth: 570.0,
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
              'Choose an image of the item',
              style: TextStyle(
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold
              ),
            ),
            children: [
              SimpleDialogOption(
                child: Text(
                    'Take a photo',
                  style: TextStyle(
                      color: Colors.deepPurple,
                  ),
                ),
                onPressed: () => takePhotoWithCamera(),
              ),
              SimpleDialogOption(
                child: Text(
                  'Select from gallery',
                  style: TextStyle(
                    color: Colors.deepPurple,
                  ),
                ),
                onPressed: () => selectGalleryPhoto(),
              ),
              SimpleDialogOption(
                child: Text(
                  'Cancel',
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

} // class
