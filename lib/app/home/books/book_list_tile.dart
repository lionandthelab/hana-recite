import 'package:flutter/material.dart';
import 'package:hanarecite/app/home/models/book.dart';

class BookListTile extends StatelessWidget {
  const BookListTile({Key? key, required this.book, this.onTap})
      : super(key: key);
  final Book book;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(book.title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
