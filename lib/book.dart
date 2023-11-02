class Book {
  int? controlNum;
  String? title;
  String? author;
  String? publisher;
  String? pages;
  String? edition;
  String? isbn;
  String? photoName;

  Book({this.controlNum, this.title, this.author, this.publisher,
    this.pages, this.edition, this.photoName, this.isbn});


  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'controlNum': controlNum,
      'title': title,
      'author': author,
      'publisher': publisher,
      'pages': pages,
      'edition': edition,
      'isbn': isbn,
      'photo_name': photoName
    };
    return map;
  }

  Book.formMap(Map<String, dynamic> map){
    controlNum = map['controlNum'];
    title = map['title'];
    author = map['author'];
    publisher = map['publisher'];
    pages = map['pages'];
    edition = map['edition'];
    isbn = map['isbn'];
    photoName = map['photo_name'];
  }

}