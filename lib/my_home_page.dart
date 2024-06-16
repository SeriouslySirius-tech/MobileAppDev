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
  // String formattedDate(DateTime date){
  @override
  Widget build(BuildContext context) {
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
