import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../utils/auth/auth_manager.dart';
import '../../../utils/widget/app_bar.dart';
import '../model/transfer_room_model.dart';
import '../view_model/transfer_view_model.dart';
import 'download_view.dart';
import 'upload_view.dart';

class TransferView extends StatefulWidget {
  const TransferView({
    Key? key,
  }) : super(key: key);

  @override
  State<TransferView> createState() => _TransferViewState();
}

class _TransferViewState extends State<TransferView> {
  late final TransferViewModel _viewModel;

  TransferRoomModel room = AuthManager.instance.room!;

  @override
  void initState() {
    _viewModel = TransferViewModel(room: room);
    _viewModel.refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) => Scaffold(
        appBar: CommonWidgets.appbar(context),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            _viewModel.mode = true;
                          },
                          style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.zero)),
                              padding: EdgeInsets.zero,
                              backgroundColor: Colors.blue),
                          child: const Text('İndir'))),
                  Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            _viewModel.mode = false;
                          },
                          style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.zero)),
                              padding: EdgeInsets.zero,
                              backgroundColor: Colors.green),
                          child: const Text('Yükle'))),
                ],
              ),
              Card(
                  // color: const Color(0xffE96479),
                  child: SizedBox(
                      height: 40,
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [const Icon(Icons.adjust_rounded), Text('Room Code: ${room.code}')],
                        ),
                        Row(
                          children: [
                            if (_viewModel.mode)
                              SizedBox(
                                width: 30,
                                height: 30,
                                child: ElevatedButton(
                                  onPressed: () {
                                    _viewModel.downloadSelected();
                                  },
                                  style: const ButtonStyle(
                                      padding: MaterialStatePropertyAll(EdgeInsets.zero), backgroundColor: MaterialStatePropertyAll(Colors.blue)),
                                  child: const Icon(Icons.downloading_rounded),
                                ),
                              ),
                            if (!_viewModel.mode)
                              SizedBox(
                                width: 30,
                                height: 30,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await _viewModel.upload();
                                  },
                                  style: const ButtonStyle(
                                      padding: MaterialStatePropertyAll(EdgeInsets.zero), backgroundColor: MaterialStatePropertyAll(Colors.green)),
                                  child: const Icon(Icons.cloud_upload_outlined),
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8),
                              child: SizedBox(
                                width: 30,
                                height: 30,
                                child: ElevatedButton(
                                  style: const ButtonStyle(
                                      padding: MaterialStatePropertyAll(EdgeInsets.zero), backgroundColor: MaterialStatePropertyAll(Colors.amber)),
                                  onPressed: () async {
                                    await _viewModel.refresh();
                                  },
                                  child: const Icon(Icons.refresh_rounded),
                                ),
                              ),
                            )
                          ],
                        )
                      ]))),

              Padding(
                padding: const EdgeInsetsDirectional.only(bottom: 16, start: 16, top: 0, end: 16),
                child: _viewModel.isLoading
                    ? CommonWidgets.progressIndicator
                    : (_viewModel.availableFiles != null)
                        ? _viewModel.mode
                            ? SingleChildScrollView(
                                child: DownloadView(
                                  path: const [],
                                  model: _viewModel.availableFiles!,
                                  changeDownloadList: _viewModel.changeDownloadList,
                                  onDownload: _viewModel.download,
                                  expanded: true,
                                ),
                              )
                            : UploadView(changeUploadList: _viewModel.changeUploadList, files: _viewModel.filesToUpload)
                        : const Center(child: Text('Host not provided any file yet')),
              ),
              // const Spacer(),
            ],
          ),
        ),
        // bottomNavigationBar: UploadView(addUploadFiles: _viewModel.pushAllUploadList),
      ),
    );
  }
}
