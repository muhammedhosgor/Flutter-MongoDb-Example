import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:mongo_db_crud_operation/db_helper/constant.dart';
import 'package:mongo_db_crud_operation/db_helper/mongo_provider.dart';

class MongoDbCrud extends MongoProvider {
  Db? db;
  List searchTextResult = [];

  //* Methods

  @override
  Future<Db> open(
    String collectionName,
  ) async {
    try {
      db = await Db.create(MONGO_CONNECTION_URL);
      await db!.open();
      db!.collection(collectionName);
      debugPrint('MongoDB Connected');
      return db!;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> close() {
    try {
      db!.close();
      debugPrint('MongoDB Closed');
    } catch (e) {
      debugPrint(e.toString());
    }
    return Future.value();
  }

  @override
  Future<void> insertItem(
      String collectionName, Map<String, dynamic> document) async {
    try {
      await open(collectionName);
      await db!.collection(collectionName).insert(document);
      debugPrint('Document Inserted');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> removeItem(ObjectId id, String collectionName) async {
    try {
      await open(collectionName);
      await db!.collection(collectionName).remove(where.id(id));
      debugPrint('Document Removed');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> updateItem(ObjectId id, String collectionName, document) async {
    try {
      await open(collectionName);
      await db!.collection(collectionName).update(where.id(id), document);
      debugPrint('Document Updated');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Future<List> getList(String collectionName) async {
    try {
      await open(collectionName);
      var userList = await db!.collection(collectionName).find().toList();
      debugPrint('Document Fetched');
      return userList;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  @override
  void onSearchTextChanged(String searchText, List<dynamic> collectionList) {
    searchTextResult.clear();
    if (searchText.isEmpty) {
      searchTextResult = [];
    }

    searchTextResult = collectionList
        .where((element) => element['name']
            .toString()
            .toLowerCase()
            .contains(searchText.toLowerCase()))
        .toList();
  }
}
