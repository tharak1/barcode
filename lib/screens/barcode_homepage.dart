import 'package:flutter/material.dart';
import 'package:lib_barcode/screens/barcode_detailspage.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:vibration/vibration.dart';

class Barcode_HomePage extends StatefulWidget {
  const Barcode_HomePage({Key? key}) : super(key: key);

  @override
  State<Barcode_HomePage> createState() => _Barcode_HomePageState();
}

class _Barcode_HomePageState extends State<Barcode_HomePage> {
  String result = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Library"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () async {
                var res = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SimpleBarcodeScannerPage(),
                  ),
                );
                setState(() {
                  if (res is String) {
                    Vibration.vibrate(duration: 100);

                    result = res;
                    // Navigate to the details screen when a barcode is scanned
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BarcodeDetailsPage(result),
                      ),
                    );
                  }
                });
              },
              child: const Text('Open Scanner'),
            ),
          ],
        ),
      ),
    );
  }
}

// class BarcodeDetailsPage extends StatelessWidget {
//   final String barcodeResult;

//   const BarcodeDetailsPage(this.barcodeResult);

//   @override
//   Widget build(BuildContext context) {
//     // TODO: Add logic to fetch details based on barcodeResult

//     // For demonstration purposes, displaying a simple table with static data
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Barcode Details'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text('Details for Barcode: $barcodeResult'),
//             const SizedBox(height: 20),
//             UserDetailsTable(),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class UserDetailsTable extends StatelessWidget {
//   const UserDetailsTable({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Table(
//       border: TableBorder.all(),
//       columnWidths: const {
//         0: FixedColumnWidth(50.0),
//         1: FlexColumnWidth(),
//         2: FlexColumnWidth(),
//         3: FlexColumnWidth(),
//         4: FlexColumnWidth(),
//       },
//       children: [
//         TableRow(
//           children: [
//             TableCell(
//               child: Center(child: Text('S.NO')),
//             ),
//             TableCell(
//               child: Center(child: Text('Book ID')),
//             ),
//             TableCell(
//               child: Center(child: Text('Book Name')),
//             ),
//             TableCell(
//               child: Center(child: Text('Date of Borrowed')),
//             ),
//             TableCell(
//               child: Center(child: Text('Date of Returned')),
//             ),
//           ],
//         ),
//         TableRow(
//           children: [
//             TableCell(
//               child: Center(child: Text('1')),
//             ),
//             TableCell(
//               child: Center(child: Text('123')),
//             ),
//             TableCell(
//               child: Center(child: Text('Flutter Book')),
//             ),
//             TableCell(
//               child: Center(child: Text('2023-01-01')),
//             ),
//             TableCell(
//               child: Center(child: Text('2023-01-10')),
//             ),
//           ],
//         ),
//         // Add more rows as needed
//       ],
//     );
//   }
// }
