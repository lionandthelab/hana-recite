import 'package:flutter/material.dart';
import 'package:hanarecite/app/home/book_pages/format.dart';
import 'package:hanarecite/app/home/models/page.dart' as PageModel;
import 'package:hanarecite/app/home/models/book.dart';

class PageListItem extends StatelessWidget {
  const PageListItem({
    required this.page,
    required this.book,
    this.onTap,
  });

  final PageModel.Page page;
  final Book book;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: _buildContents(context),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    final verseList = page.verseList;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Row(children: <Widget>[
        //   Text(dayOfWeek,
        //       style: const TextStyle(fontSize: 18.0, color: Colors.grey)),
        //   const SizedBox(width: 15.0),
        //   Text(startDate, style: const TextStyle(fontSize: 18.0)),
        //   if (book.ratePerHour > 0.0) ...<Widget>[
        //     Expanded(child: Container()),
        //     Text(
        //       payFormatted,
        //       style: TextStyle(fontSize: 16.0, color: Colors.green[700]),
        //     ),
        //   ],
        // ]),
        // Row(children: <Widget>[
        //   Text('$startTime - $endTime', style: const TextStyle(fontSize: 16.0)),
        //   Expanded(child: Container()),
        //   Text(durationFormatted, style: const TextStyle(fontSize: 16.0)),
        // ]),
        if (page.title.isNotEmpty)
          Text(
            page.title,
            style: const TextStyle(fontSize: 12.0),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        if (page.verseList.isNotEmpty)
          Text(verseList, style: const TextStyle(fontSize: 12.0)),
      ],
    );
  }
}

class DismissiblePageListItem extends StatelessWidget {
  const DismissiblePageListItem({
    required this.dismissibleKey,
    required this.page,
    required this.book,
    this.onDismissed,
    this.onTap,
  });

  final Key dismissibleKey;
  final PageModel.Page page;
  final Book book;
  final VoidCallback? onDismissed;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      background: Container(color: Colors.red),
      key: dismissibleKey,
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => onDismissed?.call(),
      child: PageListItem(
        page: page,
        book: book,
        onTap: onTap,
      ),
    );
  }
}
