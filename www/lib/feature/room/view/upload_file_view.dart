import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'package:fson/feature/room/view_model/upload_file_view_model.dart';

import '../model/upload_file_model.dart';

class UploadFileTile extends StatefulWidget {
  const UploadFileTile({
    Key? key,
    required this.changeUploadList,
    required this.upload,
    required this.file,
    required this.parentSetState,
  }) : super(key: key);
  final Function(FileToUpload, bool) changeUploadList;
  final Function(FileToUpload, Function(double)) upload;
  final FileToUpload file;
  final VoidCallback parentSetState;
  @override
  State<UploadFileTile> createState() => _UploadFileTileState();
}

class _UploadFileTileState extends State<UploadFileTile> {
  final _viewModel = UploadFileViewModel();
  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) => Row(
        children: [
          InkWell(
            onTap: () {
              widget.changeUploadList(widget.file, false);
              widget.parentSetState();
            },
            child: const Icon(Icons.close_outlined),
          ),
          Text(widget.file.fixedName),
          const Spacer(),
          Text(widget.file.readableSize),
          const SizedBox(width: 4),
          SizedBox(
            width: 64,
            child: _viewModel.uploadAmount == 0
                ? TextButton(
                    onPressed: () {
                      widget.upload(widget.file, _viewModel.updateUploadAmount);
                    },
                    child: const Icon(Icons.upload_outlined))
                : Stack(alignment: AlignmentDirectional.center, children: [
                    SizedBox(
                        height: 14,
                        child: LinearProgressIndicator(
                          value: _viewModel.uploadAmount,
                        )),
                    Center(child: Text(_viewModel.amountPercent)),
                  ]),
          ),
        ],
      ),
    );
  }
}
