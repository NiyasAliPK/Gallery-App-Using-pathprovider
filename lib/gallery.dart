import 'dart:io';
import 'package:custom_gallery/FullScreenImg.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

ValueNotifier<List> database = ValueNotifier([]);

class Gallery extends StatelessWidget {
  const Gallery({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.purple, Colors.red]),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.purple,
          onPressed: () async {
            final image =
                await ImagePicker().pickImage(source: ImageSource.camera);
            if (image == null) {
              return;
            } else {
              Directory? directory = await getExternalStorageDirectory();
              File imagepath = File(image.path);

              await imagepath.copy('${directory!.path}/${DateTime.now()}.jpg');

              // print(directory.path);
              // Directory directory = Directory.fromUri(
              //     Uri.parse('/data/data/com.example.custom_gallery/'));
              getitems(directory);
            }
          },
          child: const Icon(Icons.camera_alt_outlined),
        ),
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[Colors.red, Colors.purple]),
            ),
          ),
          centerTitle: true,
          title: const Text('My Gallery'),
        ),
        body: ValueListenableBuilder(
            valueListenable: database,
            builder: (context, List data, anything) {
              return Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                child: GridView.extent(
                    maxCrossAxisExtent: 150,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    children: List.generate(data.length, (index) {
                      // File img = File.fromUri(data[index]);
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx) => FullScreenImg(
                                  image: data[index], tagForHero: index)));
                        },
                        // child: Hero(
                        //   tag: index,
                        //   child: Image.file(
                        //     File(
                        //       data[index].toString(),
                        //     ),
                        //   ),
                        // ),
                        child: Hero(
                          tag: index,
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: FileImage(
                                    File(
                                      data[index],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    })),
              );
            }),
      ),
    );
  }
}

getitems(Directory directory) async {
  final listDir = await directory.list().toList();
  // print(listDir);
  database.value.clear();
  for (var i = 0; i < listDir.length; i++) {
    if (listDir[i].path.substring(
            (listDir[i].path.length - 4), (listDir[i].path.length)) ==
        '.jpg') {
      database.value.add(listDir[i].path);
      database.notifyListeners();
    }
  }
}

// Future<String> createFolder(String CustomGallery) async {
//   final folderName = CustomGallery;
//   final directoryForGallery = Directory("storage/emulated/0/$folderName");
//   var status = await Permission.storage.status;
//   if (!status.isGranted) {
//     await Permission.storage.request();
//   }
//   if ((await directoryForGallery.exists())) {
//     return directoryForGallery.path;
//   } else {
//     await directoryForGallery.create();
//     return directoryForGallery.path;
//   }
// }
