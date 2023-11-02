import 'package:flutter/material.dart';
import 'package:libros/book.dart';
import 'package:libros/convert_utility.dart';

class InfoPage extends StatelessWidget {
  final Book book;

  InfoPage({required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Informacion del Libro')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start ,
        children: [
          Container(
            width: 400,
            height: 250,
            child: Utility.ImageFromBase64String(book.photoName!),
          ),
          SizedBox(height: 40),
          Text(
            'Titulo: ${book.title}',
            style: TextStyle(fontSize: 25),
          ),
          SizedBox(height: 20),
          Text(
            'Autor: ${book.author}',
            style: TextStyle(fontSize: 25),
          ),
          SizedBox(height: 20),
          Text(
            'Editorial: ${book.publisher}',
            style: TextStyle(fontSize: 25),
          ),
          SizedBox(height: 20),
          Text(
            'Paginas: ${book.pages}',
            style: TextStyle(fontSize: 25),
          ),
          SizedBox(height: 20),
          Text(
            'Edicion: ${book.edition}',
            style: TextStyle(fontSize: 25),
          ),
          SizedBox(height: 20),
          Text(
            'ISBN: ${book.isbn}',
            style: TextStyle(fontSize: 25),
          ),
        ],
      ),
    );
  }
}
