import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../gen/translations.g.dart';
import '../../../utils/auth/auth_manager.dart';
import '../../../utils/widget/app_bar.dart';
import '../model/room_model.dart';
import '../view_model/room_view_model.dart';
import 'download_view.dart';
import 'upload_view.dart';

class RoomView extends StatefulWidget {
  const RoomView({
    Key? key,
  }) : super(key: key);

  @override
  State<RoomView> createState() => _RoomViewState();
}

class _RoomViewState extends State<RoomView> {
  late final RoomViewModel _viewModel;

  RoomModel room = AuthManager.instance.room!;

  @override
  void initState() {
    _viewModel = RoomViewModel(room: room);
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
                          child: Text(t.action.room.download))),
                  Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            _viewModel.mode = false;
                          },
                          style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.zero)),
                              padding: EdgeInsets.zero,
                              backgroundColor: Colors.green),
                          child: Text(t.action.room.upload))),
                ],
              ),
              Card(
                  // color: const Color(0xffE96479),
                  child: SizedBox(
                      height: 40,
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Card(
                          color: _viewModel.hostOnline ? Colors.lightGreen : Colors.red,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [Card(child: Icon(_viewModel.hostOnline ? Icons.wifi_outlined : Icons.wifi_off_outlined)), Text(room.code)],
                            ),
                          ),
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
                      : _viewModel.hostOnline
                          ? _viewModel.mode
                              ? (_viewModel.availableFiles != null)
                                  ? SingleChildScrollView(
                                      child: DownloadView(
                                        path: const [],
                                        model: _viewModel.availableFiles!,
                                        changeDownloadList: _viewModel.changeDownloadList,
                                        onDownload: _viewModel.download,
                                        expanded: true,
                                      ),
                                    )
                                  : const Center(child: Text('Host not provided any file yet'))
                              : UploadView(changeUploadList: _viewModel.changeUploadList, files: _viewModel.filesToUpload)
                          : const Text('Host not online')),
              // const Spacer(),
            ],
          ),
        ),
        // bottomNavigationBar: UploadView(addUploadFiles: _viewModel.pushAllUploadList),
      ),
    );
  }
}
