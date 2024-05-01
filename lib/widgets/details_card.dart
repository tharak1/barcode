import 'package:flutter/material.dart';
import 'package:lib_barcode/models/libModel.dart';

class DetailsCard extends StatelessWidget {
  final LibraryModel lib;
  const DetailsCard({super.key, required this.lib});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF7F8FB),
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      height: MediaQuery.of(context).size.height / 4.5,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 18,
                  ),
                  const Text(
                    'Library Data,',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Text(
                    lib.name,
                    style: const TextStyle(
                        fontSize: 20, color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  Text(
                    lib.rollNo.toUpperCase(),
                    style: const TextStyle(
                        fontSize: 18, color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  Text(
                    "${lib.department}-${lib.section}   ${lib.regulation}",
                    style: const TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
            ),
            Container(
                clipBehavior: Clip.hardEdge,
                height: MediaQuery.of(context).size.height / 6,
                width: MediaQuery.of(context).size.width / 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/placeHolder.png',
                  image: lib.imageUrl,
                  fit: BoxFit.fitHeight,
                )),
          ],
        ),
      ),
    );
  }
}
