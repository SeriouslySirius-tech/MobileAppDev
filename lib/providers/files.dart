import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mad_project/models/file_object.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat('dd-MM-yy HH:mm');

class FilesNotifier extends StateNotifier<List<FileObject>> {
  FilesNotifier() : super([]) {
    initState();
  }

  void initState() async {
    final directoryPath = await getApplicationDocumentsDirectory();
    final newDirectory = Directory('${directoryPath.path}/example_directory');

    // Create the new directory if it does not exist
    if (!await newDirectory.exists()) {
      await newDirectory.create(recursive: true);
    }

    // Create some files within the new directory
    for (int i = 1; i <= 3; i++) {
      final file = File('${newDirectory.path}/file_$i.txt');
      await file.writeAsString('This is file number $i');
    }

    // List all files in the directory and store FileInfo objects
    await for (var entity
        in newDirectory.list(recursive: false, followLinks: false)) {
      if (entity is File) {
        state = [
          ...state,
          FileObject(
              fileName: entity.uri.pathSegments.last,
              filePath: entity.path,
              date: formatter.format(DateTime.now()))
        ];
      }
    }
  }
}

final filesProvider =
    StateNotifierProvider<FilesNotifier, List<FileObject>>((ref) {
  return FilesNotifier();
});
