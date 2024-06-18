import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mad_project/models/file_object.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'dart:typed_data';

final formatter = DateFormat('dd-MM-yy HH:mm');

class FilesNotifier extends StateNotifier<List<FileObject>> {
  FilesNotifier() : super([]) {
    initState();
  }

  void initState() async {
    final directoryPath = await getApplicationDocumentsDirectory();
    final newDirectory = Directory('${directoryPath.path}/example_directory');

    state = [];

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

  Future<void> removeDoc(FileObject file) async {
    File f = File(file.filePath);
    state = state.where((element) => element != file).toList();
    await f.delete(recursive: true);
  }

  Future<void> insertDoc(int index, FileObject file, Uint8List contents) async {
    state = [...state]..insert(index, file);
    File f = File(file.filePath);
    await f.create();
    f.writeAsBytesSync(contents);
  }

  void addDoc(FileObject f) {
    state = [...state, f];
  }
}

final filesProvider =
    StateNotifierProvider<FilesNotifier, List<FileObject>>((ref) {
  return FilesNotifier();
});
