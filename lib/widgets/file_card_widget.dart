// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:categorie_scanner/utils/colors.dart';
import 'package:categorie_scanner/utils/global.dart';
import 'package:flutter/material.dart';

class FileCardWidget extends StatefulWidget {
  final List<String> filter;
  final file;
  final name;
  final extension;
  final onlyFolders;
  final nightMode;
  final easyClickOpenFile;
  final imgIndex;
  final VoidCallback cardPress;
  final VoidCallback popupItem1Press;
  final VoidCallback popupItem2Press;
  final VoidCallback popupItem3Press;
  final VoidCallback popupItem4Press;
  final VoidCallback popupItem5Press;
  const FileCardWidget({
    Key? key,
    required this.filter,
    required this.file,
    required this.name,
    required this.extension,
    required this.onlyFolders,
    required this.nightMode,
    required this.easyClickOpenFile,
    required this.imgIndex,
    required this.cardPress,
    required this.popupItem1Press,
    required this.popupItem2Press,
    required this.popupItem3Press,
    required this.popupItem4Press,
    required this.popupItem5Press,
  }) : super(key: key);

  @override
  State<FileCardWidget> createState() => _FileCardWidgetState();
}

class _FileCardWidgetState extends State<FileCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0),
      child: widget.filter.contains("all") ||
              widget.filter.contains(widget.extension) ||
              widget.filter.contains(widget.file.path) ||
              widget.filter.contains(widget.name)
          ? SizedBox(
              child: !widget.onlyFolders
                  ? ListTile(
                      tileColor: !widget.nightMode
                          ? themeBackColorLight
                          : themeBackColorDark,
                      textColor:
                          !widget.nightMode ? textColorLight : textColorDark,
                      onTap: widget.cardPress,
                      title: Text(widget.name),
                      subtitle: Text(
                        widget.file.path,
                        style: TextStyle(
                            color: !widget.nightMode
                                ? subtextColorLight
                                : subtextColorDark),
                      ),
                      leading: Image.asset(allImagePath[widget.imgIndex]),
                      trailing: PopupMenuButton(
                        child: CircleAvatar(
                          backgroundColor: !widget.nightMode
                              ? themeColorLight
                              : themeColorDark,
                          child: const Icon(Icons.more_horiz),
                        ),
                        itemBuilder: (context) {
                          return <PopupMenuItem>[
                            PopupMenuItem(
                              child: ListTile(
                                onTap: widget.popupItem1Press,
                                leading: const Icon(Icons.folder_open_rounded),
                                title: const Text("Klasöre Git"),
                              ),
                            ),
                            PopupMenuItem(
                              child: ListTile(
                                onTap: widget.popupItem2Press,
                                leading: const Icon(Icons.open_in_full_rounded),
                                title: const Text("Klasörü Aç"),
                              ),
                            ),
                            PopupMenuItem(
                              child: ListTile(
                                onTap: widget.popupItem3Press,
                                leading: const Icon(Icons.open_in_full_rounded),
                                title: const Text("Dosyayı Aç"),
                              ),
                            ),
                            widget.extension == "pdf" ||
                                    widget.extension == "doc" ||
                                    widget.extension == "docx"
                                ? PopupMenuItem(
                                    child: ListTile(
                                      onTap: widget.popupItem4Press,
                                      leading: const Icon(Icons.open_in_full_rounded),
                                      title: const Text("Ön İzle"),
                                    ),
                                  )
                                : const PopupMenuItem(
                                    enabled: false,
                                    height: 0,
                                    child: SizedBox()),
                            PopupMenuItem(
                              child: ListTile(
                                onTap: widget.popupItem5Press,
                                leading: const Icon(Icons.delete_rounded),
                                title: const Text("Sil"),
                              ),
                            ),
                          ];
                        },
                      ),
                    )
                  : null,
            )
          : const SizedBox(),
    );
  }
}
