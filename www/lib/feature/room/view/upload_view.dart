import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:fson/feature/room/view/upload_file_view.dart';

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
  final Function(FileToUpload, Function(double)) upload;
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
          Row(
            children: [
              Text(t.title.room.file_name),
              const Spacer(),
              Text(t.title.room.file_size),
              const SizedBox(
                width: 68,
              )
            ],
          ),
          const Divider(color: Colors.grey),
          ...widget.files
              .map((e) => UploadFileTile(
                    changeUploadList: widget.changeUploadList,
                    file: e,
                    upload: widget.upload,
                    parentSetState: () => setState(() {}),
                  ))
              .toList(),
        ],
      ),
    ]);
  }

  Future<void> extract(dynamic files, Function(FileToUpload, bool) filesToUpload) async {
    try {
      for (var file in files) {
        final name = await controller1.getFilename(file);
        final size = await controller1.getFileSize(file);
        filesToUpload(FileToUpload(name: name, size: size, file: file), true);
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
