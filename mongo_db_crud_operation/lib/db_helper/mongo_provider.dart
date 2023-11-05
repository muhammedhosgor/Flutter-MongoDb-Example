import 'package:mongo_dart/mongo_dart.dart';

abstract class MongoProvider<T> {
  Future<Db> open(
    String collectionName,
  );
  Future<void> close();
  Future<void> insertItem(String collectionName, Map<String, dynamic> document);
  Future<void> removeItem(ObjectId id, String collectionName);
  Future<void> updateItem(ObjectId id, String collectionName, T document);
  Future<List<T?>> getList(String collectionName);

  void onSearchTextChanged(String searchText, List<dynamic> collectionList);
}
