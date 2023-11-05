import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mongo_db_crud_operation/db_helper/mongo_crud.dart';
import 'package:mongo_db_crud_operation/view/model/user_model.dart';
import 'package:mongo_db_crud_operation/view/widget/custom_search_textfield_widget.dart';
import 'package:mongo_db_crud_operation/view/widget/custom_textfield_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController ageTextEditingController = TextEditingController();
  MongoDbCrud mongoDbCrud = MongoDbCrud();
  List<dynamic>? userList;

  @override
  void initState() {
    fetchData();
    super.initState();
  }

//* Fetching Data from MongoDB
  Future<void> fetchData() async {
    userList = await mongoDbCrud.getList('users');
    jsonEncode(userList);
    debugPrint(userList.toString());

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MongoDB CRUD Operation'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //* Inserting Data to MongoDB
          await mongoDbCrud.insertItem(
              'users',
              UserModel(
                      name: nameTextEditingController.text.toString(),
                      age: int.parse(ageTextEditingController.text),
                      email: emailTextEditingController.text.toString())
                  .toJson());
          userList = await mongoDbCrud.getList('users');
          setState(() {});
          //* Clearing TextFields
          nameTextEditingController.clear();
          emailTextEditingController.clear();
          ageTextEditingController.clear();
        },
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          const SizedBox(height: 20),
          //* TextFields Name
          CustomTextfieldWidget(
              controllerField: nameTextEditingController, hintText: 'Name'),
          const SizedBox(height: 10),
          //* TextFields Email
          CustomTextfieldWidget(
              controllerField: emailTextEditingController, hintText: 'Email'),
          const SizedBox(height: 10),
          //* TextFields Age
          CustomTextfieldWidget(
              controllerField: ageTextEditingController, hintText: 'Age'),
          const SizedBox(height: 10),

          //* Search TextField
          CustomSearchTextfieldWidget(
              onChanged: (p0) {
                setState(() {
                  mongoDbCrud.onSearchTextChanged(p0, userList ?? <dynamic>[]);
                });
              },
              hintText: 'Search'),

          //* Search Result
          mongoDbCrud.searchTextResult.isNotEmpty
              ? ListView.builder(
                  controller: ScrollController(),
                  shrinkWrap: true,
                  itemCount: mongoDbCrud.searchTextResult.length,
                  itemBuilder: (context, index) {
                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: ListTile(
                        leading: const Icon(Icons.person),
                        title:
                            Text(mongoDbCrud.searchTextResult[index]['name']),
                        subtitle: RichText(
                          text: TextSpan(
                              text: mongoDbCrud.searchTextResult[index]
                                  ['email'],
                              style: const TextStyle(color: Colors.black),
                              children: [
                                const TextSpan(
                                    text: ' - ',
                                    style: TextStyle(color: Colors.black)),
                                TextSpan(
                                    text: mongoDbCrud.searchTextResult[index]
                                            ['age']
                                        .toString(),
                                    style:
                                        const TextStyle(color: Colors.black)),
                              ]),
                        ),
                        trailing: Wrap(
                          children: [
                            IconButton(
                                onPressed: () async {
                                  await mongoDbCrud.updateItem(
                                      mongoDbCrud.searchTextResult[index]
                                          ['_id'],
                                      'users',
                                      UserModel(
                                              name: nameTextEditingController
                                                  .text
                                                  .toString(),
                                              age: int.parse(
                                                  ageTextEditingController
                                                      .text),
                                              email: emailTextEditingController
                                                  .text
                                                  .toString())
                                          .toJson());
                                  userList = await mongoDbCrud.getList('users');
                                  setState(() {});
                                },
                                icon: const Icon(Icons.update)),
                            IconButton(
                                onPressed: () async {
                                  await mongoDbCrud.removeItem(
                                      mongoDbCrud.searchTextResult[index]
                                          ['_id'],
                                      'users');
                                  userList = await mongoDbCrud.getList('users');
                                  setState(() {});
                                },
                                icon: const Icon(Icons.delete)),
                          ],
                        ),
                      ),
                    );
                  })
              //* User List
              : userList != null
                  ? ListView.builder(
                      controller: ScrollController(),
                      shrinkWrap: true,
                      itemCount: userList!.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            child: ListTile(
                              leading: const Icon(Icons.person),
                              title: Text(userList![index]['name']),
                              subtitle: RichText(
                                text: TextSpan(
                                    text: userList![index]['email'],
                                    style: const TextStyle(color: Colors.black),
                                    children: [
                                      const TextSpan(
                                          text: ' - ',
                                          style:
                                              TextStyle(color: Colors.black)),
                                      TextSpan(
                                          text: userList![index]['age']
                                              .toString(),
                                          style: const TextStyle(
                                              color: Colors.black)),
                                    ]),
                              ),
                              trailing: Wrap(
                                children: [
                                  IconButton(
                                      onPressed: () async {
                                        await mongoDbCrud.removeItem(
                                            userList![index]['_id'], 'users');
                                        userList =
                                            await mongoDbCrud.getList('users');
                                        setState(() {});
                                      },
                                      icon: const Icon(Icons.delete)),
                                  IconButton(
                                      onPressed: () async {
                                        await mongoDbCrud.updateItem(
                                            userList![index]['_id'],
                                            'users',
                                            UserModel(
                                                    name:
                                                        nameTextEditingController
                                                            .text
                                                            .toString(),
                                                    age: int.parse(
                                                        ageTextEditingController
                                                            .text),
                                                    email:
                                                        emailTextEditingController
                                                            .text
                                                            .toString())
                                                .toJson());
                                        userList =
                                            await mongoDbCrud.getList('users');
                                        setState(() {});
                                      },
                                      icon: const Icon(Icons.update)),
                                ],
                              ),
                            ),
                          ),
                        );
                      })
                  : const CircularProgressIndicator()
        ]),
      ),
    );
  }
}
