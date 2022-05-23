import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hanarecite/app/top_level_providers.dart';
import 'package:hanarecite/common_widgets/date_time_picker.dart';
import 'package:hanarecite/app/home/job_entries/format.dart';
import 'package:hanarecite/app/home/models/entry.dart';
import 'package:hanarecite/app/home/models/job.dart';
import 'package:alert_dialogs/alert_dialogs.dart';
import 'package:hanarecite/routing/app_router.dart';
import 'package:hanarecite/services/firestore_database.dart';
import 'package:pedantic/pedantic.dart';
import 'package:just_audio/just_audio.dart';

class EntryPage extends ConsumerStatefulWidget {
  const EntryPage({required this.job, this.entry});
  final Job job;
  final Entry? entry;

  static Future<void> show(
      {required BuildContext context, required Job job, Entry? entry}) async {
    await Navigator.of(context, rootNavigator: true).pushNamed(
      AppRoutes.entryPage,
      arguments: {
        'job': job,
        'entry': entry,
      },
    );
  }

  @override
  _EntryPageState createState() => _EntryPageState();
}

class _EntryPageState extends ConsumerState<EntryPage> {
  late DateTime _startDate;
  late TimeOfDay _startTime;
  late DateTime _endDate;
  late TimeOfDay _endTime;
  late String _comment;
  late String _verseList;
  late AudioPlayer player;

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();

    final start = widget.entry?.start ?? DateTime.now();
    _startDate = DateTime(start.year, start.month, start.day);
    _startTime = TimeOfDay.fromDateTime(start);

    final end = widget.entry?.end ?? DateTime.now();
    _endDate = DateTime(end.year, end.month, end.day);
    _endTime = TimeOfDay.fromDateTime(end);

    _comment = widget.entry?.comment ?? '';
    _verseList = widget.entry?.verseList ?? '';
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  Entry _entryFromState() {
    final start = DateTime(_startDate.year, _startDate.month, _startDate.day,
        _startTime.hour, _startTime.minute);
    final end = DateTime(_endDate.year, _endDate.month, _endDate.day,
        _endTime.hour, _endTime.minute);
    final id = widget.entry?.id ?? documentIdFromCurrentDate();
    return Entry(
        id: id,
        jobId: widget.job.id,
        start: start,
        end: end,
        comment: _comment,
        verseList: '');
  }

  Future<void> _setEntryAndDismiss() async {
    try {
      final database = ref.read<FirestoreDatabase?>(databaseProvider)!;
      final entry = _entryFromState();
      await database.setEntry(entry);
      Navigator.of(context).pop();
    } catch (e) {
      unawaited(showExceptionAlertDialog(
        context: context,
        title: 'Operation failed',
        exception: e,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(widget.job.name),
        actions: <Widget>[
          TextButton(
            child: Text(
              widget.entry != null ? '음성파일 재생' : '음성파일 추가',
              style: const TextStyle(fontSize: 18.0, color: Colors.white),
            ),
            // onPressed: () => _setEntryAndDismiss(),
            onPressed: () async {
              await player.setAsset(
                  'https://www.applesaucekids.com/sound%20effects/moo.mp3');
              player.play();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // _buildStartDate(),
              // _buildEndDate(),
              // const SizedBox(height: 8.0),
              // _buildDuration(),
              // const SizedBox(height: 8.0),
              _buildComment(),
              const SizedBox(height: 8.0),
              _buildVerseList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStartDate() {
    return DateTimePicker(
      labelText: 'Start',
      selectedDate: _startDate,
      selectedTime: _startTime,
      onSelectedDate: (date) => setState(() => _startDate = date),
      onSelectedTime: (time) => setState(() => _startTime = time),
    );
  }

  Widget _buildEndDate() {
    return DateTimePicker(
      labelText: 'End',
      selectedDate: _endDate,
      selectedTime: _endTime,
      onSelectedDate: (date) => setState(() => _endDate = date),
      onSelectedTime: (time) => setState(() => _endTime = time),
    );
  }

  Widget _buildDuration() {
    final currentEntry = _entryFromState();
    final durationFormatted = Format.hours(currentEntry.durationInHours);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text(
          'Duration: $durationFormatted',
          style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildComment() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text(
          '$_comment',
          style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildVerseList() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text(
          '$_verseList',
          style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
