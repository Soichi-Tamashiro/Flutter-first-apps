import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart';
import 'package:intl/intl.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recetas Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.teal,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BottomNavBar(title: 'Recetas'),
    );
  }
}

class BottomNavBar extends StatefulWidget {
  BottomNavBar({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;
  File _image;
  String basename;
  // Future<Directory> _externalDocumentsDirectory;

  Future getImage(ImgSource source) async {
    var image = await ImagePickerGC.pickImage(
        context: context,
        source: source,
        cameraIcon: Icon(
          Icons.add,
          color: Colors.red,
        ),
        cameraText: Text(
          "From Camera",
          style: TextStyle(color: Colors.red),
        ) //cameraIcon and galleryIcon can change. If no icon provided default icon will be present
        );
    setState(() {
      _image = image;
      String basename = _image.path;
      String basename_last = _image.path.split("/")?.last;
      // print(basename);
      // replaceAll(basename, basename_last);
      String newDirect = basename.replaceFirst(basename_last, "");
      // print(newDirect);
      var now = new DateTime.now();
      var formatter = new DateFormat('yyyy-MM-dd_HH-mm-ss');
      String formattedDate = formatter.format(now);
      // print(formattedDate); // 2020-09-06_18-16-01
      String mPath = newDirect + '${formattedDate}_receta.jpg';
      print(mPath);
      // getExternalStorageDirectory();
      // String imgType = path.split('.').last;
      // String mPath =
      //     '${directory.path.toString()}/${DateTime.now()}_receta.$imgType';
      // String mPath =
      //     '${getExternalStorageDirectory()}/Pictures/${DateTime.now()}_receta.jpg';
      // var myFile = new File(
      //     '${getExternalStorageDirectory()}/${DateTime.now()}_receta.jpg');
      // myFile = image;
      _image = _image.renameSync(mPath);
      // _image = image;
    });
  }

  final tabs = [
    Center(
      child: Text('Galleria'),
    ),
    Center(
      child: Text(
        'Para Agregar Nuevas Recetas Volver a Presionar el Botón de Nueva Receta',
        textAlign: TextAlign.center,
      ),
    ),
    Center(
      child: Text('busqueda'),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the BottomNavBar object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.photo_library),
              title: Text('Galería'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_a_photo),
              title: Text('Nueva Receta'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              title: Text('Buscar Receta'),
            ),
          ],
          selectedItemColor: Colors.amber[800],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
              if (_currentIndex == 1) {
                getImage(ImgSource.Camera);
              }
            });
          }),
    );

    // Future<File> _saveImageToDisk(File myfile, Directory directory) async {
    //   setState(() {
    //     try {
    //       //getImage(ImgSource.Both);
    //       File tempFile = myfile;
    //       // File image = tempFile.readAsBytesSync();
    //       String imgType = path.split('.').last;
    //       String mPath =
    //           '${directory.path.toString()}/${DateTime.now()}_receta.$imgType';
    //       tempFile = tempFile.renameSync(mPath);
    //     } catch (e) {
    //       //
    //     }
    //   });
    // }
  }
}
