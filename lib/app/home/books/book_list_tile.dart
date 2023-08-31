import 'package:flutter/material.dart';
import 'package:hanarecite/app/home/models/book.dart';

class BookListTile extends StatelessWidget {
  const BookListTile({Key? key, required this.book, this.onTap})
      : super(key: key);
  final Book book;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Card(
          margin: EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ListTile(
                contentPadding: const EdgeInsets.all(16.0),
                leading: Icon(Icons.menu_book_outlined, size: 48.0),
                title: Text(book.title,
                    style: const TextStyle(
                        fontSize: 16.0, fontWeight: FontWeight.bold)),
                subtitle: Text(book.publisher,
                    style: const TextStyle(fontSize: 14.0)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    child: const Text('읽기',
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold)),
                    onPressed: onTap,
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ],
          ),
        ));
  }
}
