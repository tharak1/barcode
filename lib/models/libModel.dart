// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class LibraryBooksModel {
  final String BookId;
  final String BookName;
  final String BookImage;
  final String BookAuthor;
  final String BookEdition;
  LibraryBooksModel({
    required this.BookId,
    required this.BookName,
    required this.BookImage,
    required this.BookAuthor,
    required this.BookEdition,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'BookId': BookId,
      'BookName': BookName,
      'BookImage': BookImage,
      'BookAuthor': BookAuthor,
      'BookEdition': BookEdition,
    };
  }

  factory LibraryBooksModel.fromMap(Map<String, dynamic> map) {
    return LibraryBooksModel(
      BookId: map['BookId'] as String,
      BookName: map['BookName'] as String,
      BookImage: map['BookImage'] as String,
      BookAuthor: map['BookAuthor'] as String,
      BookEdition: map['BookEdition'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory LibraryBooksModel.fromJson(String source) =>
      LibraryBooksModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class LibraryModel {
  final String name;
  final String rollNo;
  final String regulation;
  final String department;
  final String section;
  final String imageUrl;
  List<String> booksTaken;
  List<String> dateTaken;
  List<LibraryBooksModel> booksTakenData;
  LibraryModel({
    required this.name,
    required this.rollNo,
    required this.regulation,
    required this.department,
    required this.section,
    required this.imageUrl,
    required this.booksTaken,
    required this.dateTaken,
    required this.booksTakenData,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'rollNo': rollNo,
      'regulation': regulation,
      'department': department,
      'section': section,
      'imageUrl': imageUrl,
      'booksTaken': booksTaken,
      'dateTaken': dateTaken,
      'booksTakenData': booksTakenData.map((x) => x.toMap()).toList(),
    };
  }

  factory LibraryModel.fromMap(Map<String, dynamic> map) {
    return LibraryModel(
      name: map['name'] as String,
      rollNo: map['rollNo'] as String,
      regulation: map['regulation'] as String,
      department: map['department'] as String,
      section: map['section'] as String,
      imageUrl: map['imageUrl'] as String,
      booksTaken: List<String>.from(map['booksTaken'] as List<dynamic>),
      dateTaken: List<String>.from(map['dateTaken'] as List<dynamic>),
      booksTakenData: List<LibraryBooksModel>.from(
        (map['booksTakenData'] as List<dynamic>).map<LibraryBooksModel>(
          (x) => LibraryBooksModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory LibraryModel.fromJson(String source) =>
      LibraryModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
