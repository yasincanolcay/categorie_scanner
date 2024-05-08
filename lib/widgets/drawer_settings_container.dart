// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:categorie_scanner/utils/colors.dart';
import 'package:flutter/material.dart';

class DrawerSettingsContainer extends StatefulWidget {
  final nightMode;
  final VoidCallback selectedFolderShowPress;
  final VoidCallback selectedFolderNowPress;
  final selectedDirectory;
  final nowDirectory;
  final VoidCallback animatedContainerOnEnd;
  final isLoadMoreSettings;
  final isLoadComponent;
  final easyClickOpenFolder;
  final VoidCallback easyOpenFolderPress;
  final easyClickOpenFile;
  final VoidCallback easyOpenFilePress;
  final historyList;
  final VoidCallback loadMoreSettingsPress;
  const DrawerSettingsContainer({
    Key? key,
    required this.nightMode,
    required this.selectedFolderShowPress,
    required this.selectedFolderNowPress,
    required this.selectedDirectory,
    required this.nowDirectory,
    required this.animatedContainerOnEnd,
    required this.isLoadMoreSettings,
    required this.isLoadComponent,
    required this.easyClickOpenFolder,
    required this.easyOpenFolderPress,
    required this.easyClickOpenFile,
    required this.easyOpenFilePress,
    required this.historyList,
    required this.loadMoreSettingsPress,
  }) : super(key: key);

  @override
  State<DrawerSettingsContainer> createState() =>
      _DrawerSettingsContainerState();
}

class _DrawerSettingsContainerState extends State<DrawerSettingsContainer> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  height: 80,
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: !widget.nightMode
                        ? themeBackColorLight
                        : themeBackColorDark,
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                  ),
                  child: ListTile(
                    onTap: widget.selectedFolderShowPress,
                    textColor:
                        !widget.nightMode ? textColorLight : textColorDark,
                    title: const Text("Seçilen Klasör"),
                    leading: const Icon(Icons.folder),
                    subtitle: Text(
                      widget.selectedDirectory,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: !widget.nightMode
                            ? subtextColorLight
                            : subtextColorDark,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 80,
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: !widget.nightMode
                        ? themeBackColorLight
                        : themeBackColorDark,
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                  ),
                  child: ListTile(
                    onTap: widget.selectedFolderNowPress,
                    textColor:
                        !widget.nightMode ? textColorLight : textColorDark,
                    title: const Text("Buradasınız"),
                    leading: const Icon(Icons.folder),
                    subtitle: Text(
                      widget.nowDirectory,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: !widget.nightMode
                            ? subtextColorLight
                            : subtextColorDark,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          AnimatedContainer(
            onEnd: widget.animatedContainerOnEnd,
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(20),
            duration: const Duration(milliseconds: 500),
            width: double.infinity,
            height: widget.isLoadMoreSettings ? 300 : 0,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              color:
                  !widget.nightMode ? themeBackColorLight : themeBackColorDark,
            ),
            child: widget.isLoadComponent
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Card(
                          color: !widget.nightMode
                              ? themeBackColorLight
                              : themeColorDark,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Klasörleri tek tıkla açın",
                                  style: TextStyle(
                                      color: !widget.nightMode
                                          ? textColorLight
                                          : textColorDark),
                                ),
                                Switch(
                                    activeColor: Colors.amber,
                                    value: widget.easyClickOpenFolder,
                                    onChanged: (vl) {
                                      widget.easyOpenFolderPress.call();
                                    }),
                                const SizedBox(
                                  width: 30,
                                ),
                                Text("Dosyaları tek tıkla açın",
                                    style: TextStyle(
                                        color: !widget.nightMode
                                            ? textColorLight
                                            : textColorDark)),
                                Switch(
                                    activeColor: Colors.amber,
                                    value: widget.easyClickOpenFile,
                                    onChanged: (vl) {
                                      widget.easyOpenFilePress.call();
                                    }),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "En Son İşlemler",
                          style: TextStyle(
                            color: !widget.nightMode
                                ? textColorLight
                                : textColorDark,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 150,
                          child: ListView.builder(
                            itemCount: widget.historyList.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                textColor:
                                    widget.nightMode ? subtextColorDark : null,
                                leading: const Icon(Icons.history),
                                title: Text(widget.historyList[index]),
                              );
                            },
                          ),
                        )
                      ])
                : const SizedBox(),
          ),
          IconButton(
              onPressed: widget.loadMoreSettingsPress,
              icon: Icon(
                !widget.isLoadMoreSettings
                    ? Icons.arrow_downward_outlined
                    : Icons.arrow_upward_outlined,
                color: !widget.nightMode ? Colors.white : themeIconColor,
              ))
        ],
      ),
    );
  }
}
