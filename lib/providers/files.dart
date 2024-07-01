// import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mad_project/models/file_object.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
// import 'package:flutter/material.dart';

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
      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Text("This is file $i"),
            );
          },
        ),
      );
      // final uniqueFileName = formatter.format(DateTime.now());
      final file = File('${newDirectory.path}/file_$i.pdf');
      if (!await file.exists()) {
        await file.writeAsBytes(await pdf.save());
      }
    }

    await for (var entity
        in newDirectory.list(recursive: false, followLinks: false)) {
      if (entity is File) {
        FileObject f = FileObject(
          fileName: entity.uri.pathSegments.last,
          filePath: entity.path,
          date: formatter.format(DateTime.now()),
        );
        state = [...state, f];
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

//   Future<void> convertTextFileToPdf(FileObject file) async {
//     final textFile = File(file.filePath);
//     final textContentBytes = await textFile.readAsBytes();
//     final textContent = utf8.decode(textContentBytes);
//     final pdf = pw.Document();

//     pdf.addPage(
//       pw.Page(
//         build: (pw.Context context) {
//           return pw.Text(textContent);
//         },
//       ),
//     );

//     String pdfFilePath =
//         '${file.filePath.substring(0, file.filePath.lastIndexOf('.') + 1)}pdf';
//     final outputFile = File(pdfFilePath);
//     await outputFile.writeAsBytes(await pdf.save());
//     await textFile.delete();
//     // print('PDF file created at: $pdfFilePath');
//   }
// }
}

final filesProvider =
    StateNotifierProvider<FilesNotifier, List<FileObject>>((ref) {
  return FilesNotifier();
});
