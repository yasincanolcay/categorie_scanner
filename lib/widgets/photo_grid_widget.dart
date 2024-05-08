// ignore_for_file: avoid_unnecessary_containers

import 'dart:io';
import 'package:categorie_scanner/utils/colors.dart';
import 'package:categorie_scanner/utils/global.dart';
import 'package:flutter/material.dart';

class PhotoGridView extends StatefulWidget {
  final List<FileSystemEntity> filesPaths;
  const PhotoGridView({Key? key, required this.filesPaths}) : super(key: key);
  @override
  State<PhotoGridView> createState() => _PhotoGridViewState();
}

class _PhotoGridViewState extends State<PhotoGridView> {
  final List<String> imagePaths = [];
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    getOnlyImagePaths();
    super.initState();
  }

  void getOnlyImagePaths() {
    setState(() {
      isLoading = true;
    });
    for (int i = 0; i < widget.filesPaths.length; i++) {
      final file = widget.filesPaths[i];
      final name = file.path.split('/').last;
      final extension = name.split('.').last;
      if (imgExtensions.contains(extension)) {
        imagePaths.add(file.path);
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  void openImage(String path) {
    showDialog(
        context: context,
        builder: (context) {
          return Material(
            type: MaterialType.transparency,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  child: FadeInImage(
                    fit: BoxFit.contain,
                    placeholder: const AssetImage('assets/images/loading.gif'),
                    image: FileImage(
                      File(
                        path,
                      ),
                    ),
                    imageErrorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.error_rounded,
                        color: themeColorLight,
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return !isLoading
        ? GridView.builder(
            shrinkWrap: true,
            itemCount: imagePaths.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 5,
              mainAxisSpacing: 1.5,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  openImage(imagePaths[index]);
                },
                child: Container(
                  child: FadeInImage(
                    fit: BoxFit.cover,
                    placeholder: const AssetImage('assets/images/loading.gif'),
                    image: FileImage(
                      File(
                        imagePaths[index],
                      ),
                    ),
                    imageErrorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.error_rounded,
                        color: themeColorLight,
                      );
                    },
                  ),
                ),
              );
            },
          )
        : const Center(
            child: CircularProgressIndicator(color: themeColorLight),
          );
  }
}
