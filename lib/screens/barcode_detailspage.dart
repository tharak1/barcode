import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lib_barcode/models/libModel.dart';
import 'package:lib_barcode/services/functions.dart';
import 'package:lib_barcode/widgets/details_card.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:intl/intl.dart';
import 'package:vibration/vibration.dart';

class BarcodeDetailsPage extends StatefulWidget {
  final String barcodeResult;

  const BarcodeDetailsPage(this.barcodeResult, {super.key});

  @override
  State<BarcodeDetailsPage> createState() => _BarcodeDetailsPageState();
}

class _BarcodeDetailsPageState extends State<BarcodeDetailsPage> {
  List<Map<String, dynamic>> books = [];
  bool isError = false;
  LibraryModel data = LibraryModel(
      name: "",
      rollNo: "",
      regulation: '',
      department: "",
      section: "",
      imageUrl: "",
      booksTaken: [],
      dateTaken: [],
      booksTakenData: []);

  @override
  void initState() {
    super.initState();
    fetchdata();
  }

  fetchdata() async {
    final receivePort = ReceivePort();
    await Isolate.spawn(setLibraryDetails,
        {'sendPort': receivePort.sendPort, 'rollno': widget.barcodeResult});
    receivePort.listen((dynamic message) {
      if (message is LibraryModel) {
        debugPrint("Data received: $message");
        setState(() {
          data = message;
        });
      } else if (message is String) {
        debugPrint("Error: $message");
        setState(() {
          isError = true;
        });
      }
    });
  }

  updateDateForBook(String bookId) async {
    final receivePort = ReceivePort();
    await Isolate.spawn(updateBook, {
      'sendPort': receivePort.sendPort,
      'rollno': widget.barcodeResult,
      'bookId': bookId
    });
    receivePort.listen((dynamic message) {
      if (message == "Updated Success fully") {
        debugPrint("Data received: $message");
        setState(() {
          data = LibraryModel(
              name: "",
              rollNo: "",
              regulation: '',
              department: "",
              section: "",
              imageUrl: "",
              booksTaken: [],
              dateTaken: [],
              booksTakenData: []);
        });
        fetchdata();
      } else if (message is String) {
        debugPrint("Error: $message");
        setState(() {
          isError = true;
        });
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Warning"),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("cancel"),
              ),
            ],
          ),
        );
      }
    });
  }

  deleteUserBook(String bookId) async {
    final receivePort = ReceivePort();
    await Isolate.spawn(removeBook, {
      'sendPort': receivePort.sendPort,
      'rollno': widget.barcodeResult,
      'bookId': bookId
    });
    receivePort.listen((dynamic message) {
      if (message == "Removed Success fully") {
        debugPrint("Data received: $message");
        setState(() {
          data = LibraryModel(
              name: "",
              rollNo: "",
              regulation: '',
              department: "",
              section: "",
              imageUrl: "",
              booksTaken: [],
              dateTaken: [],
              booksTakenData: []);
        });
        fetchdata();
      } else {
        debugPrint("Error: $message");
        setState(() {
          isError = true;
        });
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Warning"),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("cancel"),
              ),
            ],
          ),
        );
      }
    });
  }

  addUserBook(String bookId) async {
    final receivePort = ReceivePort();
    await Isolate.spawn(addNewBook, {
      'sendPort': receivePort.sendPort,
      'rollno': widget.barcodeResult,
      'bookId': bookId
    });
    receivePort.listen((dynamic message) {
      if (message == "Added Success fully") {
        debugPrint("Data received: $message");
        setState(() {
          data = LibraryModel(
              name: "",
              rollNo: "",
              regulation: '',
              department: "",
              section: "",
              imageUrl: "",
              booksTaken: [],
              dateTaken: [],
              booksTakenData: []);
        });
        fetchdata();
      } else if (message == 'Already exists') {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Warning"),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("cancel"),
              ),
            ],
          ),
        );
      } else {
        debugPrint("Error: $message");
        setState(() {
          isError = true;
        });
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Warning"),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("cancel"),
              ),
            ],
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Barcode Details'),
      ),
      body: isError
          ? const Center(
              child: Text("Something went wrong"),
            )
          : data.name == ""
              ? const Center(
                  child: CircularProgressIndicator.adaptive(),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 2, 8, 0),
                      child: Text(
                        'Details for Barcode: ${widget.barcodeResult}',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 2, 8, 0),
                      child: DetailsCard(lib: data),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 5, 8, 20),
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: data.booksTaken.length,
                          itemBuilder: (context, index) => Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text("${index + 1}"),
                              ),
                              title: Text(
                                  '${data.booksTakenData[index].BookName}\n${data.booksTaken[index]}'),
                              subtitle: Text(
                                'Borrowed: ${DateFormat('d MMMM y').format(DateTime.parse(data.dateTaken[index]))}\n Days Left: ${14 - (DateTime.now().difference(DateTime.parse(data.dateTaken[index]))).inDays}',
                              ),
                              trailing: Wrap(
                                spacing: 12,
                                children: <Widget>[
                                  IconButton(
                                    icon: const Icon(Icons.refresh),
                                    onPressed: () {
                                      Vibration.vibrate(duration: 100);

                                      showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: const Text("Confirmation"),
                                          content: Text(
                                              "Do you want to Update Date for book - \n${data.booksTakenData[index].BookName} \nfor the user "),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text("cancel"),
                                            ),
                                            ElevatedButton(
                                                onPressed: () {
                                                  Vibration.vibrate(
                                                      duration: 100);

                                                  updateDateForBook(
                                                      data.booksTaken[index]);
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("Ok"))
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      Vibration.vibrate(duration: 100);

                                      showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: const Text("Confirmation"),
                                          content: Text(
                                              "Do you want to delete book - \n${data.booksTakenData[index].BookName} \nfor the user "),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text("cancel"),
                                            ),
                                            ElevatedButton(
                                                onPressed: () {
                                                  Vibration.vibrate(
                                                      duration: 100);

                                                  deleteUserBook(
                                                      data.booksTaken[index]);
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("Ok"))
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewBook,
        tooltip: 'Add Book',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _addNewBook() async {
    if (data.booksTaken.length < 6) {
      final scannedBookName = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SimpleBarcodeScannerPage(),
        ),
      );

      if (scannedBookName == null ||
          (scannedBookName is! String) ||
          scannedBookName.isEmpty) {
        return;
      } else {
        Vibration.vibrate(duration: 100);
        addUserBook(scannedBookName);
      }
    } else {
      Vibration.vibrate(duration: 100);

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Warning"),
          content: const Text("Limit exceeded there are 6 books already"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("cancel"),
            ),
          ],
        ),
      );
    }
  }
}
