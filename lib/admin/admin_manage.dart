import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mirus_global/admin/edit_product_page.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../Widgets/loadingWidget.dart';
import '../models/item.dart';
import 'package:flutter_mailer/flutter_mailer.dart';



double width;
class AdminManage extends StatefulWidget {
  @override
  _AdminManageState createState() => _AdminManageState();
}

class _AdminManageState extends State<AdminManage> {

  // void _show(BuildContext ctx) {
  //   showModalBottomSheet(
  //       elevation: 10,
  //       backgroundColor: Colors.amber,
  //       context: ctx,
  //       builder: (ctx) => Container(
  //         width: 300,
  //         height: 100,
  //         color: Colors.white54,
  //         alignment: Alignment.center,
  //         child: Text(
  //             'Admin settings will show here...',
  //           style: TextStyle(color: Colors.deepPurple, fontSize: 23.0),),
  //       ));
  // }

  void _sendBulkMails() async {
    final MailOptions mailOptions = MailOptions(
      subject: 'Email subject',
      recipients: ['email1@addy.com', 'email2@addy.com'],
      ccRecipients: ['email13@addy.com', 'email4@addy.com'],
      attachments: ['path/to/image1.png', 'path/to/image2.png']
    );
    await FlutterMailer.send(mailOptions);
  }



  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
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
            'Management',
            style: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
             // fontFamily: 'Dancing Script',
            ),
          ),
          centerTitle: true,
          actions: [
            Stack(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.mail,
                    color: Colors.white,),
                  onPressed: () => _sendBulkMails()
                ),

              ],
            ),
          ],
        ),
       // drawer: MyDrawer(),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.deepOrange,
              title: Text('Update or Delete items'),
              centerTitle: true,
            ),
            // SliverPersistentHeader(
            //   pinned: true,
            //   delegate: SearchBoxDelegate(),
            // ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection("items")
                  .limit(15).orderBy("publishedDate", descending: true).snapshots(),
              builder: (context, snapshot) {
                return !snapshot.hasData ?
                SliverToBoxAdapter(child: Center(child: circularProgress(),))
                    : SliverStaggeredGrid.countBuilder(
                  crossAxisCount: 1,
                  staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                  itemBuilder: (context, index) {
                    ItemModel model = ItemModel.fromJson(snapshot.data.docs[index].data());
                    String snapID = snapshot.data.docs[index].id;
                    return sourceInfo(model, context, snapID);
                  },
                  itemCount: snapshot.data.docs.length,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


Widget sourceInfo(ItemModel model, BuildContext context, String id,
    {Color background, removeCartFunction}) {
 // int timesOrdered = 0; // placeholder value
  return InkWell(
    onTap: () {
      Route route = MaterialPageRoute(builder: (c) => EditProductPage(itemModel: model, docID: id,));
      Navigator.push(context, route);
    },
    splashColor: Colors.grey,
    child: Padding(
      padding: EdgeInsets.all(6.0),
      child: Container(
        height: 190.0,
        width: width,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.network(
                model.thumbnailUrl,
                width: 120.0,
                height: 140.0,
              ),
            ),
            SizedBox(width: 30.0,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 65.0),
                  Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Text(
                            model.title,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                            ),),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5.0,),
                  Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.min, // changed this
                      children: [
                        Expanded(
                          child: Text(
                            'Category: ${model.category}',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 12.0,
                            ),),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5.0,),
                  Row(
                    children: [
                      SizedBox(width: 4.0,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Padding(
                          //   padding: EdgeInsets.only(top: 0.0),
                          //   child: Row(
                          //     children: [
                          //       Text('Ordered $timesOrdered time(s)'),
                          //     ],
                          //   ),
                          // ),
                          Padding(
                            padding: EdgeInsets.only(top: 5.0),
                            child: Row(
                              children: [
                                Text(
                                  'Price: =N= ${model.price}',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.green,
                                  ),),
                              ],
                            ),
                          ),

                        ],
                      ),
                    ],
                  ),
                  Flexible(
                    child: Container(),
                  ),
                  Divider(
                    height: 10.0,
                    color: Colors.pinkAccent,
                    thickness: 0.5,),
                ],
              ),
            ),
          ],
        ),
      ),

    ),
  );


} // source info



Widget card({Color primaryColor = Colors.pinkAccent, String imgPath}) {
  return Container();
}
