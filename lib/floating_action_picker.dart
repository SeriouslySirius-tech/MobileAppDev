import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mad_project/models/file_object.dart';
import 'package:mad_project/providers/files.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf/widgets.dart' as pw;

class FloatingActionPicker extends ConsumerWidget {
  const FloatingActionPicker({super.key});

  Future<void> takePicture(context, ref) async {
    final imagePicker = ImagePicker();
    final XFile? pickedImage =
        await imagePicker.pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      final file = File(pickedImage.path);

      // Create a unique file name (optional)
      final DateTime date = DateTime.now();
      final uniqueFileName = '${date.toString()}.jpg';

      // Get the documents directory path
      final directory = await getApplicationDocumentsDirectory();
      final newPath =
          File('${directory.path}/example_directory/$uniqueFileName');

      // Move the captured image to the documents directory with a new name
      await file.copy(newPath.path);

      // You can access the saved image path here
      final savedImagePath = newPath.path;
      final FileObject f = FileObject(
          fileName: uniqueFileName,
          filePath: savedImagePath,
          date: formatter.format(date));
      ref.read(filesProvider.notifier).addDoc(f);

      // Display a snackbar to indicate successful capture (optional)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Image captured and saved successfully!'),
        ),
      );
    } else {
      // Display a snackbar if user cancels or closes the camera (optional)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Image capture cancelled.'),
        ),
      );
    }
  }

  Future<void> selectPicture(context, ref) async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();

    if (images.isNotEmpty) {
      final pdf = pw.Document();

      for (var image in images) {
        final imageFile = File(image.path);
        final imageBytes = await imageFile.readAsBytes();
        final pdfImage = pw.MemoryImage(imageBytes);

        pdf.addPage(
          pw.Page(
            build: (pw.Context context) {
              return pw.Center(
                child: pw.Image(pdfImage),
              );
            },
          ),
        );
      }

      // Get the application's document directory
      final directory = await getApplicationDocumentsDirectory();
      final DateTime date = DateTime.now();
      final uniqueFileName = '${date.toString()}.pdf';
      final file = File('${directory.path}/example_directory/$uniqueFileName');
      await file.writeAsBytes(await pdf.save());

      final filePath = file.path;
      final FileObject f = FileObject(
          fileName: uniqueFileName,
          filePath: filePath,
          date: formatter.format(date));
      ref.read(filesProvider.notifier).addDoc(f);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Image captured and saved successfully!'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Image capture cancelled.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SpeedDial(
      icon: Icons.add,
      activeIcon: Icons.close,
      children: [
        SpeedDialChild(
            onTap: () {
              takePicture(context, ref);
            },
            child: const Icon(Icons.camera_alt_outlined),
            label: 'Capture Image',
            labelStyle: Theme.of(context)
                .textTheme
                .labelMedium!
                .copyWith(color: Theme.of(context).colorScheme.inverseSurface)
            // onTap: _captureImage,
            ),
        SpeedDialChild(
          onTap: () {
            selectPicture(context, ref);
          },
          child: const Icon(Icons.file_copy_outlined),
          label: 'Select File',
          labelStyle: Theme.of(context)
              .textTheme
              .labelMedium!
              .copyWith(color: Theme.of(context).colorScheme.inverseSurface),
          // onTap: _selectFile,
        ),
      ],
    );
  }
}
