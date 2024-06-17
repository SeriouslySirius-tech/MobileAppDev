import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mad_project/models/file_object.dart';
import 'package:mad_project/recent_files.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.files});
  final List<FileObject> files;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  File? deletedFile;
  String? contents;
  Future<void> deleteFile(FileObject f) async {
    final file = File(f.filePath);
    deletedFile = file;
    contents = await file.readAsString().then((String text) => contents = text);
    await file.delete();
  }

  Future<void> undoDeletion() async {
    if (deletedFile != null) {
      await deletedFile!.create(recursive: true); // Recreate the file
      deletedFile!.writeAsString(contents!);
      deletedFile = null; // Clear deletedFile after undo
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.files.isEmpty) {
      return Center(
          child: Text(
        "Add some files here!",
        style: Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer),
      ));
    }
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        itemCount: widget.files.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: ValueKey(widget.files[index].fileName),
            onDismissed: (direction) {
              if (direction == DismissDirection.endToStart) {
                final deletedDoc = widget.files[index];
                setState(() {
                  widget.files.remove(deletedDoc);
                  deleteFile(deletedDoc);
                });
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text('Doc has been deleted'),
                    duration: const Duration(seconds: 4),
                    action: SnackBarAction(
                      label: "Undo",
                      onPressed: () {
                        setState(() {
                          widget.files.insert(index, deletedDoc);
                          undoDeletion();
                        });
                      },
                    )));
              }
            },
            child: RecentFiles(
              file: widget.files[index],
            ),
          );
        },
      ),
    );
  }
}
