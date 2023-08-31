import 'dart:async';

import 'package:firestore_service/firestore_service.dart';
import 'package:hanarecite/app/home/models/entry.dart';
import 'package:hanarecite/app/home/models/job.dart';
import 'package:hanarecite/app/home/models/book.dart';
import 'package:hanarecite/app/home/models/page.dart';
import 'package:hanarecite/app/home/models/verse.dart';
import 'package:hanarecite/services/firestore_path.dart';

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase {
  FirestoreDatabase({required this.uid});
  final String uid;

  final _service = FirestoreService.instance;

  Future<void> setJob(Job job) => _service.setData(
        path: FirestorePath.job(uid, job.id),
        data: job.toMap(),
      );

  Future<void> deleteJob(Job job) async {
    // delete where entry.jobId == job.jobId
    final allEntries = await entriesStream(job: job).first;
    for (final entry in allEntries) {
      if (entry.jobId == job.id) {
        await deleteEntry(entry);
      }
    }
    // delete job
    await _service.deleteData(path: FirestorePath.job(uid, job.id));
  }

  Stream<Job> jobStream({required String jobId}) => _service.documentStream(
        path: FirestorePath.job(uid, jobId),
        builder: (data, documentId) => Job.fromMap(data, documentId),
      );

  Stream<List<Job>> jobsStream() => _service.collectionStream(
        path: FirestorePath.jobs(uid),
        builder: (data, documentId) => Job.fromMap(data, documentId),
      );

  Future<void> setEntry(Entry entry) => _service.setData(
        path: FirestorePath.entry(uid, entry.id),
        data: entry.toMap(),
      );

  Future<void> deleteEntry(Entry entry) =>
      _service.deleteData(path: FirestorePath.entry(uid, entry.id));

  Stream<List<Entry>> entriesStream({Job? job}) =>
      _service.collectionStream<Entry>(
        path: FirestorePath.entries(uid),
        queryBuilder: job != null
            ? (query) => query.where('jobId', isEqualTo: job.id)
            : null,
        builder: (data, documentID) => Entry.fromMap(data, documentID),
        sort: (lhs, rhs) => rhs.start.compareTo(lhs.start),
      );

  // Book
  Stream<Book> bookStream({required String bookId}) => _service.documentStream(
        path: FirestorePath.book(bookId),
        builder: (data, documentId) => Book.fromMap(data, documentId),
      );

  Stream<List<Book>> booksStream() => _service.collectionStream(
        path: FirestorePath.books(),
        builder: (data, documentId) => Book.fromMap(data, documentId),
        sort: (lhs, rhs) => rhs.publisher.compareTo(lhs.publisher),
      );

  // Page
  Stream<List<Page>> pagesStream({Book? book}) =>
      _service.collectionStream<Page>(
        path: FirestorePath.pages(),
        queryBuilder: book != null
            ? (query) => query.where('bookId', isEqualTo: book.id)
            : null,
        builder: (data, documentID) => Page.fromMap(data, documentID),
        sort: (lhs, rhs) => lhs.pageIndex.compareTo(rhs.pageIndex),
      );

  // Verse
  Stream<Verse> verseStream({required String verseId}) =>
      _service.documentStream(
        path: FirestorePath.verse(verseId),
        builder: (data, documentId) => Verse.fromMap(data, documentId),
      );
}
