//import 'package:mirus_global/widgets/customAppBar.dart';

import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:mirus_global/Widgets/customAppBar.dart';
import 'package:mirus_global/Widgets/myDrawer.dart';
import 'package:mirus_global/models/item.dart';
import 'package:flutter/material.dart';
import 'package:mirus_global/store/storehome.dart';


class EditProductPage extends StatefulWidget {

  final ItemModel itemModel;

  EditProductPage({this.itemModel});

  @override
  _EditProductPageState createState() => _EditProductPageState();
}



class _EditProductPageState extends State<EditProductPage> {

  int qtyOfItems = 1;
  File imageFile; // storage place for captured image

  @override
  Widget build(BuildContext context) {

    Size screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Edit Item'),
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
                          onTap: () => selectImage(context),
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
                          //  crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.itemModel.title,
                                style: boldTextStyle,
                              ),
                              Icon(Icons.edit_outlined),
                            ],
                          ),

                          SizedBox(height: 10.0,),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                           // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.itemModel.longDescription,
                              ),
                              Icon(Icons.edit_outlined),
                            ],
                          ),
                          SizedBox(height: 10.0,),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                           // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "=N= " + widget.itemModel.price.toString(),
                                style: boldTextStyle,
                              ),
                              Icon(Icons.edit_outlined),
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
                      child: InkWell(
                        onTap: () => checkItemInCart(widget.itemModel.shortInfo, context),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.green,
                            // gradient: LinearGradient(
                            //   colors: [Colors.pink, Colors.blueGrey],
                            //   begin: const FractionalOffset(0.0, 0.0),
                            //   end: const FractionalOffset(1.0, 0.0),
                            //   stops: [0.0, 1.0],
                            //   tileMode: TileMode.clamp,
                            // ),
                          ),
                          width: MediaQuery.of(context).size.width - 40.0,
                          height: 50.0,
                          child: Center(
                            child: Text(
                              'Update',
                              style: TextStyle(
                                  color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0),),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
              'What do you want to do?',
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
                  'Select from gallery',
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

} // class

const boldTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
const largeTextStyle = TextStyle(fontWeight: FontWeight.normal, fontSize: 20);