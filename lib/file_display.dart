import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle; // for assets
import 'dart:io';
import 'package:mad_project/models/file_object.dart'; // for external storage

class FileDisplayWidget extends StatefulWidget {
  final FileObject file; // Path to the file (asset or external storage)

  const FileDisplayWidget({super.key, required this.file});

  @override
  State<FileDisplayWidget> createState() => _FileDisplayWidgetState();
}

class _FileDisplayWidgetState extends State<FileDisplayWidget> {
  Future<String>? _fileContent;

  @override
  void initState() {
    super.initState();
    _fileContent = _readFile(widget.file.filePath);
  }

  Future<String> _readFile(String filePath) async {
    if (filePath.startsWith('assets/')) {
      return await rootBundle.loadString(filePath);
    } else {
      final file = File(filePath);
      return await file.readAsString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _fileContent,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final lines = snapshot.data!.split('\n');
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.file.fileName),
              titleTextStyle: Theme.of(context)
                  .primaryTextTheme
                  .titleLarge!
                  .copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer),
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lines.join('\n'),
                    style: Theme.of(context)
                        .primaryTextTheme
                        .bodyLarge!
                        .copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer),
                  ),
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
