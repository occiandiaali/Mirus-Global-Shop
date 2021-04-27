import 'package:mirus_global/Widgets/loadingWidget.dart';
import 'package:mirus_global/admin/admin_order_card.dart';
import 'package:mirus_global/config/config.dart';
import 'package:mirus_global/store/cart.dart';
import 'package:mirus_global/counters/cartitemcounter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class MyAppBar extends StatelessWidget with PreferredSizeWidget
{
  final PreferredSizeWidget bottom;
  MyAppBar({this.bottom});


  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.deepPurple,
              Colors.blueGrey,
              Colors.orangeAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.4, 0.6, 1],
            tileMode: TileMode.clamp,
          ),
        ),
      ),
      centerTitle: true,
      title: Text(
        'MG Shop',
        style: TextStyle(
          fontSize: 35.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontFamily: 'Dancing Script',
        ),
      ),
      bottom: bottom,
      actions: [
        Stack(
          children: [
            IconButton(
              icon: Icon(Icons.shopping_cart_outlined, color: Colors.white,),
              // onPressed: () {
              //   Route route = MaterialPageRoute(builder: (c) => CartPage());
              //   Navigator.push(context, route);
              // },
            ),
            Positioned(
              child: Stack(
                children: [
                  Icon(
                    Icons.brightness_1,
                    size: 20.0,
                    color: Colors.deepPurple,
                  ),
                  Positioned(
                    top: 3.0,
                    bottom: 3.0,
                    left: 6.5,
                   // child: Icon(Icons.star_half),
                    child: Text(
                      (EshopApp.sharedPreferences
                          .getStringList(EshopApp.userCartList)
                          .length - 1).toString(),
                      style: TextStyle(color: Colors.white, fontSize: 12.0),),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }


  Size get preferredSize => bottom == null ? Size(56,AppBar().preferredSize.height) : Size(56, 80+AppBar().preferredSize.height);
}