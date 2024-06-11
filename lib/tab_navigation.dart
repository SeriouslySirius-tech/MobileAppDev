import 'package:flutter/material.dart';
import 'package:mad_project/data/files.dart';
import 'package:mad_project/favourites_page.dart';
import 'package:mad_project/floating_action_picker.dart';
import 'package:mad_project/models/file_object.dart';
import 'package:mad_project/my_home_page.dart';

class TabNavigation extends StatefulWidget {
  const TabNavigation({super.key});

  @override
  State<TabNavigation> createState() {
    return _TabNavigationState();
  }
}

class _TabNavigationState extends State<TabNavigation> {
  int currentIndex = 0;
  final List<FileObject> favouriteDocs = [];

  void _showInfoMessage(String message, FileObject f, int index) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 2),
      content: Text(
        message,
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryFixed,
            ),
      ),
      action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            setState(() {
              favouriteDocs.insert(index, f);
            });
          }),
    ));
  }

  void isFavourite(FileObject f) {
    final isExisting = favouriteDocs.contains(f);
    final existingIndex = favouriteDocs.indexOf(f);

    if (isExisting) {
      setState(() {
        favouriteDocs.remove(f);
      });
      _showInfoMessage('Doc removed as a favorite.', f, existingIndex);
    } else {
      setState(() {
        favouriteDocs.add(f);
        _showInfoMessage(
            'Doc added as a favourite favorite!', f, existingIndex);
      });
    }
  }

  void selectPage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = MyHomePage(
      files: files,
      onFavouritePress: isFavourite,
    );
    var activePageTitle = "Recent Notes";

    if (currentIndex == 1) {
      activePage = FavouritesPage(
        files: favouriteDocs,
        onPress: isFavourite,
      );
      activePageTitle = "Favourites";
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      body: activePage,
      floatingActionButton: const FloatingActionPicker(),
      bottomNavigationBar: BottomNavigationBar(
        onTap: selectPage,
        currentIndex: currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.timelapse),
            label: 'Recent',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_rounded),
            label: "Favourites",
          ),
        ],
      ),
    );
  }
}
