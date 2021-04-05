import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mirus_global/authentication/auth_screen.dart';
//import 'package:mirus_global/admin/adminShiftOrders.dart';
import 'package:mirus_global/widgets/loadingWidget.dart';
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

  @override
  Widget build(BuildContext context) {
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
          actions: [
            IconButton(
              icon: Icon(
                Icons.border_color,
                color: Colors.white,
              ),
              onPressed: () {
                Route route =
                    MaterialPageRoute(builder: (c) => AdminShiftOrders());
                Navigator.pushReplacement(context, route);
              },
            ),
            // TextButton(
            //   child: Text(
            //     'Logout',
            //     style: TextStyle(
            //         color: Colors.white,
            //         fontSize: 16.0,
            //         fontWeight: FontWeight.bold),
            //   ),
            //   onPressed: () {
            //     Route route = MaterialPageRoute(builder: (c) => SplashScreen());
            //     Navigator.pushReplacement(context, route);
            //   },
            // ),
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
                  'images/mglogo.png',
                  height: 150.0,
                  width: 150.0,
                ),
                SizedBox(
                  height: 21.0,
                ),
                Text(
                  'Welcome, ${widget.adminUser}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28.0,
                  ),
                ),
                Text(
                  '(back arrow logs you out)',
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),
                SizedBox(
                  height: 41.0,
                ),
                Icon(
                  Icons.shop_two_outlined,
                  color: Colors.pink,
                  size: 200.0,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
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
                    onPressed: () => print('Upload button clicked'),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  // displayAdminHome() {
  //   return Scaffold(
  //     appBar: AppBar(
  //       flexibleSpace: Container(
  //         decoration: BoxDecoration(
  //           gradient: LinearGradient(
  //             colors: [Colors.black12, Colors.blueGrey],
  //             begin: const FractionalOffset(0.0, 0.0),
  //             end: const FractionalOffset(1.0, 0.0),
  //             stops: [0.0, 1.0],
  //             tileMode: TileMode.clamp,
  //           ),
  //         ),
  //       ),
  //       actions: [
  //         IconButton(
  //           icon: Icon(Icons.border_color, color: Colors.white,),
  //           onPressed: () {
  //             Route route = MaterialPageRoute(builder: (c) => AdminShiftOrders());
  //             Navigator.pushReplacement(context, route);
  //           },
  //         ),
  //         TextButton(
  //           child: Text(
  //               'Logout',
  //           style: TextStyle(
  //             color: Colors.white,
  //             fontSize: 16.0,
  //             fontWeight: FontWeight.bold
  //           ),),
  //           onPressed: () {
  //             Route route = MaterialPageRoute(builder: (c) => AuthScreen());
  //             Navigator.pushReplacement(context, route);
  //           },
  //         ),
  //       ],
  //     ),
  //     body: getAdminHomeBody(),
  //   );
  // }

  // getAdminHomeBody() {
  //   return Container(
  //     decoration: BoxDecoration(
  //       gradient: LinearGradient(
  //         colors: [Colors.black12, Colors.blueGrey],
  //         begin: const FractionalOffset(0.0, 0.0),
  //         end: const FractionalOffset(1.0, 0.0),
  //         stops: [0.0, 1.0],
  //         tileMode: TileMode.clamp,
  //       ),
  //     ),
  //     child: Center(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Text(
  //               'Welcome, ',
  //           style: TextStyle(
  //             color: Colors.white,
  //             fontSize: 28.0,
  //           ),),
  //           SizedBox(height: 51.0,),
  //           Icon(
  //             Icons.shop_two_outlined,
  //             color: Colors.pink,
  //             size: 200.0,),
  //           Padding(
  //             padding: EdgeInsets.only(top: 20.0),
  //             child: ElevatedButton(
  //               style: TextButton.styleFrom(
  //                 backgroundColor: Colors.green,
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(9.0),
  //                 ),
  //               ),
  //               child: Text(
  //                   'Upload Items',
  //               style: TextStyle(
  //                 fontSize: 20.0,
  //                 color: Colors.white,
  //               ),),
  //               onPressed: () => print('Upload button clicked'),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

} // class
