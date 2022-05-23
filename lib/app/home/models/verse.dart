import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class Verse extends Equatable {
  const Verse(
      {required this.id,
      required this.book,
      required this.chapter,
      required this.verse,
      required this.text,
      required this.youtubeVid});
  final String id;
  final String book;
  final int chapter;
  final int verse;
  final String text;
  final String youtubeVid;

  @override
  List<Object> get props => [id, book, chapter, verse, text, youtubeVid];

  @override
  bool get stringify => true;

  factory Verse.fromMap(Map<String, dynamic>? data, String documentId) {
    if (data == null) {
      throw StateError('missing data for pageId: $documentId');
    }
    final book = data['book'] as String?;
    if (book == null) {
      throw StateError('missing book for pageId: $documentId');
    }
    final chapter = data['chapter'] as int;
    if (chapter == null) {
      throw StateError('missing chapter for pageId: $documentId');
    }
    final verse = data['verse'] as int;
    if (verse == null) {
      throw StateError('missing verse for pageId: $documentId');
    }
    final text = data['text'] as String?;
    if (text == null) {
      throw StateError('missing text for pageId: $documentId');
    }
    final youtubeVid = data['youtubeVid'] as String?;
    if (youtubeVid == null) {
      throw StateError('missing youtubeVid for pageId: $documentId');
    }
    return Verse(
        id: documentId,
        book: book,
        chapter: chapter,
        verse: verse,
        text: text,
        youtubeVid: youtubeVid);
  }

  Map<String, dynamic> toMap() {
    return {
      'book': book,
      'chapter': chapter,
      'verse': verse,
      'text': text,
      'youtubeVid': youtubeVid,
    };
  }
}
