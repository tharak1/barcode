import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:lib_barcode/models/libModel.dart';
import 'package:http/http.dart' as http;
import 'package:lib_barcode/services/ip.dart';

setLibraryDetails(Map<String, dynamic> message) async {
  final SendPort sendPort = message['sendPort'];
  final rollno = message['rollno'];
  // await Future.delayed(Duration(seconds: 2));
  try {
    var response = await http
        .get(Uri.parse("$ip/api/library/getDataOnScan?rollno=$rollno"));
    if (response.statusCode == 200) {
      var data = response.body;
      LibraryModel lib = LibraryModel.fromJson(data);
      debugPrint(response.body);
      sendPort.send(lib);
    } else {
      sendPort.send("Failed to fetch data: ${response.statusCode}");
    }
  } catch (e) {
    debugPrint(e.toString());
    sendPort.send("Error: $e");
  }
}

addNewBook(Map<String, dynamic> message) async {
  final SendPort sendPort = message['sendPort'];
  final rollno = message['rollno'];
  final bookId = message['bookId'];
  try {
    var response = await http.post(
      Uri.parse("$ip/api/library/update?rollno=$rollno"),
      body: jsonEncode({"bookId": bookId}),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      sendPort.send("Added Success fully");
    } else if (response.statusCode == 400) {
      sendPort.send('Already exists');
    } else {
      sendPort.send("Failed to fetch data: ${response.statusCode}");
    }
  } catch (e) {
    debugPrint(e.toString());
    sendPort.send("Error: $e");
  }
}

removeBook(Map<String, dynamic> message) async {
  final SendPort sendPort = message['sendPort'];
  final rollno = message['rollno'];
  final bookId = message['bookId'];
  try {
    var response = await http.post(
      Uri.parse("$ip/api/library/remove?rollno=$rollno"),
      body: jsonEncode({"bookId": bookId}),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      sendPort.send("Removed Success fully");
    } else {
      sendPort.send("Failed to fetch data: ${response.statusCode}");
    }
  } catch (e) {
    debugPrint(e.toString());
    sendPort.send("Error: $e");
  }
}

updateBook(Map<String, dynamic> message) async {
  final SendPort sendPort = message['sendPort'];
  final rollno = message['rollno'];
  final bookId = message['bookId'];
  try {
    var response = await http.post(
      Uri.parse("$ip/api/library/updatedate?rollno=$rollno"),
      body: jsonEncode({"bookId": bookId}),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      sendPort.send("Updated Success fully");
    } else {
      sendPort.send("Failed to fetch data: ${response.statusCode}");
    }
  } catch (e) {
    debugPrint(e.toString());
    sendPort.send("Error: $e");
  }
}
