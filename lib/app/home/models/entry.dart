import 'package:equatable/equatable.dart';

class Entry extends Equatable {
  const Entry({
    required this.id,
    required this.jobId,
    required this.start,
    required this.end,
    required this.comment,
    required this.verseList,
  });

  final String id;
  final String jobId;
  final DateTime start;
  final DateTime end;
  final String comment;
  final String verseList;

  @override
  List<Object> get props => [id, jobId, start, end, comment, verseList];

  @override
  bool get stringify => true;

  double get durationInHours =>
      end.difference(start).inMinutes.toDouble() / 60.0;

  factory Entry.fromMap(Map<dynamic, dynamic>? value, String id) {
    if (value == null) {
      throw StateError('missing data for entryId: $id');
    }
    final startMilliseconds = value['start'] as int;
    final endMilliseconds = value['end'] as int;
    // final verseList = List.from(value['verseList'] as List<dynamic>);
    final verseList = value['verseList'] as String;
    print("verseList: $verseList");
    return Entry(
      id: id,
      jobId: value['jobId'] as String,
      start: DateTime.fromMillisecondsSinceEpoch(startMilliseconds),
      end: DateTime.fromMillisecondsSinceEpoch(endMilliseconds),
      comment: value['comment'] as String? ?? '',
      verseList: verseList,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'jobId': jobId,
      'start': start.millisecondsSinceEpoch,
      'end': end.millisecondsSinceEpoch,
      'comment': comment,
      'verseList': verseList,
    };
  }
}
