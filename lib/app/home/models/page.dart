import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class Page extends Equatable {
  const Page(
      {required this.id,
      required this.bookId,
      required this.pageIndex,
      required this.title,
      required this.bgUrl,
      required this.voiceUrl,
      required this.verseList});
  final String id;
  final String bookId;
  final int pageIndex;
  final String title;
  final String bgUrl;
  final String voiceUrl;
  final String verseList;

  @override
  List<Object> get props =>
      [id, bookId, pageIndex, title, bgUrl, voiceUrl, verseList];

  @override
  bool get stringify => true;

  factory Page.fromMap(Map<String, dynamic>? data, String documentId) {
    if (data == null) {
      throw StateError('missing data for pageId: $documentId');
    }
    final bookId = data['bookId'] as String?;
    if (bookId == null) {
      throw StateError('missing bookId for pageId: $documentId');
    }
    final pageIndex = data['pageIndex'] as int;
    if (pageIndex == null) {
      throw StateError('missing pageIndex for pageId: $documentId');
    }
    final title = data['title'] as String?;
    if (title == null) {
      throw StateError('missing title for pageId: $documentId');
    }
    final bgUrl = data['bgUrl'] as String?;
    if (bgUrl == null) {
      throw StateError('missing bgUrl for pageId: $documentId');
    }
    final voiceUrl = data['voiceUrl'] as String?;
    if (voiceUrl == null) {
      throw StateError('missing voiceUrl for pageId: $documentId');
    }
    final verseList = data['verseList'] as String?;
    if (verseList == null) {
      throw StateError('missing verseList for pageId: $documentId');
    }
    return Page(
        id: documentId,
        bookId: bookId,
        pageIndex: pageIndex,
        title: title,
        bgUrl: bgUrl,
        voiceUrl: voiceUrl,
        verseList: verseList);
  }

  Map<String, dynamic> toMap() {
    return {
      'bookId': bookId,
      'pageIndex': pageIndex,
      'title': title,
      'bgUrl': bgUrl,
      'voiceUrl': voiceUrl,
      'verseList': verseList,
    };
  }
}
