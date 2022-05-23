import 'dart:async';

import 'package:alert_dialogs/alert_dialogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedantic/pedantic.dart';
import 'package:hanarecite/app/home/book_pages/page_list_item.dart';
import 'package:hanarecite/app/home/book_pages/page_page.dart';
import 'package:hanarecite/app/home/books/list_items_builder.dart';
import 'package:hanarecite/app/home/models/page.dart' as PageModel;
import 'package:hanarecite/app/home/models/book.dart';
import 'package:hanarecite/app/top_level_providers.dart';
import 'package:hanarecite/routing/cupertino_tab_view_router.dart';

class BookPagesPage extends StatelessWidget {
  const BookPagesPage({required this.book});
  final Book book;

  static Future<void> show(BuildContext context, Book book) async {
    await Navigator.of(context).pushNamed(
      CupertinoTabViewRoutes.bookPagesPage,
      arguments: book,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: BookPagesAppBarTitle(book: book),
        centerTitle: true,
      ),
      body: BookPagesContents(book: book),
    );
  }
}

final bookStreamProvider =
    StreamProvider.autoDispose.family<Book, String>((ref, bookId) {
  final database = ref.watch(databaseProvider)!;
  return database.bookStream(bookId: bookId);
});

class BookPagesAppBarTitle extends ConsumerWidget {
  const BookPagesAppBarTitle({required this.book});
  final Book book;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookAsyncValue = ref.watch(bookStreamProvider(book.id));
    return bookAsyncValue.when(
      data: (book) => Text(book.title),
      loading: () => Container(),
      error: (_, __) => Container(),
    );
  }
}

final bookPagesStreamProvider =
    StreamProvider.autoDispose.family<List<PageModel.Page>, Book>((ref, book) {
  final database = ref.watch(databaseProvider)!;
  return database.pagesStream(book: book);
});

class BookPagesContents extends ConsumerWidget {
  final Book book;
  const BookPagesContents({required this.book});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pagesStream = ref.watch(bookPagesStreamProvider(book));
    return ListItemsBuilder<PageModel.Page>(
      data: pagesStream,
      itemBuilder: (context, page) {
        return DismissiblePageListItem(
          dismissibleKey: Key('page-${page.id}'),
          page: page,
          book: book,
          onDismissed: () => PagePage.show(
            context: context,
            book: book,
            page: page,
          ),
          onTap: () => PagePage.show(
            context: context,
            book: book,
            page: page,
          ),
        );
      },
    );
  }
}
