import 'package:email_password_sign_in_ui/email_password_sign_in_ui.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hanarecite/app/home/job_entries/entry_page.dart';
import 'package:hanarecite/app/home/jobs/edit_job_page.dart';
import 'package:hanarecite/app/home/models/entry.dart';
import 'package:hanarecite/app/home/models/job.dart';
import 'package:hanarecite/app/home/models/book.dart';
import 'package:hanarecite/app/home/models/page.dart' as PageModel;
import 'package:hanarecite/app/home/book_pages/page_page.dart';
import 'package:hanarecite/app/home/book_pages/chant_page.dart';

class AppRoutes {
  static const emailPasswordSignInPage = '/email-password-sign-in-page';
  static const editJobPage = '/edit-job-page';
  static const entryPage = '/entry-page';
  static const pagePage = '/page-page';
  static const chantPage = '/chant-page';
}

class AppRouter {
  static Route<dynamic>? onGenerateRoute(
      RouteSettings settings, FirebaseAuth firebaseAuth) {
    final args = settings.arguments;
    switch (settings.name) {
      case AppRoutes.emailPasswordSignInPage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => EmailPasswordSignInPage.withFirebaseAuth(firebaseAuth,
              onSignedIn: args as void Function()),
          settings: settings,
          fullscreenDialog: true,
        );
      case AppRoutes.editJobPage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => EditJobPage(job: args as Job?),
          settings: settings,
          fullscreenDialog: true,
        );
      case AppRoutes.entryPage:
        final mapArgs = args as Map<String, dynamic>;
        final job = mapArgs['job'] as Job;
        final entry = mapArgs['entry'] as Entry?;
        return MaterialPageRoute<dynamic>(
          builder: (_) => EntryPage(job: job, entry: entry),
          settings: settings,
          fullscreenDialog: true,
        );
      case AppRoutes.pagePage:
        final mapArgs = args as Map<String, dynamic>;
        final book = mapArgs['book'] as Book;
        final page = mapArgs['page'] as PageModel.Page?;
        return MaterialPageRoute<dynamic>(
          builder: (_) => PagePage(book: book, page: page),
          settings: settings,
          fullscreenDialog: true,
        );
      case AppRoutes.chantPage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => ChantPage(vid: args as String),
          settings: settings,
          fullscreenDialog: true,
        );
      default:
        // TODO: Throw
        return null;
    }
  }
}
