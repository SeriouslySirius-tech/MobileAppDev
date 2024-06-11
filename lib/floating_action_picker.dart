import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class FloatingActionPicker extends StatelessWidget {
  const FloatingActionPicker({super.key});
  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      icon: Icons.add,
      activeIcon: Icons.close,
      children: [
        SpeedDialChild(
            child: const Icon(Icons.camera_alt_outlined),
            // backgroundColor: Colors.green,
            // foregroundColor: Colors.white,
            label: 'Capture Image',
            labelStyle: Theme.of(context)
                .textTheme
                .labelMedium!
                .copyWith(color: Theme.of(context).colorScheme.inverseSurface)
            // onTap: _captureImage,
            ),
        SpeedDialChild(
          child: const Icon(Icons.file_copy_outlined),
          // backgroundColor: Colors.orange,
          // foregroundColor: Colors.white,
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
