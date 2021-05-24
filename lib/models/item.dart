import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemModel {
  String category;
  String title;
  String shortInfo;
  Timestamp publishedDate;
  String thumbnailUrl;
  String longDescription;
  String status;
  int price;
  int discount;
  int qty;
  bool isSpecial;
  String dimensions;
  String colour;

  ItemModel({this.category,
        this.title,
        this.shortInfo,
        this.publishedDate,
        this.thumbnailUrl,
        this.longDescription,
        this.status,
        this.price,
        this.discount,
        this.qty,
        this.isSpecial,
        this.dimensions,
       this.colour,
      });

  ItemModel.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    title = json['title'];
    shortInfo = json['shortInfo'];
    publishedDate = json['publishedDate'];
    thumbnailUrl = json['thumbnailUrl'];
    longDescription = json['longDescription'];
    status = json['status'];
    price = json['price'];
    discount = json['discount'];
    qty = json['quantity'];
    isSpecial = json['special'];
    dimensions = json['dimensions'];
    colour = json['colour'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category'] = this.category;
    data['title'] = this.title;
    data['shortInfo'] = this.shortInfo;
    data['price'] = this.price;
    data['discount'] = this.discount;
    data['quantity'] = this.qty;
    data['special'] = this.isSpecial;
    data['dimensions'] = this.dimensions;
    data['colour'] = this.colour;
    data['thumbnailUrl'] = this.thumbnailUrl;
    data['longDescription'] = this.longDescription;
    data['status'] = this.status;
    if (this.publishedDate != null) {
      data['publishedDate'] = this.publishedDate;
    }
    return data;
  }
}

class PublishedDate {
  String date;

  PublishedDate({this.date});

  PublishedDate.fromJson(Map<String, dynamic> json) {
    date = json['$date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$date'] = this.date;
    return data;
  }
}