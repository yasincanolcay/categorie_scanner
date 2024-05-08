// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:categorie_scanner/utils/colors.dart';
import 'package:flutter/material.dart';

class FolderCardWidget extends StatefulWidget {
  final VoidCallback cardPress;
  final easyClickOpenFolder;
  final nightMode;
  final file;
  final VoidCallback popupPress1;
  final VoidCallback popupPress2;
  final VoidCallback popupPress3;


  const FolderCardWidget({Key? key,
  required this.cardPress,
  required this.easyClickOpenFolder,
  required this.nightMode,
  required this.file,
  required this.popupPress1,
  required this.popupPress2,
  required this.popupPress3,
  }) : super(key: key);

  @override
  State<FolderCardWidget> createState() => _FolderCardWidgetState();
}

class _FolderCardWidgetState extends State<FolderCardWidget> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: widget.cardPress,
      tileColor: !widget.nightMode ? themeBackColorLight : themeBackColorDark,
      textColor: !widget.nightMode ? textColorLight : textColorDark,
      title: Text(widget.file.path),
      leading: const Icon(
        Icons.folder,
        color: Colors.amber,
      ),
      trailing: PopupMenuButton(
        child: CircleAvatar(
          backgroundColor: !widget.nightMode ? themeColorLight : themeColorDark,
          child: const Icon(Icons.more_horiz),
        ),
        itemBuilder: (context) {
          return <PopupMenuItem>[
            PopupMenuItem(
              child: ListTile(
                onTap:widget.popupPress1,
                leading: const Icon(Icons.folder_open_rounded),
                title: const Text("Klasöre Git"),
              ),
            ),
            PopupMenuItem(
              child: ListTile(
                onTap:widget.popupPress2,
                leading: const Icon(Icons.open_in_full_rounded),
                title: const Text("Klasörü Aç"),
              ),
            ),
            PopupMenuItem(
              child: ListTile(
                onTap: widget.popupPress3,
                leading: const Icon(Icons.delete_rounded),
                title: const Text("Sil"),
              ),
            ),
          ];
        },
      ),
    );
  }
}
