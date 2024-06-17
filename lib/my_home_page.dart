import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mad_project/providers/files.dart';
import 'package:mad_project/models/file_object.dart';
import 'package:mad_project/recent_files.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.files});
  final List<FileObject> files;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  String? deletedFilePath;
  late Uint8List contents;

  @override
  Widget build(BuildContext context) {
    // final widget.files = ref.watch(filesProvider);
    if (widget.files.isEmpty) {
      return Center(
          child: Text(
        "Add some widget.files here!",
        style: Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer),
      ));
    }
    return Scaffold(
      body: ListView.builder(
        itemCount: widget.files.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: ValueKey(widget.files[index].fileName),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              if (direction == DismissDirection.endToStart) {
                final deletedDoc = widget.files[index];
                setState(() {
                  deletedFilePath = deletedDoc.filePath;
                  File f = File(deletedFilePath!);
                  contents = f.readAsBytesSync();
                  ref.read(filesProvider.notifier).removeDoc(deletedDoc);
                });
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text('Doc has been deleted'),
                    duration: const Duration(seconds: 4),
                    action: SnackBarAction(
                      label: "Undo",
                      onPressed: () {
                        setState(() {
                          ref
                              .read(filesProvider.notifier)
                              .insertDoc(index, deletedDoc, contents);
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
