import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class Book extends Equatable {
  const Book({required this.id, required this.title, required this.publisher});
  final String id;
  final String title;
  final String publisher;

  @override
  List<Object> get props => [id, title, publisher];

  @override
  bool get stringify => true;

  factory Book.fromMap(Map<String, dynamic>? data, String documentId) {
    if (data == null) {
      throw StateError('missing data for bookId: $documentId');
    }
    final title = data['title'] as String?;
    if (title == null) {
      throw StateError('missing title for bookId: $documentId');
    }
    final publisher = data['publisher'] as String?;
    if (publisher == null) {
      throw StateError('missing publisher for bookId: $documentId');
    }
    return Book(id: documentId, title: title, publisher: publisher);
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'publisher': publisher,
    };
  }
}
