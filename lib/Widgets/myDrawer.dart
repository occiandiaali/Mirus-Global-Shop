import 'package:mirus_global/address/add_address.dart';
import 'package:mirus_global/authentication/auth_screen.dart';
import 'package:mirus_global/config/config.dart';
import 'package:mirus_global/orders/my_orders.dart';
import 'package:mirus_global/orders/order_details.dart';
//import 'package:mirus_global/address/addAddress.dart';
//import 'package:mirus_global/store/Search.dart';
import 'package:mirus_global/store/cart.dart';
import 'package:mirus_global/store/search.dart';
//import 'package:mirus_global/orders/myOrders.dart';
import 'package:mirus_global/store/storehome.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(top: 25.0, bottom: 10.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black12, Colors.blueGrey],
                begin: const FractionalOffset(1.0, 0.0),
                end: const FractionalOffset(0.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
            child: Column(
              children: [
                Material(
                  borderRadius: BorderRadius.all(Radius.circular(80.0)),
                  elevation: 8.0,
                  child: Container(
                    height: 160.0,
                    width: 160.0,
                    child: GestureDetector(
                      child: CircleAvatar(
                        backgroundColor: Colors.deepPurple,
                        radius: 16.0,
                        backgroundImage: NetworkImage(
                          EshopApp.sharedPreferences.getString(EshopApp.userAvatarUrl) ??
                              'https://vc.bridgew.edu/context/hoba/article/1008/type/native/viewcontent',
                      ),

                      ),
                      onTap: () => print('Tapped avatar'),
                    ),
                  ),
                ),
                SizedBox(height: 10.0,),
                Text(
                  EshopApp.sharedPreferences.getString(EshopApp.userName) ??
                      'UserName',
                  style: TextStyle(
                      color: Colors.white,
                  fontSize: 18.0),
                ),
                Text(
                  EshopApp.sharedPreferences.getString(EshopApp.userEmail) ??
                      'user@emailaddress.com',
                  style: TextStyle(color: Colors.white),
                ),
                // Text(
                //     EshopApp.sharedPreferences.getString(EshopApp.userName),
                //   style: TextStyle(
                //     fontSize: 30.0,
                //     color: Colors.white,
                //     fontFamily: 'Ubuntu-Regular',
                //   ),
                // ),
              ],
            ),
          ),
          SizedBox(height: 12.0,),
          Container(
            padding: EdgeInsets.only(top: 1.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black12, Colors.blueGrey],
                begin: const FractionalOffset(1.0, 0.0),
                end: const FractionalOffset(0.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
            child: Column(
              children: [

                ListTile(
                  leading: Icon(Icons.home_outlined, color: Colors.white,),
                  title: Text('Home', style: TextStyle(color: Colors.white),),
                  onTap: () {
                    Route route = MaterialPageRoute(builder: (c) => StoreHome());
                    Navigator.pushReplacement(context, route);
                  },
                ),
                Divider(
                  height: 10.0,
                color: Colors.white,
                thickness: 6.0,),

                ListTile(
                  leading: Icon(Icons.list_outlined, color: Colors.white,),
                  title: Text('Orders', style: TextStyle(color: Colors.white),),
                  onTap: () {
                    Route route = MaterialPageRoute(builder: (c) => MyOrders());
                    Navigator.push(context, route);
                  },
                ),
                Divider(
                  height: 10.0,
                  color: Colors.white,
                  thickness: 6.0,),

                ListTile(
                  leading: Icon(Icons.shopping_cart, color: Colors.white,),
                  title: Text('Cart', style: TextStyle(color: Colors.white),),
                  onTap: () {
                    Route route = MaterialPageRoute(builder: (c) => CartPage());
                    Navigator.push(context, route);
                  },
                ),
                Divider(
                  height: 10.0,
                  color: Colors.white,
                  thickness: 6.0,),

                ListTile(
                  leading: Icon(Icons.add_location_outlined, color: Colors.white,),
                  title: Text('Add address', style: TextStyle(color: Colors.white),),
                  onTap: () {
                    Route route = MaterialPageRoute(builder: (c) => AddAddress());
                    Navigator.push(context, route);
                  },
                ),
                // Divider(
                //   height: 10.0,
                //   color: Colors.white,
                //   thickness: 6.0,),
                //
                // ListTile(
                //   leading: Icon(Icons.settings, color: Colors.white,),
                //   title: Text('Settings', style: TextStyle(color: Colors.white),),
                //   onTap: () {
                //     Route route = MaterialPageRoute(builder: (c) => null);
                //     Navigator.push(context, route);
                //   },
                // ),
                Divider(
                  height: 30.0,
                  color: Colors.white,
                  thickness: 18.0,),

                ListTile(
                  leading: Icon(Icons.logout, color: Colors.white,),
                  title: Text('Logout', style: TextStyle(color: Colors.white),),
                  onTap: () {
                    EshopApp.auth.signOut().then((c) {
                       //Route route = MaterialPageRoute(builder: (c) => AuthScreen());
                       Navigator.of(context).pushAndRemoveUntil(
                          // context,
                           MaterialPageRoute(builder: (c) => AuthScreen()),
                              (route) => false,
                       );
                      // Navigator.pushReplacement(context, route);
                    });
                  },
                ),
                Divider(
                  height: 10.0,
                  color: Colors.white,
                  thickness: 6.0,),
              ],
            ),
          ),
        ],
      ),
    );
  } // build Widget

  // image update section
  // takePhotoWithCamera() async {
  //   Navigator.pop(context);
  //   final picker = ImagePicker();
  //   PickedFile photoFile = await picker
  //       .getImage(
  //     source: ImageSource.camera,
  //     maxHeight: 680.0,
  //     maxWidth: 970.0,
  //   );
  //   setState(() {
  //     fileImage = File(photoFile.path);
  //   });
  // }
  //
  // selectGalleryPhoto() async {
  //   Navigator.pop(context);
  //   final picker = ImagePicker();
  //   PickedFile photoFile = await picker
  //       .getImage(
  //     source: ImageSource.gallery,
  //   );
  //   setState(() {
  //     fileImage = File(photoFile.path);
  //   });
  // }
  //
  // selectImage(mContext) {
  //   return showDialog(
  //       context: mContext,
  //       builder: (context) {
  //         return SimpleDialog(
  //           children: [
  //             SimpleDialogOption(
  //               child: Text(
  //                 'Take a photo',
  //                 style: TextStyle(
  //                   color: Colors.purple,
  //                 ),
  //               ),
  //               onPressed: () => takePhotoWithCamera(),
  //             ),
  //             SimpleDialogOption(
  //               child: Text(
  //                 'Select image from gallery',
  //                 style: TextStyle(
  //                   color: Colors.purple,
  //                 ),
  //               ),
  //               onPressed: () => selectGalleryPhoto(),
  //             ),
  //             SimpleDialogOption(
  //                 child: Text(
  //                   'Cancel',
  //                   style: TextStyle(
  //                     color: Colors.purple,
  //                   ),
  //                 ),
  //                 onPressed: () => Navigator.pop(context)
  //             ),
  //           ],
  //         );
  //       });
  // }





} // class