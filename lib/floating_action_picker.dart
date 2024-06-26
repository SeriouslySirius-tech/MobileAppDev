import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mad_project/models/file_object.dart';
import 'package:mad_project/providers/aimodel.dart';
import 'package:mad_project/providers/files.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';

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
      final directory = await getTemporaryDirectory();
      final newPath = File('${directory.path}/$uniqueFileName');

      // Move the captured image to the documents directory with a new name
      await file.copy(newPath.path);

      // You can access the saved image path here
      final savedImagePath = newPath.path;
      final FileObject f = FileObject(
          fileName: uniqueFileName,
          filePath: savedImagePath,
          date: formatter.format(date));
      // ref.read(filesProvider.notifier).addDoc(f);
      final model = Model(file: f);
      model.generateSummaryforImages();

      // Display a snackbar to indicate successful capture (optional)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Image captured and analysed successfully!'),
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
      const List<FileObject> imageList = [];
      final directory = await getTemporaryDirectory();
      // Get the application's document directory
      for (int i = 0; i < images.length; i++) {
        final DateTime date = DateTime.now();
        final uniqueFileName = '${date.toString()}_${i + 1}.jpeg';
        final file = File('${directory.path}/$uniqueFileName');
        await file.writeAsBytes(await images[i].readAsBytes(), flush: true);
        imageList.add(FileObject(
            fileName: uniqueFileName,
            filePath: file.path,
            date: formatter.format(date)));
      }
      final model = Model(fileList: imageList);
      model.generateSummaryforImageList();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Images captured and analysed successfully'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Images captured failed'),
        ),
      );
    }
  }

  Future<void> selectFile(context, ref) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      FileObject f = FileObject(
          fileName: file.uri.pathSegments.last,
          filePath: file.path,
          date: formatter.format(DateTime.now()));
      final model = Model(file: f);
      model.generateSummaryforText();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('File captured and analysed successfully'),
        ),
      );
    } else {
      // User canceled the picker
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('File Selection cancelled.'),
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
            selectFile(context, ref);
          },
          child: const Icon(Icons.file_copy_outlined),
          label: 'Select File',
          labelStyle: Theme.of(context)
              .textTheme
              .labelMedium!
              .copyWith(color: Theme.of(context).colorScheme.inverseSurface),
          // onTap: _selectFile,
        ),
        SpeedDialChild(
          onTap: () {
            selectPicture(context, ref);
          },
          child: const Icon(Icons.image_outlined),
          label: 'Select Images',
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
