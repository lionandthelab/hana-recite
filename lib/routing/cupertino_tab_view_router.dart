import 'package:flutter/cupertino.dart';
import 'package:hanarecite/app/home/job_entries/job_entries_page.dart';
import 'package:hanarecite/app/home/book_pages/book_pages_page.dart';
import 'package:hanarecite/app/home/book_pages/chant_page.dart';
import 'package:hanarecite/app/home/models/job.dart';
import 'package:hanarecite/app/home/models/book.dart';

class CupertinoTabViewRoutes {
  static const jobEntriesPage = '/job-entries-page';
  static const bookPagesPage = '/book-pages-page';
  static const chantPage = '/chant-page';
}

class CupertinoTabViewRouter {
  static Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case CupertinoTabViewRoutes.jobEntriesPage:
        final job = settings.arguments as Job;
        return CupertinoPageRoute(
          builder: (_) => JobEntriesPage(job: job),
          settings: settings,
          fullscreenDialog: false,
        );
      case CupertinoTabViewRoutes.bookPagesPage:
        final book = settings.arguments as Book;
        return CupertinoPageRoute(
          builder: (_) => BookPagesPage(book: book),
          settings: settings,
          fullscreenDialog: false,
        );
      case CupertinoTabViewRoutes.chantPage:
        final vid = settings.arguments as String;
        return CupertinoPageRoute(
          builder: (_) => ChantPage(vid: vid),
          settings: settings,
          fullscreenDialog: true,
        );
    }
    return null;
  }
}
