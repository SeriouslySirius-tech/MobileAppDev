import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mad_project/models/file_object.dart';
import 'package:mad_project/providers/favourite_docs_provider.dart';

class RecentFiles extends ConsumerWidget {
  final FileObject file;

  const RecentFiles({super.key, required this.file});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            onPressed: () {
              final wasAdded = ref
                  .read(favouriteDocsProvider.notifier)
                  .toggleFavourite(file);
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  duration: const Duration(seconds: 2),
                  content: Text(
                    wasAdded
                        ? "Doc is added to favourites"
                        : "Doc is removed from favourites",
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: Theme.of(context).colorScheme.onPrimaryFixed,
                        ),
                  ),
                  action: SnackBarAction(
                    label: "Undo",
                    onPressed: () {
                      ref
                          .read(favouriteDocsProvider.notifier)
                          .toggleFavourite(file);
                    },
                  )));
            },
            icon: ref.read(favouriteDocsProvider.notifier).isFavourite(file)
                ? const Icon(Icons.favorite)
                : const Icon(Icons.favorite_outline),
          )),
    );
  }
}
