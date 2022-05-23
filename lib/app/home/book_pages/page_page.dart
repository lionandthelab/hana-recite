import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hanarecite/app/top_level_providers.dart';
import 'package:hanarecite/common_widgets/date_time_picker.dart';
import 'package:hanarecite/app/home/book_pages/format.dart';
import 'package:hanarecite/app/home/models/page.dart' as PageModel;
import 'package:hanarecite/app/home/models/book.dart';
import 'package:alert_dialogs/alert_dialogs.dart';
import 'package:hanarecite/routing/app_router.dart';
import 'package:hanarecite/services/firestore_database.dart';
import 'package:pedantic/pedantic.dart';
import 'package:just_audio/just_audio.dart';

class PagePage extends ConsumerStatefulWidget {
  const PagePage({required this.book, this.page});
  final Book book;
  final PageModel.Page? page;

  static Future<void> show(
      {required BuildContext context,
      required Book book,
      PageModel.Page? page}) async {
    await Navigator.of(context, rootNavigator: true).pushNamed(
      AppRoutes.pagePage,
      arguments: {
        'book': book,
        'page': page,
      },
    );
  }

  @override
  _PagePageState createState() => _PagePageState();
}

class _PagePageState extends ConsumerState<PagePage> {
  late String _title;
  late String _bgUrl;
  late String _voiceUrl;
  late String _verseList;
  late AudioPlayer player;

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();

    _title = widget.page?.title ?? '';
    _bgUrl = widget.page?.bgUrl ?? '';
    _voiceUrl = widget.page?.voiceUrl ?? '';
    _verseList = widget.page?.verseList ?? '';
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  PageModel.Page _pageFromState() {
    final id = widget.page?.id ?? documentIdFromCurrentDate();
    return PageModel.Page(
      id: id,
      bookId: widget.book.id,
      pageIndex: widget.page?.pageIndex as int,
      title: _title,
      bgUrl: _bgUrl,
      voiceUrl: _voiceUrl,
      verseList: _verseList,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(widget.book.title),
        actions: <Widget>[
          TextButton(
            child: Text(
              widget.page != null ? '음성파일 재생' : '음성파일 추가',
              style: const TextStyle(fontSize: 18.0, color: Colors.white),
            ),
            // onPressed: () => _setPageAndDismiss(),
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
              // _buildComment(),
              // const SizedBox(height: 8.0),
              _buildVerseList(),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildStartDate() {
  //   return DateTimePicker(
  //     labelText: 'Start',
  //     selectedDate: _startDate,
  //     selectedTime: _startTime,
  //     onSelectedDate: (date) => setState(() => _startDate = date),
  //     onSelectedTime: (time) => setState(() => _startTime = time),
  //   );
  // }

  // Widget _buildEndDate() {
  //   return DateTimePicker(
  //     labelText: 'End',
  //     selectedDate: _endDate,
  //     selectedTime: _endTime,
  //     onSelectedDate: (date) => setState(() => _endDate = date),
  //     onSelectedTime: (time) => setState(() => _endTime = time),
  //   );
  // }

  // Widget _buildDuration() {
  //   final currentPage = _pageFromState();
  //   final durationFormatted = Format.hours(currentPage.durationInHours);
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.end,
  //     children: <Widget>[
  //       Text(
  //         'Duration: $durationFormatted',
  //         style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
  //         maxLines: 1,
  //         overflow: TextOverflow.ellipsis,
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildComment() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.end,
  //     children: <Widget>[
  //       Text(
  //         '$_comment',
  //         style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
  //         maxLines: 1,
  //         overflow: TextOverflow.ellipsis,
  //       ),
  //     ],
  //   );
  // }

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
