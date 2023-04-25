import 'package:flutter/material.dart';

import '../model/download_file_model.dart';

class DownloadView extends StatefulWidget {
  const DownloadView(
      {Key? key, required this.model, required this.changeDownloadList, required this.onDownload, required this.path, this.expanded = false})
      : super(key: key);
  final FileDirectory model;
  final Function(FileToDownload, bool?) changeDownloadList;
  final Function(String) onDownload;
  final List<String> path;
  final bool expanded;

  @override
  State<DownloadView> createState() => _DownloadViewState();
}

class _DownloadViewState extends State<DownloadView> {
  bool expanded = false;
  var selectAll = false;
  @override
  void initState() {
    expanded = widget.expanded;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Checkbox(
                value: widget.model.selected,
                onChanged: (bool? val) {
                  if (val != null) {
                    selectAll = val;
                    widget.model.selectAll(val, func: widget.changeDownloadList);
                    setState(() {});
                  }
                }),
            InkWell(
                onTap: () {
                  expanded = !expanded;
                  setState(() {});
                },
                child: Icon(expanded ? Icons.folder_open_outlined : Icons.folder)),
            Text(widget.model.name ?? '/'),
          ],
        ),
        if (expanded && widget.model.subdirs != null)
          ...widget.model.subdirs!.map(
            (e) => Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
              child: DownloadView(
                path: [...widget.path, widget.model.name!],
                model: e,
                changeDownloadList: widget.changeDownloadList,
                onDownload: widget.onDownload,
              ),
            ),
          ),
        if (expanded && widget.model.files != null)
          ...widget.model.files!.map((e) => Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                child: FileTile(
                  path: [...widget.path, widget.model.name!],
                  model: e,
                  changeDownloadList: widget.changeDownloadList,
                  onDownload: widget.onDownload,
                ),
              )),
      ],
    );
  }
}

class FileTile extends StatefulWidget {
  const FileTile({
    Key? key,
    required this.model,
    required this.changeDownloadList,
    required this.onDownload,
    required this.path,
  }) : super(key: key);
  final FileToDownload model;
  final Function(FileToDownload, bool?) changeDownloadList;
  final Function(String) onDownload;
  final List<String> path;

  @override
  State<FileTile> createState() => _FileTileState();
}

class _FileTileState extends State<FileTile> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
            value: widget.model.selected,
            onChanged: (bool? val) {
              if (val != null) {
                widget.model.selected = val;
                widget.changeDownloadList(widget.model, val);
                setState(() {});
              }
            }),
        const Icon(Icons.file_present_outlined),
        Text(widget.model.name),
        const Spacer(),
        Text(widget.model.size),
        TextButton(
            onPressed: () {
              widget.onDownload(widget.model.path);
            },
            child: const Icon(Icons.download_sharp))
      ],
    );
  }
}
