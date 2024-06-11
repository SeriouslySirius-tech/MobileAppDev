import 'package:flutter/material.dart';
import 'package:mad_project/models/file_object.dart';
import 'package:mad_project/my_home_page.dart';

class FavouritesPage extends StatelessWidget {
  const FavouritesPage({super.key, required this.files, required this.onPress});
  final List<FileObject> files;
  final void Function(FileObject f) onPress;
  @override
  Widget build(BuildContext context) {
    // return Text(
    //   "Favourties fn",
    //   style: Theme.of(context)
    //       .textTheme
    //       .titleLarge!
    //       .copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer),
    // );
    return MyHomePage(
      files: files,
      onFavouritePress: onPress,
    );
  }
}
