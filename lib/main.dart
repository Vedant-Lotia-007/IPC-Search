import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IPC Search',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const SelectionScreen(),
    );
  }
}

class SelectionScreen extends StatefulWidget {
  const SelectionScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SelectionScreen();
  }
}

class _SelectionScreen extends State<SelectionScreen> {
  List fullData = [];
  List searchData = [];
  TextEditingController textEditingController = TextEditingController();

  @override
  initState() {
    super.initState();
    getLocalJsonData();
  }

  getLocalJson() {
    return rootBundle.loadString('assets/ipc.json'); // Read your local Data
  }

  Future getLocalJsonData() async {
    final responce = json.decode(await getLocalJson());
    List tempList = [];
    for (var i in responce) {
      tempList.add(i); // Create a list and add data one by one
    }
    fullData = tempList;
  }

  onSearchTextChanged(String text) async {
    searchData.clear();
    if (text.isEmpty) {
      // Check textfield is empty or not
      setState(() {});
      return;
    }

    for (var data in fullData) {
      if (data['section_desc']
          .toString()
          .toLowerCase()
          .contains(text.toLowerCase().toString())) {
        searchData.add(
            data); // If not empty then add search data into search data list
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const InkWell(
          child: Text("IPC Search "),
        ),
      ),
      body: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
                icon: Icon(Icons.search), hintText: "Search Here"),
            controller: textEditingController,
            onChanged: onSearchTextChanged,
          ),
          Expanded(
            child: searchData
                    .isEmpty // Check SearchData list is empty or not if empty then show full data else show search data
                ? ListView.builder(
                    itemCount: fullData.length,
                    itemBuilder: (context, int index) {
                      return Container(
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey,
                                  spreadRadius: 2,
                                  offset: Offset(2, 2))
                            ]),
                        margin: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Chapter ${fullData[index]['chapter'].toString().toUpperCase()}: ${fullData[index]['chapter_title'].toString().toUpperCase()} ",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(
                              "Section ${fullData[index]['Section'].toString().toUpperCase()}: ${fullData[index]['section_title']}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Container(
                              height: 2,
                            ),
                            Text(fullData[index]['section_desc'])
                          ],
                        ),
                      );
                    },
                  )
                : ListView.builder(
                    itemCount: searchData.length,
                    itemBuilder: (context, int index) {
                      final res = searchData[index]['section_desc']
                          .toString()
                          .split(textEditingController.text.toLowerCase());
                      final s1 = res[0];
                      final s2 = textEditingController.text.toLowerCase();
                      final s3 = res.length > 1 ? res[1] : "";
                      return Container(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey,
                                    spreadRadius: 2,
                                    offset: Offset(2, 2))
                              ]),
                          margin: const EdgeInsets.all(10),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Chapter ${searchData[index]['chapter'].toString().toUpperCase()}: ${fullData[index]['chapter_title'].toString().toUpperCase()}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                Text(
                                  "Section ${searchData[index]['Section'].toString().toUpperCase()}: ${fullData[index]['section_title']}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                Container(
                                  height: 2,
                                ),
                                //Text(searchData[index]['section_desc']);
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                          text: s1,
                                          style: const TextStyle(
                                              color: Colors.black)),
                                      TextSpan(
                                          text: s2,
                                          style: const TextStyle(
                                              color: Colors.red)),
                                      TextSpan(
                                          text: s3,
                                          style: const TextStyle(
                                              color: Colors.black))
                                      // ]));
                                      // Text(searchData[index]['section_desc'])
                                    ],
                                  ),
                                )
                              ]));
                    },
                  ),
          )
        ],
      ),
    );
  }
}
