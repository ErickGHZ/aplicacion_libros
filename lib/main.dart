import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:libros/book.dart';
import 'package:libros/convert_utility.dart';
import 'package:libros/dbManager.dart';
import 'package:libros/info_page.dart';// Make sure to import your DBManager class

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.light),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.dark,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<Book>>? Bookss;
  TextEditingController titleController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  TextEditingController publisherController = TextEditingController();
  TextEditingController pagesController = TextEditingController();
  TextEditingController editionController = TextEditingController();
  TextEditingController isbnController = TextEditingController();
  TextEditingController controlNumController = TextEditingController();
  TextEditingController buscarLibroController = TextEditingController();

  String? title = '';
  String? author = '';
  String? publisher = '';
  String? pages = '';
  String? edition = '';
  String? isbn = '';
  String? photoname = '';

  //Update control
  int? currentUserId;
  final formKey = GlobalKey<FormState>();
  late var dbHelper;
  late bool isUpdating;

  //Metodos de usuario
  refreshList() {
    setState(() {
      Bookss = dbHelper.getBooks();
    });
  }

  searchBooks() {
    String query = buscarLibroController.text;
    setState(() {
      Bookss = dbHelper.searchBooks(query);
    });
  }


  pickImageFromGallery() {
    ImagePicker imagePicker = ImagePicker();
    imagePicker
        .pickImage(source: ImageSource.gallery, maxHeight: 480, maxWidth: 640)
        .then((value) async {
      Uint8List? imageBytes = await value!.readAsBytes();
      setState(() {
        photoname = Utility.base64String(imageBytes!);
      });
    });
  }

  clearFields() {
    titleController.text = '';
    authorController.text = '';
    publisherController.text = '';
    pagesController.text = '';
    editionController.text = '';
    isbnController.text = '';
    controlNumController.text = '';
    photoname = '';
  }

  @override
  void initState() {
    super.initState();
    dbHelper = DBManager();
    refreshList();
    isUpdating = false;
  }

  Widget userForm() {
    return Form(
      key: formKey,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: [
            TextFormField(
              controller: titleController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Por favor ingresa el titulo";
                }
                if (value.length > 50) {
                  return "El titulo no debe tener más de 50 caracteres.";
                }
                return null;
              },
              onSaved: (val) => title = val!,
            ),
            TextFormField(
              controller: authorController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: 'Autor',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Por favor ingresa el autor";
                }
                if (value.length > 50) {
                  return "El autor no debe tener más de 150 caracteres.";
                }
                return null;
              },
              onSaved: (val) => author = val!,
            ),
            TextFormField(
              controller: publisherController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: 'Editorial',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Por favor ingresa la editorial";
                }
                if (value.length > 50) {
                  return "La editorial no debe tener más de 50 caracteres.";
                }
                return null;
              },
              onSaved: (val) => publisher = val!,
            ),
            TextFormField(
              controller: pagesController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: 'Paginas',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Por favor pon el numero de paginas";
                }
                if (value.length > 4) {
                  return "El numero de paginas de paginas no debe tenre mas de 4 caracteres";
                }
                if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                  return "Tu número debe contener solo dígitos numéricos";
                }
                return null;
              },
              onSaved: (val) => pages = val!,
            ),
            TextFormField(
              controller: editionController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: 'Edicion',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Por favor pon la edicion";
                }
                if (value.length > 50) {
                  return "La edicion no debe tener más de 50 caracteres.";
                }
                return null;
              },
              onSaved: (val) => edition = val!,
            ),
            TextFormField(
              controller: isbnController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: 'ISBN',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Por favor pon el ISBN";
                }
                if (value.length > 50) {
                  return "El ISBN no debe tener más de 50 caracteres.";
                }
                return null;
              },
              onSaved: (val) => isbn = val!,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                  onPressed: validate,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(color: Colors.red)),
                  child: Text(isUpdating ? "Actualizar" : "Insertar"),
                ),
                MaterialButton(
                  onPressed: (){
                    pickImageFromGallery();
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(color: Colors.green)),
                  child: const Text("Seleccionar imagen"),
                )
              ],
            ),
            Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: buscarLibroController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: 'Buscar libros',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    searchBooks();
                    print('Texto ingresado en el nuevo campo: ${buscarLibroController.text}');
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(color: Colors.blue),
                    ),
                  ),
                  child: Text("Buscar"),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }






  SingleChildScrollView userDataTable(List<Book>? Bookss){
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Photo')),
          DataColumn(label: Text('Titulo')),
          DataColumn(label: Text('Autor')),
          DataColumn(label: Text('Editorial')),
          DataColumn(label: Text('Paginas')),
          DataColumn(label: Text('Edicion')),
          DataColumn(label: Text('ISBN')),
          DataColumn(label: Text('Delete')),
        ],
        rows: Bookss!.map((book)=>DataRow(cells: [
          DataCell(Container(
            width: 80,
            height: 120,
            child: Utility.ImageFromBase64String(book.photoName!),
          ), onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => InfoPage(book: book),
              ),
            );
          },
          ),
          DataCell(Text(book.title!), onTap: (){
            setState(() {
              isUpdating = true;
              currentUserId = book.controlNum;
            });
            titleController.text = book.title!;
            authorController.text = book.author!;
            publisherController.text = book.publisher!;
            pagesController.text = book.pages!;
            editionController.text = book.edition!;
            isbnController.text = book.isbn!;
            photoname = book.photoName!;
          }),
          DataCell(Text(book.author!)),
          DataCell(Text(book.publisher!)),
          DataCell(Text(book.pages!)),
          DataCell(Text(book.edition!)),
          DataCell(Text(book.isbn!)),
          DataCell(IconButton(
            onPressed: () {
              dbHelper.delete(book.controlNum);
              refreshList();
            },
            icon: const Icon(Icons.delete),
          ))
        ])).toList(),
      ),
    );
  }

  Widget list (){
    return Expanded(
        child: SingleChildScrollView(
          child: FutureBuilder(
              future: Bookss,
              builder: (context, AsyncSnapshot<dynamic> snapshot){
                if(snapshot.hasData){
                  return userDataTable(snapshot.data);
                }
                if(!snapshot.hasData){
                 }
                return const CircularProgressIndicator();
              }),
        ));
  }

  validate() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      if (photoname == '') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Por favor, seleccione una foto antes de guardar.'),
        ));
        return;
      }
      else if(isUpdating) {
        Book book = Book(
            controlNum: currentUserId,
            title: title,
            author: author,
            publisher: publisher,
            pages: pages,
            edition: edition,
            isbn: isbn,
            photoName: photoname);
        dbHelper.update(book);
        isUpdating = false;
      } else {
        Book book = Book(
            controlNum: null,
            title: title,
            author: author,
            publisher: publisher,
            pages: pages,
            edition: edition,
            isbn: isbn,
            photoName: photoname);
        dbHelper.save(book);
      }
      clearFields();
      refreshList();
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('SQLite DB'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        verticalDirection: VerticalDirection.down,
        children: [userForm(),list()],
      ),
    );
  }
}