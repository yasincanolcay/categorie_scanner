// ignore_for_file: unnecessary_null_comparison, empty_catches, deprecated_member_use, unused_local_variable

import 'dart:io';
import 'package:categorie_scanner/utils/colors.dart';
import 'package:categorie_scanner/utils/global.dart';
import 'package:categorie_scanner/widgets/drawer_settings_container.dart';
import 'package:categorie_scanner/widgets/file_card_widget.dart';
import 'package:categorie_scanner/widgets/folder_card_widget.dart';
import 'package:categorie_scanner/widgets/photo_grid_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as paths;
import 'package:process_run/cmd_run.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool imageGridType = false;
  bool imageGridButton = false;
  bool isLoading = false;
  bool nightMode = false;
  bool easyClickOpenFolder = false;
  bool easyClickOpenFile = false;
  bool isLoadMoreSettings = false;
  bool isLoadComponent = false;
  final selectedColor = themeIconColor;
  int historyIndex = 0;
  List<String> historyList = [];
  List<String> filter = ["all"];
  List<String> pathsAndNames = [];
  String selectedDirectory = "Bir klasör seçiniz";
  String nowDirectory = "Bir klasör seçiniz";
  bool onlyFiles = false;
  bool onlyFolders = false;
  // Dosya izinlerini isteyen metot
  Future<bool> requestPermission(Permission permission) async {
    final status = await permission.request();
    return status == PermissionStatus.granted;
  }

  Future<List<FileSystemEntity>> getFilesInFolder(
      bool isSelectedPath, String path) async {
    pathsAndNames.clear();
    final files = <FileSystemEntity>[];
    try {
      setState(() {
        isLoading = true;
      });
      // Kullanıcılardan dosya erişim izinleri isteniyor
      bool permissionGranted = await requestPermission(Permission.storage);
      if (permissionGranted) {
        // İzin verilmiş, dosya işlemlerine başlanabilir
      } else {
        // İzin verilmemiş
      }
      // Kullanıcıdan bir klasör seçmesini isteyin
      final result =
          !isSelectedPath ? await FilePicker.platform.getDirectoryPath() : path;
      // Kullanıcının seçtiği klasörün yolunu alın
      final folderPath = result;
      if (!isSelectedPath) {
        selectedDirectory = folderPath!;
        historyList.clear();
        historyIndex = 0;
      }
      historyList.add(folderPath!);
      nowDirectory = folderPath;
      // Seçilen klasördeki tüm dosyalar ve alt klasörler
      if (folderPath != null) {
        final folder = Directory(folderPath);
        final lister = folder.list(recursive: true);
        await for (final fileOrDir in lister) {
          try {
            files.add(fileOrDir);
          } catch (r) {}
        }
      }
      setState(() {
        isLoading = false;
      });
    } catch (r) {}
    return files;
  }

  //dosyaya yolu yazdır
  void writeFilesPath(String path) async {
   // final currentDirectory = Directory.current.path;
    try {
      final filePath = "${Directory.current.path}/filePath.txt";
      final file = File(filePath);
      file.writeAsStringSync(path);
    } catch (r) {}

    String exePath =
        "${Directory.current.path}/pdf viewer/pdf viewer/bin/Release/pdf viewer.exe";
    Process process = await Process.start(exePath, []);
    stdout.addStream(process.stdout);
    stderr.addStream(process.stderr);
  }

  //dosyayı sil
  Future<void> deleteFile(String path, int fileIndex) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
      _files.removeAt(fileIndex);
      Navigator.pop(context);
      setState(() {});
    }
  }

  //klasörü sil
  Future<void> deleteFolder(String path, int fileIndex) async {
    final folder = Directory(path);
    if (await folder.exists()) {
      await folder.delete(recursive: true);
      _files.removeAt(fileIndex);
      Navigator.pop(context);
      setState(() {});
    }
  }

  void showAlert(String path, String type, String title, int fileIndex) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: const Text("Seçili içerik kalıcı olarak silinecek."),
            actions: [
              FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("İptal")),
              FlatButton(
                onPressed: () {
                  if (type == "file") {
                    deleteFile(path, fileIndex);
                  } else {
                    deleteFolder(path, fileIndex);
                  }
                },
                child: const Text("Sil"),
              ),
            ],
          );
        });
  }

  void showNowDirectory(bool nowDirectoryMode) {
    showDialog(
      context: context,
      builder: (context) {
        return Material(
          type: MaterialType.transparency,
          child: Center(
            child: Container(
              height: 80,
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: !nightMode ? themeBackColorLight : themeBackColorDark,
                borderRadius: const BorderRadius.all(Radius.circular(15)),
              ),
              child: ListTile(
                textColor: !nightMode ? textColorLight : textColorDark,
                title:
                    Text(nowDirectoryMode ? "Buradasınız" : "Seçilen Klasör"),
                leading: const Icon(Icons.folder),
                subtitle: Text(
                  nowDirectoryMode ? nowDirectory : selectedDirectory,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: !nightMode ? subtextColorLight : subtextColorDark,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  List<FileSystemEntity> _files = [];
  int _selectedDestination = 0;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: !nightMode ? themeColorLight : themeColorDark,
        foregroundColor: Colors.white,
        title: const Text("Categorie Scanner"),
        actions: [
          imageGridButton
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      if (imageGridType) {
                        imageGridType = false;
                        onlyFiles = false;
                      } else {
                        imageGridType = true;
                        onlyFiles = true;
                        onlyFolders = false;
                      }
                    });
                  },
                  icon: Icon(
                    !imageGridType
                        ? Icons.grid_view_rounded
                        : Icons.grid_off_rounded,
                    color: !imageGridType ? null : Colors.amber,
                  ),
                )
              : const SizedBox(),
          const SizedBox(
            width: 8.0,
          ),
          const Center(child: Text("Sadece Dosyalar:")),
          const SizedBox(
            width: 8.0,
          ),
          Switch(
              activeColor: Colors.amber,
              value: onlyFiles,
              onChanged: (vl) {
                setState(() {
                  isLoading = true;
                  onlyFiles = vl;
                  if (vl) {
                    onlyFolders = false;
                  }
                  isLoading = false;
                });
              }),
          const SizedBox(width: 5.0),
          const Icon(Icons.nightlight),
          Switch(
              activeColor: Colors.amber,
              value: nightMode,
              onChanged: (vl) {
                setState(() {
                  nightMode = vl;
                });
              }),
          IconButton(
              onPressed: () async {
                if (historyIndex > 0) {
                  historyIndex--;
                  final files =
                      await getFilesInFolder(true, historyList[historyIndex]);
                  setState(() {
                    _files = files;
                  });
                }
              },
              icon: const Icon(Icons.arrow_back)),
          const SizedBox(
            width: 10.0,
          ),
          IconButton(
              onPressed: () async {
                if (historyIndex < historyList.length) {
                  historyIndex++;
                  final files =
                      await getFilesInFolder(true, historyList[historyIndex]);
                  setState(() {
                    _files = files;
                  });
                }
              },
              icon: const Icon(Icons.arrow_forward))
        ],
      ),
      backgroundColor: !nightMode ? themeBackColorLight : themeBackColorDark,
      body: !isLoading && !imageGridType
          ? SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                itemCount: _files.length,
                itemBuilder: (BuildContext context, int index) {
                  final file = _files[index];
                  final name = file.path.split('/').last;
                  final extension = name.split('.').last;
                  pathsAndNames.add(name);
                  pathsAndNames.add(file.path);
                  int imgIndex = whichImage(extension);
                  return file is File
                      ? FileCardWidget(
                          filter: filter,
                          file: file,
                          name: name,
                          extension: extension,
                          onlyFolders: onlyFolders,
                          nightMode: nightMode,
                          easyClickOpenFile: easyClickOpenFile,
                          imgIndex: imgIndex,
                          cardPress: () {
                            if (easyClickOpenFile) {
                              Process.run('explorer.exe', [file.path],
                                  runInShell: true);
                            }
                          },
                          popupItem1Press: () {
                            final dr = Directory(file.parent.path);
                            Process.start('explorer.exe', [dr.path],
                                runInShell: true);
                          },
                          popupItem2Press: () async {
                            final files =
                                await getFilesInFolder(true, file.parent.path);
                            setState(() {
                              historyIndex++;
                              _files = files;
                            });
                          },
                          popupItem3Press: () {
                            Process.run('explorer.exe', [file.path],
                                runInShell: true);
                          },
                          popupItem4Press: () {
                            writeFilesPath(file.path);
                          },
                          popupItem5Press: () {
                            showAlert(file.path, "file",
                                "Bu Dosyayı Silmek İstiyor musunuz?", index);
                          },
                        )
                      : !onlyFiles || onlyFolders
                          ? FolderCardWidget(
                              cardPress: () async {
                                if (easyClickOpenFolder) {
                                  final files =
                                      await getFilesInFolder(true, file.path);
                                  setState(() {
                                    historyIndex++;
                                    _files = files;
                                  });
                                }
                              },
                              easyClickOpenFolder: easyClickOpenFolder,
                              nightMode: nightMode,
                              file: file,
                              popupPress1: () {
                                final dr = Directory(file.path);
                                Process.start('explorer.exe', [dr.path]);
                              },
                              popupPress2: () async {
                                final files =
                                    await getFilesInFolder(true, file.path);
                                setState(() {
                                  historyIndex++;
                                  _files = files;
                                });
                              },
                              popupPress3: () {
                                showAlert(
                                    file.path,
                                    "folder",
                                    "Bu Klasörü Silmek İstiyor musunuz?",
                                    index);
                              },
                            )
                          : const SizedBox();
                },
              ),
            )
          : imageGridType
              ? PhotoGridView(filesPaths: _files)
              : const Center(
                  child: CircularProgressIndicator(
                    color: themeColorLight,
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: !nightMode ? themeColorLight : themeColorDark,
        onPressed: () async {
          final files = await getFilesInFolder(false, "");
          setState(() {
            _files = files;
          });
        },
        child: const Icon(Icons.folder_open),
      ),
      drawer: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Drawer(
            backgroundColor:
                !nightMode ? themeBackColorLight : themeBackColorDark,
            child: SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              child: ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Dosya Kategorize Sistemi',
                              style: TextStyle(
                                color:
                                    !nightMode ? textColorLight : textColorDark,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: CircleAvatar(
                                backgroundColor: !nightMode
                                    ? themeColorLight
                                    : themeColorDark,
                                child: const Icon(
                                  Icons.close_rounded,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Autocomplete(
                          fieldViewBuilder: ((context, textEditingController,
                              focusNode, onFieldSubmitted) {
                            return TextFormField(
                              onFieldSubmitted: (st) async {
                                filter.clear();
                                filter.add(st);
                                final files = await getFilesInFolder(
                                    true, selectedDirectory);
                                setState(() {});
                                Navigator.pop(context);
                              },
                              cursorColor: themeColorLight,
                              controller: textEditingController,
                              focusNode: focusNode,
                              onEditingComplete: onFieldSubmitted,
                              decoration: InputDecoration(
                                  border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4.0)),
                                    borderSide: BorderSide(
                                        width: 1.0, color: themeColorLight),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    borderSide: BorderSide(
                                        width: 1, color: themeColorLight),
                                  ),
                                  errorBorder: const OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4)),
                                      borderSide: BorderSide(
                                          width: 1, color: Colors.red)),
                                  fillColor: themeColorLight,
                                  iconColor: themeColorLight,
                                  focusColor: themeColorLight,
                                  hoverColor: themeColorLight,
                                  prefixIconColor: themeColorLight,
                                  prefixIcon: const Icon(Icons.search),
                                  hintText: 'Dosya veya Klasör Arayın...',
                                  hintStyle: TextStyle(
                                      color: !nightMode
                                          ? subtextColorLight
                                          : subtextColorDark)),
                            );
                          }),
                          optionsBuilder: (TextEditingValue textEditingValue) {
                            if (textEditingValue.text == '') {
                              return const Iterable<String>.empty();
                            }
                            return pathsAndNames.where((String option) {
                              return option.contains(
                                  textEditingValue.text.toLowerCase());
                            });
                          },
                          onSelected: (String selection) {
                            debugPrint('You just selected $selection');
                          },
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    height: 1,
                    thickness: 1,
                  ),
                  ListTile(
                    textColor: nightMode ? subtextColorDark : null,
                    leading: const Icon(Icons.all_inbox_rounded),
                    title: const Text('Tümü'),
                    selected: _selectedDestination == 0,
                    onTap: () async {
                      filter.clear();
                      filter.add("all");
                      final files =
                          await getFilesInFolder(true, selectedDirectory);
                      setState(() {
                        imageGridButton = false;
                        imageGridType = false;
                        onlyFolders = false;
                        _files = files;
                      });
                      selectDestination(0);
                      Navigator.pop(context);
                    },
                    selectedColor: selectedColor,
                  ),
                  ListTile(
                    textColor: nightMode ? subtextColorDark : null,
                    leading: const Icon(Icons.photo),
                    title: const Text('Resimler'),
                    selected: _selectedDestination == 1,
                    selectedColor: selectedColor,
                    onTap: () async {
                      filter.clear();
                      filter.addAll(["jpg", "jpeg", "gif", "ico", "png"]);
                      final files =
                          await getFilesInFolder(true, selectedDirectory);
                      setState(() {
                        imageGridType = false;
                        imageGridButton = true;
                        onlyFolders = false;
                        _files = files;
                      });
                      selectDestination(1);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    textColor: nightMode ? subtextColorDark : null,
                    leading: const Icon(Icons.movie_rounded),
                    title: const Text('Videolar'),
                    selected: _selectedDestination == 2,
                    selectedColor: selectedColor,
                    onTap: () async {
                      filter.clear();
                      filter.addAll([
                        "mp4",
                        "avi",
                        "wmv",
                        "mov",
                        "flv",
                        "mkv",
                        "m4v",
                        "webm",
                        "3gp",
                        "mpeg",
                        "mpg",
                      ]);
                      final files =
                          await getFilesInFolder(true, selectedDirectory);
                      setState(() {
                        imageGridType = false;
                        imageGridButton = false;
                        onlyFolders = false;
                        _files = files;
                      });
                      selectDestination(2);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    textColor: nightMode ? subtextColorDark : null,
                    leading: const Icon(Icons.audio_file_rounded),
                    title: const Text('Sesler'),
                    selected: _selectedDestination == 3,
                    selectedColor: selectedColor,
                    onTap: () async {
                      filter.clear();
                      filter.addAll(audioExtension);
                      final files =
                          await getFilesInFolder(true, selectedDirectory);
                      setState(() {
                        imageGridType = false;
                        imageGridButton = false;
                        onlyFolders = false;
                        _files = files;
                      });
                      selectDestination(3);
                      Navigator.pop(context);
                    },
                  ),
                  const Divider(
                    height: 1,
                    thickness: 1,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Döküman Dosyaları',
                    ),
                  ),
                  ListTile(
                    textColor: nightMode ? subtextColorDark : null,
                    leading: const Icon(Icons.picture_as_pdf_rounded),
                    title: const Text('Pdf Dosyaları'),
                    selected: _selectedDestination == 4,
                    selectedColor: selectedColor,
                    onTap: () async {
                      filter.clear();
                      filter.addAll(["pdf"]);
                      final files =
                          await getFilesInFolder(true, selectedDirectory);
                      setState(() {
                        imageGridType = false;
                        imageGridButton = false;
                        onlyFolders = false;
                        _files = files;
                      });
                      selectDestination(4);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    textColor: nightMode ? subtextColorDark : null,
                    leading: const Icon(Icons.book_rounded),
                    title: const Text('Word Dosyaları'),
                    selected: _selectedDestination == 5,
                    selectedColor: selectedColor,
                    onTap: () async {
                      filter.clear();
                      filter.addAll(["doc", "docx", "odt", "rtf"]);
                      final files =
                          await getFilesInFolder(true, selectedDirectory);
                      setState(() {
                        imageGridType = false;
                        imageGridButton = false;
                        onlyFolders = false;
                        _files = files;
                      });
                      selectDestination(5);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    textColor: nightMode ? subtextColorDark : null,
                    leading: const Icon(Icons.web_rounded),
                    title: const Text('Web Dosyaları'),
                    selected: _selectedDestination == 6,
                    selectedColor: selectedColor,
                    onTap: () async {
                      filter.clear();
                      filter.addAll(webFileExtensions);
                      final files =
                          await getFilesInFolder(true, selectedDirectory);
                      setState(() {
                        imageGridType = false;
                        imageGridButton = false;
                        onlyFolders = false;
                        _files = files;
                      });
                      selectDestination(6);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    textColor: nightMode ? subtextColorDark : null,
                    leading: const Icon(Icons.app_registration_rounded),
                    title: const Text('Uygulamalar'),
                    selected: _selectedDestination == 7,
                    selectedColor: selectedColor,
                    onTap: () async {
                      filter.clear();
                      filter.addAll(applicationsExtensions);
                      final files =
                          await getFilesInFolder(true, selectedDirectory);
                      setState(() {
                        imageGridType = false;
                        imageGridButton = false;
                        onlyFolders = false;
                        _files = files;
                      });
                      selectDestination(7);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    textColor: nightMode ? subtextColorDark : null,
                    leading: const Icon(Icons.folder),
                    title: const Text('Sadece Klasörler'),
                    selected: _selectedDestination == 8,
                    selectedColor: selectedColor,
                    onTap: () {
                      setState(() {
                        imageGridType = false;
                        imageGridButton = false;
                        onlyFolders = true;
                        onlyFiles = false;
                      });
                      selectDestination(8);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
          const VerticalDivider(
            width: 1,
            thickness: 1,
          ),
          const SizedBox(
            width: 50,
          ),
          DrawerSettingsContainer(
            nightMode: nightMode,
            selectedFolderShowPress: () {
              showNowDirectory(false);
            },
            selectedFolderNowPress: () {
              showNowDirectory(true);
            },
            selectedDirectory: selectedDirectory,
            nowDirectory: nowDirectory,
            animatedContainerOnEnd: () {
              //animatedContainerOnEnd
              if (isLoadMoreSettings) {
                setState(() {
                  isLoadComponent = true;
                });
              }
            },
            isLoadMoreSettings: isLoadMoreSettings,
            isLoadComponent: isLoadComponent,
            easyClickOpenFolder: easyClickOpenFolder,
            easyOpenFolderPress: () {
              //easyOpenFolderPress
              setState(() {
                if (easyClickOpenFolder) {
                  easyClickOpenFolder = false;
                } else {
                  easyClickOpenFolder = true;
                }
              });
            },
            easyClickOpenFile: easyClickOpenFile,
            easyOpenFilePress: () {
              //easyOpenFilePress
              setState(() {
                if (easyClickOpenFile) {
                  easyClickOpenFile = false;
                } else {
                  easyClickOpenFile = true;
                }
              });
            },
            historyList: historyList,
            loadMoreSettingsPress: () {
              //loadMoreSettingsPress
              setState(() {
                if (!isLoadMoreSettings) {
                  isLoadMoreSettings = true;
                } else {
                  isLoadComponent = false;
                  isLoadMoreSettings = false;
                }
              });
            },
          )
        ],
      ),
    );
  }

  void selectDestination(int index) {
    setState(() {
      _selectedDestination = index;
    });
  }

  int whichImage(String ext) {
    int imageIndex = 5;
    switch (ext) {
      case "css":
        imageIndex = 2;
        break;
      case "dll":
        imageIndex = 3;
        break;
      case "doc":
        imageIndex = 24;
        break;
      case "exe":
        imageIndex = 6;
        break;
      case "html":
        imageIndex = 8;
        break;
      case "java":
        imageIndex = 10;
        break;
      case "jpg":
        imageIndex = 11;
        break;
      case "json":
        imageIndex = 12;
        break;
      case "pdf":
        imageIndex = 15;
        break;
      case "png":
        imageIndex = 16;
        break;
      case "ps":
        imageIndex = 17;
        break;
      case "py":
        imageIndex = 18;
        break;
      case "rar":
        imageIndex = 19;
        break;
      case "txt":
        imageIndex = 20;
        break;
      case ".avi":
      case ".mp4":
      case ".wmv":
      case ".mkv":
        imageIndex = 22;
        break;
      case "docx":
        imageIndex = 24;
        break;
      case "xls":
        imageIndex = 25;
        break;
      case "xml":
        imageIndex = 26;
        break;
      case "zip":
        imageIndex = 27;
        break;
    }
    if (audioExtension.contains(ext)) {
      imageIndex = 1;
    }
    if (unityExtensions.contains(ext)) {
      imageIndex = 21;
    }
    return imageIndex;
  }
}
