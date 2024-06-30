import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:mad_project/models/file_object.dart';

class FileDisplayWidget extends StatefulWidget {
  final FileObject file; // Path to the file (asset or external storage)

  const FileDisplayWidget({super.key, required this.file});

  @override
  State<FileDisplayWidget> createState() => _FileDisplayWidgetState();
}

class _FileDisplayWidgetState extends State<FileDisplayWidget> {
  Future<String>? _localFilePath;

  @override
  void initState() {
    super.initState();
    _localFilePath = _getFilePath(widget.file.filePath);
  }

  Future<String> _getFilePath(String filePath) async {
    if (filePath.startsWith('assets/')) {
      final byteData = await rootBundle.load(filePath);
      final buffer = byteData.buffer;
      final tempDir = await getTemporaryDirectory();
      final tempFilePath = '${tempDir.path}/${widget.file.fileName}';
      final file = await File(tempFilePath).writeAsBytes(
          buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
      return file.path;
    } else {
      return filePath;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _localFilePath,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                title: Text(widget.file.fileName),
                titleTextStyle: Theme.of(context)
                    .primaryTextTheme
                    .titleLarge!
                    .copyWith(
                        color:
                            Theme.of(context).colorScheme.onPrimaryContainer),
              ),
              body: PDFView(
                filePath: widget.file.filePath,
                nightMode: true,
              ),
            );
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text('Error: ${snapshot.error}'),
              ),
            );
          }
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
