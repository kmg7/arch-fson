import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';

import '../../../gen/translations.g.dart';
import '../model/upload_file_model.dart';

class UploadView extends StatefulWidget {
  const UploadView({
    Key? key,
    required this.changeUploadList,
    required this.files,
    required this.upload,
  }) : super(key: key);
  final Function(FileToUpload, bool) changeUploadList;
  final List<FileToUpload> files;
  final Function(FileToUpload) upload;
  @override
  State<UploadView> createState() => _UploadViewState();
}

class _UploadViewState extends State<UploadView> {
  late DropzoneViewController controller1;
  bool dzoneHighlited = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - 150,
        color: dzoneHighlited ? Colors.blue.shade100 : Colors.white,
        child: dropzone(),
      ),
      Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox.shrink(),
              Text(t.message.room.upload),
              SizedBox(
                  width: 60,
                  child: ElevatedButton(
                      onPressed: () async {
                        await extract(await controller1.pickFiles(multiple: true), widget.changeUploadList);
                        setState(() {});
                      },
                      child: const Icon(Icons.drive_folder_upload_outlined)))
            ],
          ),
          ...widget.files
              .map(
                (e) => Row(
                  children: [
                    InkWell(
                      onTap: () {
                        widget.changeUploadList(e, false);
                        setState(() {});
                      },
                      child: const Icon(Icons.close_outlined),
                    ),
                    Text(e.name),
                    const Spacer(),
                    Text(e.readableSize),
                    TextButton(
                        onPressed: () {
                          // widget.onDownload(widget.model.path);
                          widget.upload(e);
                        },
                        child: const Icon(Icons.upload_outlined))
                  ],
                ),
              )
              .toList(),
        ],
      ),
    ]);
  }

  Future<void> extract(dynamic files, Function(FileToUpload, bool) filesToUpload) async {
    try {
      for (var file in files) {
        final name = await controller1.getFilename(file);
        // final bytes = await controller1.getFileData(file);
        final size = await controller1.getFileSize(file);
        List<int> data = [];
        controller1.getFileStream(file).listen((bytes) {
          for (int byte in bytes) {
            data.add(byte);
          }
        });
        filesToUpload(FileToUpload(name: name, size: size, bytes: data), true);
      }
    } catch (e) {
      print(e);
    }
    return;
  }

  Widget dropzone() => DropzoneView(
        operation: DragOperation.copy,
        onCreated: (ctrl) => controller1 = ctrl,
        onError: (ev) => {
          // if (kDebugMode) {print('DropZone error: $ev')}
        },
        onHover: () {
          setState(() => dzoneHighlited = true);
        },
        onLeave: () {
          setState(() => dzoneHighlited = false);
        },
        onDropMultiple: (ev) async {
          setState(() => dzoneHighlited = false);
          if (ev != null) {
            await extract(ev, widget.changeUploadList);
          }
        },
      );
}
