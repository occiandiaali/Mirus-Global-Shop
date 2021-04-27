import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mirus_global/Widgets/customAppBar.dart';
import 'package:mirus_global/models/item.dart';

import './storehome.dart';


//import '../widgets/customAppBar.dart';

class SearchProduct extends StatefulWidget {
  @override
  _SearchProductState createState() => new _SearchProductState();
}


class _SearchProductState extends State<SearchProduct> {

  Future<QuerySnapshot> docList;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(
          bottom: PreferredSize(
            child: searchWidget(),
            preferredSize: Size(56.0, 56.0),
          ),
        ),
        body: FutureBuilder<QuerySnapshot>(
          future: docList,
          builder: (context, snap) {
            return snap.hasData ?
                ListView.builder(
                  itemCount: snap.data.docs.length,
                  itemBuilder: (context, index) {
                    ItemModel model = ItemModel.fromJson(snap.data.docs[index].data());

                //    return sourceInfo(model, context);
                    return sourceInfo(model, context);
                  },
                )
                : Center(
                child: Text(
                    "Nothing found...",
                style: TextStyle(
                  fontSize: 26.0,
                  color: Colors.grey,
                ),));
          },
        ),
      ),
    );
  }
  Widget searchWidget() {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      height: 80.0,
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
      child: Container(
        width: MediaQuery.of(context).size.width - 40.0,
        height: 50.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Icon(
                Icons.search_rounded,
              color: Colors.blueGrey,),
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: TextField(
                  onChanged: (value) {
                    startSearch(value);
                  },
                  decoration: InputDecoration.collapsed(
                      hintText: 'Search for...'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future startSearch(String query) async {
    docList = FirebaseFirestore.instance.collection("items")
        .where("category", isGreaterThanOrEqualTo: query)
        .get();
  }

} // class
