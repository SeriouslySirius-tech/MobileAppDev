import 'package:flutter/material.dart';
import 'package:mad_project/models/file_object.dart';

class RecentFiles extends StatelessWidget {
  final FileObject file;
  final void Function(FileObject f) onPress;

  const RecentFiles({super.key, required this.file, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: ListTile(
          leading: const Icon(Icons.picture_as_pdf),
          title: Text(
            file.fileName,
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: Theme.of(context).colorScheme.onSecondaryContainer),
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            "Created on ${file.date}",
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: Theme.of(context).colorScheme.onSecondaryContainer),
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            icon: const Icon(Icons.favorite_outline),
            onPressed: () => onPress(file),
          )),
    );
  }
}

      // child: Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: Row(
      //     children: [
      //       Expanded(
      //         child: Text(
      //           fileName,
      //           style: Theme.of(context).textTheme.titleSmall!.copyWith(
      //               color: Theme.of(context).colorScheme.onSecondaryContainer),
      //         ),
      //       ),
      //       Expanded(
      //         child: Text(
      //           date,
      //           style: Theme.of(context).textTheme.titleSmall!.copyWith(
      //               color: Theme.of(context).colorScheme.onSecondaryContainer),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),