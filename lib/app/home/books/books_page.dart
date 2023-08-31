import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hanarecite/app/home/book_pages/book_pages_page.dart';
import 'package:hanarecite/app/home/books/book_list_tile.dart';
import 'package:hanarecite/app/home/books/list_items_builder.dart';
import 'package:hanarecite/app/home/models/book.dart';
import 'package:alert_dialogs/alert_dialogs.dart';
import 'package:hanarecite/app/top_level_providers.dart';
import 'package:hanarecite/constants/strings.dart';
import 'package:pedantic/pedantic.dart';
import 'package:hanarecite/services/firestore_database.dart';

final booksStreamProvider = StreamProvider.autoDispose<List<Book>>((ref) {
  final database = ref.watch(databaseProvider)!;
  return database.booksStream();
});

// watch database
class BooksPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.books),
      ),
      body: _buildContents(context, ref),
    );
  }

  Widget _buildContents(BuildContext context, WidgetRef ref) {
    final booksAsyncValue = ref.watch(booksStreamProvider);
    return ListItemsBuilder<Book>(
      data: booksAsyncValue,
      itemBuilder: (context, book) => Dismissible(
        key: Key('book-${book.id}'),
        background: Container(color: Colors.blue),
        child: BookListTile(
          book: book,
          onTap: () => BookPagesPage.show(context, book),
        ),
      ),
    );
  }
}
